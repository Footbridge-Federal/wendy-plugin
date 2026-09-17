---
name: brief
description: A prioritized brief from the Footbridge task ledger. Plain /wendy:brief = what matters now; "/wendy:brief hour" = what fits in about an hour; "/wendy:brief delegate" = what an agent could one-shot. Use when the user asks "what's my priority", "what should I do", "what can I get done in X", or "what can I delegate".
argument-hint: "[hour | <time window> | delegate]"
---

Give the user a brief they can act on immediately. Never dump the raw task list.

The ledger tools end in `ledger___`; the prefix depends on this machine's MCP server name. If they aren't available, tell the user in one line to run `/mcp`, pick `footbridge`, and choose **Authenticate**.

## Read, keeping it small

`ledger___task_list` has no page limit, so never call it unfiltered.

1. `ledger___notifications_list` with `unread: true`. If anything moved since the user last looked, lead with it.
2. `ledger___folder_list`: the tree with open-task counts, to see where the work is.
3. `ledger___task_list` with `status: "In Progress"`.
4. `ledger___task_list` with `status: "not-done"` and `priority: "high"`.
5. `ledger___task_list` with `folder: "inbox-unfiled"` and `exact: true`: the untriaged captures.
6. Only if a variant needs it, narrower lists: by `label` (`delegable`), or by one `folder` at a time.
7. `ledger___task_view` only when a title isn't enough to judge.

Never pass `archived: true` unless the user asks about archived work by name.

## Default brief

- In Progress first: finish before starting.
- Then high priority, grouped by folder.
- Then anything stale (created long ago, still To Do) that needs a decision: do it, delegate it, or drop it.
- One line per task, one screen at most.
- End with a single recommended next action.

## "hour" variant (or any stated time window)

Filter to items whose `effort` (or evident size) fits the window: quick errands, single emails, small fixes. In Progress items that fit come first, then high priority. Offer one bonus item in case they're fast. If candidates have no effort set, say so once and estimate from the titles and descriptions.

## "delegate" variant

List items labeled `delegable`, plus any To Do item that reads as one-shot-able by an agent: a small scoped feature with a `Repo:` line, a research question, or a draft to write. Never include items labeled `reconsider`. Present them as a checklist.

## Untriaged ledger

If `inbox-unfiled` holds several items, still give the brief, and mention once, without nagging, that `/wendy:triage` would sharpen it.
