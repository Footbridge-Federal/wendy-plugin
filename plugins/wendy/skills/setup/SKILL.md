---
name: setup
description: One-time Wendy setup on this machine. Checks the Footbridge connection, then offers a `wendy` shell alias and a `~/wendy` desk folder. Use when the user runs /wendy:setup or asks how to set Wendy up.
disable-model-invocation: true
---

Set Wendy up on this machine. Ask before changing anything, and do each step only once.

## 1. Connection

Look for a tool whose name ends in `ledger___health`. If tools are deferred, load it with tool search (query: `ledger___health`). Only a name ending in exactly `ledger___health` counts.

- **Available:** call it. If it succeeds, say "Connected to the Footbridge ledger." and continue.
- **Missing, or the call fails with an authorization error:** tell the user to run `/mcp`, pick the `footbridge` server, choose **Authenticate**, and sign in with their Footbridge Microsoft account in the browser window that opens. Then ask them to run `/wendy:setup` again, and stop here.

## 2. The `wendy` alias (ask first)

Offer to add this line so that typing `wendy` in a terminal starts a Wendy session:

```sh
alias wendy='WENDY=1 claude'
```

- Detect the shell from `$SHELL`: `~/.zshrc` for zsh, `~/.bashrc` for bash. For any other shell, show the line and let the user add it themselves.
- If the file already defines `alias wendy=`, say so and skip.
- Only after the user says yes, append the line with a comment above it (`# Wendy (Footbridge plugin)`), and tell them to open a new terminal or `source` the file.

## 3. A desk folder (ask first)

Offer to create `~/wendy`, a folder where every Claude Code session starts as Wendy, and where her notes about the user live. Only after the user says yes:

- Create an empty marker file `~/wendy/.claude/wendy-desk`. The plugin's session-start hook looks for it and turns the session into Wendy.
- Create `~/wendy/CLAUDE.md`, unless it exists, with this stub:

  ```markdown
  # About me

  Notes for Wendy: my name, my role, how I like briefs, standing priorities.
  Claude Code reads this at the start of every session in this folder.
  ```

- Tell the user: `cd ~/wendy && claude` (or just `wendy` from anywhere). A session already running needs a restart (or `/clear`) to pick Wendy up.

## 4. Done

Finish with a three-line summary: the connection state, the alias (added, skipped or declined), and the desk folder (created, skipped or declined).
