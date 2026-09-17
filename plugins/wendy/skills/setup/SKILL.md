---
name: setup
description: One-time Wendy setup on this machine. Checks the Footbridge connection, then offers to allow the Footbridge tools, a `wendy` shell alias, and a desk folder. Use when the user runs /wendy:setup or asks how to set Wendy up.
disable-model-invocation: true
---

Set Wendy up on this machine. Ask before changing anything, and do each step only once.

## 1. Connection

Look for a tool whose name ends in `ledger___health`. If tools are deferred, load it with tool search (query: `ledger___health`). Only a name ending in exactly `ledger___health` counts.

- **Available:** call it. If it succeeds, say "Connected to the Footbridge ledger." and continue.
- **Missing, or the call fails with an authorization error:** tell the user to run `/mcp`, pick the `footbridge` server, choose **Authenticate**, and sign in with their Footbridge Microsoft account in the browser window that opens. Then ask them to run `/wendy:setup` again, and stop here.

## 2. Allow the Footbridge tools (ask first)

Without this, Claude Code asks for approval the first time each Footbridge tool is used.

- Work out the server's permission name from the full name of the tool you found in step 1: drop the trailing `__ledger___health`. For example, `mcp__plugin_wendy_footbridge__ledger___health` gives `mcp__plugin_wendy_footbridge`, and `mcp__footbridge-mcp-dev__ledger___health` gives `mcp__footbridge-mcp-dev`. The name depends on how the server was added on this machine, so never guess it.
- Read `~/.claude/settings.json` (treat a missing file as `{}`). If `permissions.allow` already contains that name, say so and skip.
- Otherwise offer to add it: one entry allows every tool on that server (the ledger, Bullhorn and the rest) without a prompt. The data is still limited to what the user's own Microsoft sign-in can see.
- Only after the user says yes, add the name to `permissions.allow`, creating `permissions` or `allow` if needed. Keep every other setting exactly as it was, and make sure the file is still valid JSON.

## 3. The `wendy` alias (ask first)

Offer to add this line so that typing `wendy` in a terminal starts a Wendy session:

```sh
alias wendy='WENDY=1 claude'
```

- Detect the shell from `$SHELL`: `~/.zshrc` for zsh, `~/.bashrc` for bash. For any other shell, show the line and let the user add it themselves.
- If the file already defines `alias wendy=`, say so and skip.
- Only after the user says yes, append the line with a comment above it (`# Wendy (Footbridge plugin)`), and tell them to open a new terminal or `source` the file.
- Mention that flags pass through: `wendy --continue`, `wendy --resume`, `wendy -p "..."`.

## 4. A desk folder (ask first)

A desk is a folder where every Claude Code session starts as Wendy, and where her notes about the user live. `--continue` and memory are per folder, so a desk gives Wendy one steady home.

Ask which folder to use. Suggest `~/wendy`; an existing folder is fine too. Only after the user confirms:

- Create the folder if it does not exist.
- If `<folder>/.claude/wendy-desk` already exists, say the folder is already a desk and skip the rest of this step.
- Create an empty marker file `<folder>/.claude/wendy-desk`. The plugin's session-start hook looks for it and turns the session into Wendy.
- Only if `<folder>/CLAUDE.md` does not exist, create it with this stub. Never overwrite or edit an existing CLAUDE.md:

  ```markdown
  # About me

  Notes for Wendy: my name, my role, how I like briefs, standing priorities.
  Claude Code reads this at the start of every session in this folder.
  ```

- Tell the user: `cd <folder> && claude` (or just `wendy` from anywhere). A session already running needs a restart (or `/clear`) to pick Wendy up. If the folder is a git repository, mention that `.claude/wendy-desk` can be committed so the folder is a desk on every clone.

## 5. Done

Finish with a four-line summary: the connection state, the tool approvals (added, skipped or declined), the alias (added, skipped or declined), and the desk folder (created, skipped or declined).
