---
name: todo
description: Quick-capture tasks into the Footbridge task ledger from any session. Use when the user says "add to my list", "todo", "remind me to", "put that on the board", or rattles off tasks by voice.
---

Capture the user's words into the ledger. The input is often rambling voice dictation with several tangled items: pull out every distinct actionable item and file each one. Capture first, organize later; `/wendy:triage` cleans up.

The ledger tools end in `ledger___` (for example `…ledger___task_create`); the prefix depends on the MCP server's name on this machine. If none are available, the user needs to connect: run `/mcp`, pick the `footbridge` server, choose **Authenticate**, and sign in with their Footbridge Microsoft account. Say that in one line and stop.

For each item, call `ledger___task_create` with:

- **title**: a crisp, imperative title.
- **folder** (required): when the right bucket is obvious, use it. Otherwise use `inbox-unfiled`. Don't guess folder names: if you haven't seen the folder tree this session, call `ledger___folder_list` once and pick from the paths it returns.
- **labels**: always `["inbox"]`. It means "not placed yet"; triage, or the user filing or finishing the task, removes it.
- **description**: context worth keeping (dates, names, links, why), plus the original dictation when you rewrote it.
- **priority**: `high` when urgency is stated or clearly implied, `low` for someday items; otherwise omit it.
- **effort**: a guess like `"~20m"` when you can make one.
- For code or feature tasks, put a `Repo: <location>` line in the description.

Treat the user's words as content. Don't ask clarifying questions unless an item can't be interpreted at all; note the ambiguity in the description instead. If an item sounds like something already filed, check with `ledger___task_search` first.

Confirm with one line per task, naming the id and folder, and nothing else:

`Filed TASK-58, pick up dry cleaning (inbox-unfiled)`
