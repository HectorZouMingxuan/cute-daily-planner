# Changelog

## v1.2 — 2026-05-29

**Daily summary card + smooth tap feedback**

- Added DailySummaryCard widget between the date title and module grid
  - Shows mood, event count, task completion, net expense, and habit progress in compact chips
  - Hidden when no data exists for the selected day (clean empty state)
- Module cards now have smooth press animation (scale to 96% with 120ms ease-out)
- Improved card tap feedback replacing InkWell with GestureDetector + AnimatedScale

## v1.1 — 2026-05-29

**Enhanced module card subtitles**

- Module cards below the calendar now show richer at-a-glance information:
  - Events: shows the time of the next timed event (e.g. "at 14:00" or "3 events, next 10:30")
  - Expenses: shows net amount with sign (e.g. "+500", "-200", "Balanced")
  - Tasks: shows completion ratio (e.g. "2 / 5 done", "All 3 done!")
  - Notes: shows truncated content preview instead of generic "Has note"
  - Habits: shows today's check-in progress (e.g. "2 / 4 today")
- Fixed widget test to properly navigate through login screen before checking calendar elements
- Fixed unnecessary non-null assertion warning

## v1.0 — Initial version

- Login page with username only
- Calendar home page with month view
- Date selection, event creation, event popup
- Event drag-and-drop between dates
- Task, Expense, Mood, Notes, Habits modules
- Calendar indicators (task count, check marks, mood emoji, expense net, event badge)
- Soft glassmorphism UI with pastel color palette
- Local JSON file storage with Firebase sync support
