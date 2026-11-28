# Global rules

- Comments should be extremely minimal. Code should explain itself; comments are a last resort.
- When editing a project, read its CLAUDE.md first.
- Don't use emojis in any repository source controlled files (code, README's, etc.)
- Documentation (READMEs, CLAUDE.md, docs/) must read as standalone documentation for any reader, never as a reply to my prompt (no "Yes, there is...", "So it does..."). Describe how things work; answers to my questions go in the chat response.
- Whenever making new typescript interfaces, every single interface should go in a separate file. Do not define multiple interfaces per file
- At the end of every task, if relevant, update the CLAUDE.md and README.md, keeping the README.md concise and aimed towards helping developers easily while the CLAUDE.md can contain much more information to help yourself in the future.
- Keep comments in code as concise as possible. All comments should ONLY be there to clarify possibly confusing things. Don't comment things that can be determined from reading the code. Don't comment in a reply style indicating the work that was done. Comments should be a MAXIMUM length of 3 lines, no exceptions. If a comment genuinely seems like it needs to be longer than 3 lines to convey the necessary context, do not write the longer version into the file - instead say so directly to me in your response and let me decide.
- When creating a new personal project (CrispyCabot account), also add it to the portfolio site, CrispyCabot/chrisbridewell-home-website (chrisbridewell.dev). Add an entry in `app/src/content/projects.ts`: under `liveApps` with its `liveUrl` if it is deployed for others to use, otherwise under `earlierProjects`. Keep that entry current when the project's name, URL or purpose changes.
