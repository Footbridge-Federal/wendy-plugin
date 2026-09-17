---
name: setup
description: One-time Wendy setup on this machine. Offers a short name for the Footbridge connection, checks it, then offers to allow the Footbridge tools and a `wendy` shell alias. Use when the user runs /wendy:setup or asks how to set Wendy up.
disable-model-invocation: true
---

Set Wendy up on this machine. Ask before changing anything, and do each step only once.

## 1. Name the connection (ask first)

Wendy's tools should be reached through a server named exactly `footbridge`, so every machine
shows the same tool names (`mcp__footbridge__ledger___task_create`). The plugin ships the same
connection, but Claude Code names a plugin-supplied server `plugin:wendy:footbridge`, which makes
each tool read `mcp__plugin_wendy_footbridge__ledger___…`. A server you add yourself takes
precedence, and Claude Code then skips the plugin's copy as a duplicate.

Run `claude mcp list` and decide which case you are in.

**a. A server named `footbridge` is already there.** Say so and go to step 2.

**b. Another server points at the Footbridge gateway** (`https://mcp.dev.footbridge.ai/mcp`) under a
different name, such as `footbridge-mcp-dev`. Offer to RENAME it, which means removing it and
adding it back as `footbridge`:

- Read its scope with `claude mcp get <name>`: "User config" means `-s user`, "Project config" means
  `-s project`, anything else means `-s local`.
- Say what it costs: the old name's sign-in is discarded, so they sign in once more for the new name.
- Only after the user says yes:

```sh
claude mcp remove <old-name> -s <scope>
claude mcp add --transport http footbridge https://mcp.dev.footbridge.ai/mcp \
  --client-id 5bbe4d92-9daa-493c-85eb-8aec8ae6fa0e --callback-port 8080 -s user
```

**c. No Footbridge server of their own** (only the plugin's `plugin:wendy:footbridge`). Offer to add
one, with the same `claude mcp add` command as above. The cost is a restart and one sign-in.

After b or c the connection exists but is not live in this session yet: Claude Code loads servers at
startup. Do NOT stop here and do NOT ask them to run `/wendy:setup` again. Carry on through the
remaining steps, and remember which name you settled on: `footbridge` if they accepted, otherwise the
name they already had.

If they decline, carry on with whatever connection they have. Everything works; the tool names are
just longer.

## 2. Connection check (never blocks)

Look for a tool whose name ends in `ledger___health`. If tools are deferred, load it with tool search (query: `ledger___health`). Only a name ending in exactly `ledger___health` counts.

- **Available:** call it. If it succeeds, say "Connected to the Footbridge ledger." If it fails with an authorization error, note that they need to sign in, and keep going.
- **Missing:** expected when you just added or renamed the connection in step 1, or when they have not signed in yet. Note it and keep going.

Never stop the setup here, and never ask the user to run `/wendy:setup` twice. The remaining steps do not need a working connection.

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

Then, only if step 1 added or renamed the connection, or step 2 showed no working connection, give these three lines as what is left to do:

1. Restart Claude Code, so it picks up the connection (and the alias, in a new terminal).
2. Run `/mcp`, pick `footbridge` and choose **Authenticate**, then sign in with the Footbridge Microsoft account.
3. Ask Wendy something, such as "what's on my list?".

Nothing else needs running again.
