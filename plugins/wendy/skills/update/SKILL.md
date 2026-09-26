---
name: update
description: Update the Wendy plugin to the latest version, and offer to turn on automatic updates. Use when the user runs /wendy:update or asks to update Wendy.
disable-model-invocation: true
allowed-tools: Bash(claude plugin marketplace update footbridge), Bash(claude plugin update wendy@footbridge)
---

Update Wendy on this machine. Keep it short: the user wants one command and a one-line answer.

## 1. Update

Run these two commands, in order:

```sh
claude plugin marketplace update footbridge
claude plugin update wendy@footbridge
```

- If the first command fails, say so in one line with its error and stop. The usual cause is no network, or the `footbridge` marketplace was never added. In that case, show `claude plugin marketplace add Footbridge-Federal/wendy-plugin` as the fix.
- If the second command prints `already at the latest version (X)`, say: "Wendy is up to date (X)."
- Otherwise the update installed. Say: "Updated Wendy to <new version>. Type `/reload-plugins` to switch to it now, or start a new session." The new version doesn't load in a running session until then. `/reload-plugins` is a built-in command that only the user can type, so never claim you ran it.

## 2. Automatic updates (ask once)

Read `~/.claude/settings.json` (treat a missing file as `{}`).

- If `extraKnownMarketplaces.footbridge.autoUpdate` is already `true`, skip this step silently.
- Otherwise ask one yes/no question: "Want future Wendy updates to install automatically? They'd load at your next session start."
- Only after a yes:
  - Set `extraKnownMarketplaces.footbridge.autoUpdate` to `true`.
  - If the `footbridge` entry doesn't exist, create it as `{"source": {"source": "github", "repo": "Footbridge-Federal/wendy-plugin"}, "autoUpdate": true}`.
  - Keep every other setting exactly as it was, and make sure the file is still valid JSON.
  - Then say: "Automatic updates are on."
