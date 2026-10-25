---
name: study-setup
description: First-time setup for the study engine. Interviews a new student (courses, exams, grading scale, how they like explanations), builds their Notion study workspace and saves a config page. Use when someone says "set up my studies", "set up study engine", or when the study skill finds no config page.
---

# Study Engine — Setup

Goal: in ~10 minutes, turn a new user's answers into a working Notion study workspace plus one **config page** that the `study` skill reads at the start of every session. After this, they never need to explain their courses again.

## 0. Before asking anything

1. **Check connectors.**
   - **Notion is required.** If no Notion tools are available, stop and tell them: connect Notion in their Claude settings (Connectors), then run setup again.
   - **Google Drive is optional.** With it, the study skill reads course slides straight from Drive. Without it, they upload PDFs into the chat when studying.
   - **Google Calendar is optional and read-only.** With it, the study skill reads their schedule and suggests study blocks in free slots. It never creates, moves or deletes events. Without it, suggestions are based only on the lecture times they give in setup.
   - Say in one line which of these they have.
2. **Look for an existing config.** Search Notion for a page titled exactly `Study Engine Config`. If it exists, fetch it and ask: *update it* (change courses, dates, preferences) or *start fresh*. Never overwrite or delete a config, database or page without a yes. *Start fresh* means archiving the old config page (after a yes) so only one config exists.

## 1. Interview

Ask in small rounds (max 4 questions per round). Use multiple-choice question cards when the tool exists, plain text otherwise. Skip anything they say they don't know and store it as `unknown`. Don't invent dates.

**Round A — who and when**
1. What should I call you?
2. University, programme and current term (e.g. "TU Munich, MSc Informatics, Winter 26/27").
3. Term dates: lectures start/end, any break, exam period (or "unknown").
4. Language for notes and explanations.

