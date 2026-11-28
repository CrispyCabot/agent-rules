---
name: vectorcraft
description: Use when asked to design, draw, edit or export vector artwork (invitations, cards, posters, logos, icons, flyers, SVG/PDF art) in VectorCraft, or when vectorcraft MCP tools are missing or can't reach the app.
---

# VectorCraft

VectorCraft is Chris's own vector editor (Illustrator-like). Claude drives it through an MCP server that forwards tool calls to the running app over a loopback control port, so every edit shows up live in the window.

## Paths

| What | Where |
| --- | --- |
| Project (source, docs) | `C:\Users\cbrid\OneDrive\Documents\Projects\vectorcraft` |
| App | `...\vectorcraft\target\release\vectorcraft.exe` |
| CLI / MCP server | `...\vectorcraft\target\release\vectorcraft-cli.exe` |
| Tool reference | `...\vectorcraft\docs\mcp.md`, `docs\control-protocol.md` |
| Working example | `C:\Users\cbrid\OneDrive\Documents\Wedding Invitation` and `C:\Users\cbrid\OneDrive\Desktop\Open VectorCraft.bat` |

If the exes are missing, build them from the project: `cargo build --release`.

## Starting a live session

Two pieces must line up on the same port (7979 by convention):

1. **The app**, started with its control port: `vectorcraft.exe --control 7979 [file.vectorcraft]`.
2. **Claude Code**, started with an MCP config pointing `vectorcraft-cli mcp --connect 127.0.0.1:7979` at it.

Put this `vectorcraft-mcp.json` in the design's working folder:

```json
{
  "mcpServers": {
    "vectorcraft": {
      "command": "C:\\Users\\cbrid\\OneDrive\\Documents\\Projects\\vectorcraft\\target\\release\\vectorcraft-cli.exe",
      "args": ["mcp", "--connect", "127.0.0.1:7979"]
    }
  }
}
```

Launch from that folder (app first; the MCP server only connects at Claude startup):

```bat
start "" "C:\Users\cbrid\OneDrive\Documents\Projects\vectorcraft\target\release\vectorcraft.exe" --control 7979 "My Design.vectorcraft"
claude --mcp-config vectorcraft-mcp.json
```

For a repeatable one-click start, copy the launcher in [launcher-template.bat](launcher-template.bat) next to the desktop's `Open VectorCraft.bat`, set `WORK` and `DOC`, and give it its own name (e.g. `Open VectorCraft - Poster.bat`). It starts the app, waits up to 30 s for the port, then opens Claude in `WORK` with the config. Don't repurpose the wedding launcher.

## Which situation are you in?

| Situation | Do this |
| --- | --- |
| `vectorcraft` MCP tools are available and `inspect_document` answers | Work live. |
| Tools available but calls fail to connect | The app isn't running on 7979. Start it (`start "" ...vectorcraft.exe --control 7979 <file>`), then retry. Check with `Test-NetConnection 127.0.0.1 -Port 7979`. |
| No `vectorcraft` tools in this session | Start the app, write `vectorcraft-mcp.json` into the working folder, and tell Chris to restart Claude there with `claude --mcp-config vectorcraft-mcp.json`. MCP servers can't be attached mid-session. |
| Non-interactive job (convert, batch export, inspect a file) | Skip the GUI: use `vectorcraft-cli` directly (below). |

With no `--connect`, `vectorcraft-cli mcp` tries 7979 and silently falls back to a headless session: edits then go to an invisible document. Keep `--connect` in the config so a missing app is an error, not a silent fork.

## Working loop

1. `inspect_document` to get artboards and object ids before editing.
2. Make the change (`draw_shape`, `draw_path`, `add_text`, `set_paint`, `transform`, or `run_command` for anything else; `list_commands {filter}` finds command ids and params).
3. `save_file {path}` after every change. Unsaved work has been lost before.
4. `screenshot` and look at it before saying the change is done.
5. Deliverables: `export` to `.pdf` / `.png` (e.g. `options: {"ppi": 300}`) in the working folder.

New documents default to 612 × 792 pt (US Letter); set size with `run_command file.new {width, height}` (points, 72/in). Coordinates are points, y down, origin at the first artboard's top-left.

Keep a `CLAUDE.md` and `README.md` in each design folder (purpose, file names, colours, fonts, how to launch) the way `Wedding Invitation` does, and keep the launcher, MCP config and README in agreement when any of them change.

## Headless CLI

```sh
vectorcraft-cli info design.vectorcraft
vectorcraft-cli convert design.vectorcraft out.pdf
vectorcraft-cli run --in art.svg --cmd select.all --cmd paint.setFill --params '{"color":"#ff0000"}' --export out.png --scale 2
vectorcraft-cli commands
```

## Gotchas

- `vectorcraft.exe --help` opens the GUI instead of printing help; use `vectorcraft-cli --help`.
- `vectorcraft-cli mcp --help` is an error; the modes are `--connect ADDR` and `--headless`.
- UI-only tools (`inspect_ui`, `type_text`, `open_panel`, `screenshot {window:true}`) need the live app.
- Only one app should hold a port. To run a second design at once, use another port (e.g. 7980) in both the app flag and that folder's MCP config.
- Fonts not installed on Windows render in a fallback. After installing one, `run_command text.rescanFonts`, then `text.replaceFont` if swapping.
