---
name: setup
description: One-time Wendy setup on this machine. Checks the Footbridge connection, then offers to allow the Footbridge tools and a `wendy` shell alias. Use when the user runs /wendy:setup or asks how to set Wendy up.
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

## 4. Done

Finish with a three-line summary: the connection state, the tool approvals (added, skipped or declined), and the alias (added, skipped or declined).