**Round B — how you like to learn**
1. Explanation style: *answer-first, numbered, short (ADHD-friendly)* / *balanced* / *detailed, textbook-style*.
2. Session length: 25 / 45 / 60 min.
3. Grading scale for mock-exam bands: *German 1.0–5.0* / *letter grades A–F* / *UK classes* / *percent only* / other.
4. Anything else to keep in mind (job, side project, research topic they'd like connections to, learning differences). Optional.

**Round C — courses (repeat per course)**
1. Course name as they want it called everywhere. Tell them: no abbreviations unless they prefer them.
2. Mode: *attends lectures* / *self-study (exam only)* / *project / team work*.
3. Exam: *written* / *oral* / *project or report* / *unknown*, plus date if known, plus credits if relevant.
4. Priority or risk: *high* / *medium* / *low*.
5. Material: a Google Drive folder link (if Drive is connected), or "I'll upload files".
6. Graded coursework rules: is there a graded assignment, and an AI policy? (This decides what the tutor may write for them.) Store both in the **AI policy** field, e.g. `Graded: 3 lab reports. Policy: no AI-written code or text.`
7. Lecture / tutorial times, if any (e.g. "Mon 10:00–11:30, Thu 14:00–15:30"). Skip for self-study.

Ask "another course?" until they say done.

**Round D — planning**
1. Hours they're willing to study (e.g. 09:00–20:00) and days off.
2. Max study blocks per day: 1 / 2 / 3 / 4.
3. *Calendar only:* which calendars to read for busy times: *primary only* / *pick from a list* (list them).
4. Their timezone (from the calendar settings if connected, otherwise ask).

**Confirm before building.** Read the whole plan back in one short table (courses, exam types, style, planning) and get a yes.

## 2. Build the Notion workspace

1. **Location.** Ask where to put it (a page they name) or create a private top-level page. Title: `📚 Study Hub — <term>`.
2. **Create four databases** under it. Before creating, check how the Notion database-creation tool expects properties (read its description or guide). After creating each, fetch it and confirm the properties exist. Keep property names exactly as below; the study skill depends on them.

| Database | Properties |
|---|---|
| **Courses** | Name (title) · Status (select: Active, Planned, Passed, Failed, Dropped) · Mode (select: Lectures, Self-study, Project) · Exam type (select: Written, Oral, Project, Unknown) · Exam date (date) · Credits (number) · Priority (select: High, Medium, Low) · Drive folder (url) · Lecture times (text) · AI policy (text) · Grade (text) |
| **Topics** | Name (title) · Course (relation → Courses) · Week (number) · Exam weight (select: High, Medium, Low) · Mastery (number, 0–3) · Last reviewed (date) · Next review (date) · Weak points (text) · Source (text) |
| **Lecture Notes** | Title (title) · Course (relation → Courses) · Lecture # (number) · Date (date) · Source file (url) · Status (select: Draft, Reviewed) · Topics (relation → Topics) |
| **Study Log** | Title (title) · Date (date) · Course (relation → Courses) · Topics (relation → Topics) · Type (select: Lecture notes, Exercises, Mock exam, Review, Reading) · Minutes (number) · Score % (number) · Takeaways (text) |

3. **Add one Courses row per course** from the interview (Status = Active).
4. **Drive (optional).** For each course folder they gave, list it. If it has no structure, suggest (don't force) three subfolders: `01 Slides & Script`, `02 Exercises & Solutions`, `03 Past Exams`. Create them only if they say yes and the Drive tools can.

## 3. Write the config page

Create a page titled exactly **`Study Engine Config`** under the Study Hub. Top of the page: one line saying *"Read by the study skill. Edit through 'update my study setup', or carefully by hand."* Then one JSON code block in this shape:

```json
{
  "version": 1,
  "student": {
    "name": "Sam",
    "university": "TU Munich",
    "programme": "MSc Informatics",
    "term": "Winter 26/27",
    "language": "English"
  },
  "style": {
    "explanations": "answer-first",
    "max_list_items": 5,
    "session_minutes": 45
  },
  "grading": {
    "scale": "German 1.0-5.0",
    "bands": [[87, "1.x"], [75, "2.x"], [62, "3.x"], [50, "4.0"], [0, "5.0 (fail)"]]
  },
  "term_dates": {
    "lectures_start": "2026-10-12",
    "lectures_end": "2027-01-30",
    "break": ["2026-12-20", "2027-01-03"],
    "exam_period": "unknown"
  },
  "notion": {
    "hub_page": "<page id>",
    "courses": "<data source id>",
    "topics": "<data source id>",
    "lecture_notes": "<data source id>",
    "study_log": "<data source id>"
  },
  "drive_enabled": true,
  "planning": {
    "calendar_enabled": false,
    "calendars": ["primary"],
    "timezone": "Europe/Berlin",
    "study_hours": "09:00-20:00",
    "days_off": ["Sunday"],
    "max_blocks_per_day": 3
  },
  "courses": [
    { "name": "Numerical Methods", "notion_page": "<page id>", "drive_folder": "<folder id or null>" }
  ],
  "context": "Free text: job, projects, interests worth connecting topics to."
}
```

Grading bands per scale (percent threshold → label): German as above · letter: 90 A, 80 B, 70 C, 60 D, 0 F · UK: 70 First, 60 2:1, 50 2:2, 40 Third, 0 Fail · percent only: no bands. For "other", ask for their thresholds.

Course details (exam type, dates, lecture times, priority, AI policy) live in the **Courses database**, not in the JSON. The JSON only maps names to IDs so nothing gets out of sync.

## 4. Smoke test and hand-off

1. Query each of the four databases once. If any query fails, fix it before finishing.
2. Tell them briefly: where the Study Hub is (link), what's set up, and what to try first. Suggested first prompts:
   - "Make notes for <course> lecture 1"
   - "What should I study now?"
   - "Quiz me on <topic>"
   - "Plan my study week"
3. Remind them: *to change anything later, say "update my study setup".*

## Updating later

"Update my study setup", "add a course", "my exam date changed": fetch the config page and change only what they asked.

- **Course detail changed** (exam date, lecture times, policy) → update the Courses row only.
- **Course added** → ask the Round C questions for it, create its Courses row, then add `{name, notion_page, drive_folder}` to the JSON `courses` list.
- **Course dropped** → set its Courses row Status = Dropped; keep its topics and logs.
- **Preferences / planning / dates** → edit the JSON.
- **Config from an older version** (e.g. no `planning` key) → ask the missing round's questions and add the key.

Write the JSON back, then read the change back in one line.
