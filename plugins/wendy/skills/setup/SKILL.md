---
name: setup
description: One-time Wendy setup on this machine. Offers a short name for the Footbridge connection, checks it, then offers to allow the Footbridge tools and a `wendy` shell alias. Use when the user runs /wendy:setup or asks how to set Wendy up.
disable-model-invocation: true
---

Set Wendy up on this machine. Ask before changing anything, and do each step only once.

## 1. Name the connection (ask first)

The plugin ships the Footbridge connection, but Claude Code names a plugin-supplied server `plugin:wendy:footbridge`, which makes every tool read `mcp__plugin_wendy_footbridge__ledger___…`. Adding the same server yourself gives it the short name `footbridge` on every machine; Claude Code then skips the plugin's copy as a duplicate.

- Run `claude mcp list`. If a server named exactly `footbridge` is already there, say so and skip to step 2.
- Otherwise offer to add it:

```sh
claude mcp add --transport http footbridge https://mcp.dev.footbridge.ai/mcp \
  --client-id 5bbe4d92-9daa-493c-85eb-8aec8ae6fa0e --callback-port 8080 -s user
```

- Say what it costs: Claude Code has to restart to pick it up, and they sign in once for the new name (`/mcp` → `footbridge` → Authenticate).
- Only after the user says yes, run it. Then tell them to restart Claude Code, run `/mcp` and Authenticate, and run `/wendy:setup` again to finish. Stop there.
- If they decline, carry on with the plugin's own connection. Everything works; the tool names are just longer.

## 2. Connection

Look for a tool whose name ends in `ledger___health`. If tools are deferred, load it with tool search (query: `ledger___health`). Only a name ending in exactly `ledger___health` counts.

- **Available:** call it. If it succeeds, say "Connected to the Footbridge ledger." and continue.
- **Missing, or the call fails with an authorization error:** tell the user to run `/mcp`, pick the `footbridge` server, choose **Authenticate**, and sign in with their Footbridge Microsoft account in the browser window that opens. Then ask them to run `/wendy:setup` again, and stop here.

## 3. Allow the Footbridge tools (ask first)

Without this, Claude Code asks for approval the first time each Footbridge tool is used.

- Work out the server's permission name from the full name of the tool you found in step 2: drop the trailing `__ledger___health`. For example, `mcp__plugin_wendy_footbridge__ledger___health` gives `mcp__plugin_wendy_footbridge`, and `mcp__footbridge-mcp-dev__ledger___health` gives `mcp__footbridge-mcp-dev`. The name depends on how the server was added on this machine, so never guess it.
- Read `~/.claude/settings.json` (treat a missing file as `{}`). If `permissions.allow` already contains that name, say so and skip.
- Otherwise offer to add it: one entry allows every tool on that server (the ledger, Bullhorn and the rest) without a prompt. The data is still limited to what the user's own Microsoft sign-in can see.
- Only after the user says yes, add the name to `permissions.allow`, creating `permissions` or `allow` if needed. Keep every other setting exactly as it was, and make sure the file is still valid JSON.

## 4. The `wendy` alias (ask first)

Offer to add this line so that typing `wendy` in a terminal starts a Wendy session:

```sh
alias wendy='WENDY=1 claude'
```

- Detect the shell from `$SHELL`: `~/.zshrc` for zsh, `~/.bashrc` for bash. For any other shell, show the line and let the user add it themselves.
- If the file already defines `alias wendy=`, say so and skip.
- Only after the user says yes, append the line with a comment above it (`# Wendy (Footbridge plugin)`), and tell them to open a new terminal or `source` the file.
- Mention that flags pass through: `wendy --continue`, `wendy --resume`, `wendy -p "..."`.

## 5. Done

Finish with a four-line summary: the connection name, the connection state, the tool approvals (added, skipped or declined), and the alias (added, skipped or declined).
