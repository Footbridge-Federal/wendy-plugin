# Wendy, the Footbridge assistant for Claude Code

Wendy is an executive assistant that runs inside [Claude Code](https://claude.com/claude-code) on your own Claude subscription. You talk to her, often by voice, and she:

- captures every open loop into the Footbridge task ledger;
- triages what you've captured into the right folders and priorities;
- tells you what to work on next.

This repository is a Claude Code **plugin marketplace** with one plugin, `wendy`.

## Install (once per machine)

You need Claude Code, signed in with your Claude account, and a Footbridge Microsoft (Entra) account.

```sh
claude plugin marketplace add Footbridge-Federal/wendy-plugin
claude plugin install wendy@footbridge
```

## Sign in (first time only)

Start Claude Code, run `/mcp`, pick the **footbridge** server and choose **Authenticate**. A browser window opens for your Footbridge Microsoft sign-in; with single sign-on it is usually one click. Claude Code keeps you signed in after that.

One sign-in covers every Footbridge tool behind the gateway, including the task ledger.

## Start Wendy

Run the setup skill once. It checks your connection, then offers three things, asking before each: allowing the Footbridge tools so Claude Code stops asking before each first use, a `wendy` shell alias, and a desk folder (`~/wendy` by default, or any folder you already use):

```
/wendy:setup
```

After that, any of these starts a Wendy session:

```sh
wendy                  # the alias, which runs: WENDY=1 claude
WENDY=1 claude         # without the alias
cd ~/wendy && claude   # the desk folder (it holds a .claude/wendy-desk marker)
wendy --continue       # flags pass through: --continue, --resume, -p "..."
```

`--continue` and Claude Code's memory are kept per folder, so starting from your desk folder gives Wendy one steady home.

Wendy is added **on top of** Claude Code's normal instructions, so a Wendy session can still do everything Claude Code does. Your other sessions stay plain Claude Code: the persona loads only when `WENDY=1` is set or the folder has the marker. The skills work in any session.

## What's inside

| Piece | Path | What it does |
|---|---|---|
| Persona | `plugins/wendy/persona.md` | Wendy's voice, manner and ledger conventions |
| Session-start hook | `plugins/wendy/hooks/hooks.json` | Adds the persona to the session when `WENDY=1` is set or the project has `.claude/wendy-desk`; otherwise does nothing |
| Skills | `plugins/wendy/skills/` | `/wendy:todo` quick capture · `/wendy:brief` what matters now (`hour`, `delegate` variants) · `/wendy:triage` bucket and prioritize · `/wendy:setup` one-time setup |
| MCP connection | `plugins/wendy/.mcp.json` | The Footbridge MCP gateway (`https://mcp.dev.footbridge.ai/mcp`), with Claude Code's Entra app id preset so sign-in works |
| Marketplace | `.claude-plugin/marketplace.json` | The catalog that `claude plugin marketplace add` reads |

The ledger's tools arrive through the gateway with the `ledger___` prefix (`ledger___task_create`, `ledger___folder_list`, …). Your folders come from the ledger itself, so nothing in this plugin is specific to one person.

If you already configured the same gateway URL by hand, Claude Code uses your entry and skips the plugin's duplicate. Wendy works either way.

## Security model

- **The code is public; the data is not.** This repository holds only instructions and a connection address. The app id in `.mcp.json` is a public client identifier and is not a secret.
- **Every call is signed in as you.** The gateway accepts only Microsoft Entra tokens from the Footbridge tenant; the app registrations are single-tenant. The ledger then checks the token again and returns only your own data plus what others have shared with you.
- **No API keys, no stored secrets.** Claude Code holds your sign-in and refreshes it. Wendy never sees a password.

## Updating

```sh
claude plugin marketplace update footbridge
claude plugin update wendy@footbridge
```

## Roadmap

- **`/wendy:delegate`**: hand a task to a background Claude Code agent that works in a fresh clone and comes back with a pull request. It exists today only on a pilot setup; it will ship here once it no longer depends on one machine.
- **The phone**: a mobile chat with the same persona, running on a Footbridge-hosted node.
