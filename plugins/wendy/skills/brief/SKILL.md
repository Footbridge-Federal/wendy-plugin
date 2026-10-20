---
name: brief
description: A prioritized brief from ftask, the Footbridge task tracker. Plain /wendy:brief = Today and Needs me, the app's own views; "/wendy:brief hour" = what fits in about an hour; "/wendy:brief delegate" = what an agent could one-shot. Use when the user asks "what's my priority", "what should I do", "what can I get done in X", or "what can I delegate".
argument-hint: "[hour | <time window> | delegate]"
---

Give the user a brief they can act on immediately. Never dump the raw task list.

The ftask tools end in `ledger___`; the prefix depends on this machine's MCP server name. If they aren't available, tell the user in one line to run `/mcp`, pick `footbridge`, and choose **Authenticate**.

## Two views, the app's definitions

The brief shows the same two views the ftask app opens on, defined the same way, so what the user sees here and there agrees:

- **Today** = open and (due today or overdue, or `plan_date` today, or `In Progress` and assigned to the user).
- **Needs me** = open and (`type` decision or review assigned to the user, or status `Blocked`).

"Open" means status `To Do`, `In Progress` or `Blocked` (`status: "not-done"`), never archived. "The user" is the signed-in person: pass their email as `assignee`.

## Read, keeping it small

`ledger___task_list` has no page limit, so never call it unfiltered, and never pass `archived: true` unless the user asks about archived work by name.

1. `ledger___notifications_list` with `unread: true`. If anything moved since the user last looked (an answered decision, a finished run, a comment), lead with it.
2. **Today**, three lists:
   - `ledger___task_list` with `plan_date: "<today, YYYY-MM-DD>"` (the user's local date; the server's `today` literal runs on its own UTC clock) and `status: "not-done"`.
   - `ledger___task_list` with `status: "In Progress"` and `assignee: <the user>`.
   - Due today or overdue: there is no due-date filter, so `ledger___task_list` with `status: "not-done"` and `assignee: <the user>`, keeping the rows whose `due_date` is on or before today. If that list is large, read one top-level folder at a time instead. `due_kind: "hard"` marks a deadline that cannot move: say so.
3. **Needs me**, three lists:
   - `ledger___task_list` with `type: "decision"`, `status: "not-done"` and `assignee: <the user>`.
   - The same with `type: "review"`.
   - `ledger___task_list` with `status: "Blocked"`: the waiting-fors, each with its `waiting_on`.
4. `ledger___task_list` with `folder: "inbox-unfiled"` and `exact: true`: the untriaged captures, for the count.
5. Only if a variant needs it, narrower lists: by `label` (`delegable`), or by one `folder` at a time.
6. `ledger___task_view` only when a title isn't enough to judge.

## Default brief

- **Today** first: In Progress before anything new, then hard deadlines, then the rest by due date, then what was planned for today. Finish before starting.
- **Needs me** second: each decision in one line with its options and your recommendation; each review with its link; each waiting-for with who and since when. When the user answers a decision in the conversation, match the answer to an option and file it with `ledger___task_decide` (`{ id, answer }`). Say when a waiting-for has aged enough to nudge.
- One line per task, one screen at most. Group by folder only when a view runs long.
- End with a single recommended next action.

## "hour" variant (or any stated time window)

Filter Today, then the rest of the open list, to items whose `effort` (or evident size) fits the window: quick errands, single emails, small fixes. In Progress items that fit come first, then hard deadlines, then high priority. A pending decision fits almost any window, so include one when there is one. Offer one bonus item in case they're fast. If candidates have no effort set, say so once and estimate from the titles and descriptions.

## "delegate" variant

List items labeled `delegable`, plus any `To Do` item that reads as one-shot-able by an agent: a small scoped feature with a `Repo:` line, a research question, or a draft to write. Never include decisions, reviews, Blocked items or anything still labeled `reconsider`: those need the user. Present them as a checklist.

## Untriaged captures

If `inbox-unfiled` holds several items, still give the brief, and mention once, without nagging, that `/wendy:triage` would sharpen it.
