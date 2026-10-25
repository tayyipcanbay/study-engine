# Study Engine

A study system that runs inside Claude. It turns lecture slides into revision notes, tutors you through exercise sheets with hints instead of answers, runs mock exams in your real exam format, and tracks how well you know each topic with spaced repetition. Everything is saved in your own Notion.

## What you need

1. A Claude **Pro, Max, Team or Enterprise** plan (skills aren't on Free).
2. **Notion** connected in Claude (Settings → Connectors). Required.
3. **Google Drive** connected. Optional: lets Claude read your slides directly. Without it, you upload PDFs into the chat.
4. **Google Calendar** connected. Optional and read-only: Claude reads your schedule to suggest study blocks in free slots. It never adds or changes events.

## Install

### Option A — claude.ai (web, desktop, mobile)

1. Turn on **code execution** in Settings → Capabilities.
2. Download `dist/study-setup.zip` and `dist/study.zip` from this repo.
3. Settings → Capabilities → Skills → **Upload skill**. Upload both zips and switch them on.

### Option B — Claude Code

```bash
claude plugin marketplace add <github-user>/study-engine
claude plugin install study-engine@study-engine
claude mcp add --transport http notion https://mcp.notion.com/mcp
```

Then run `/mcp` inside Claude Code and sign in to Notion. Updates: `claude plugin marketplace update study-engine`.

## First run

In a new chat, say:

> set up my studies

Claude asks about you, your courses, exam formats and how you like explanations (~10 min), then builds a **📚 Study Hub** in your Notion with four databases (Courses, Topics, Lecture Notes, Study Log) and a `Study Engine Config` page.

## Then try

1. `Make notes for <course> lecture 1`
2. `Help with sheet 2 exercise 3` — it asks for your idea first and gives hints one step at a time
3. `Quiz me on <topic>` or `Mock exam for <course>`
4. `What should I study now?` — picks one block and starts it
5. `Plan my study week` — suggests blocks in your free time (you add them to your calendar yourself)

To change anything later: `Update my study setup`.

## How mastery works

| Level | Meaning | Next review |
|---|---|---|
| 0 | Not seen | – |
| 1 | Notes exist | +2 days |
| 2 | Can explain it without notes | +5 days |
| 3 | Solves exam-style questions unaided | +12 days |

A wrong answer drops a topic one level and schedules it for tomorrow.

## Repo layout

```
.claude-plugin/marketplace.json      Claude Code marketplace entry
plugins/study-engine/
  .claude-plugin/plugin.json
  skills/study-setup/SKILL.md         first-run interview + Notion build
  skills/study/SKILL.md               the study engine
dist/                                 upload-ready zips for claude.ai
scripts/make-zips.sh                  rebuilds dist/ after edits
```

## Contributing

Edit a `SKILL.md`, run `./scripts/make-zips.sh`, bump `version` in `plugin.json`, commit. Your personal data never lives in this repo; it stays in each person's own Notion.
