# Changelog

## v2.0 — 2026-05-29

**Weekly overview dashboard (major new feature)**

- New Weekly Overview screen accessible from calendar app bar (week icon)
- Shows the current week's date range as a header
- Aggregate summary row with: tasks done/total, income vs spending, event count, dominant mood, habits completed
- Day-by-day breakdown cards showing mood emoji, events, task progress, net expense, and habits checked
- Today's row is highlighted with a warm tint and primary color border for quick orientation
- Each day shows "No data" placeholder when no activity exists
- Navigate back to calendar with standard back button
- Month calendar week definition (Mon–Sun)

## v1.9 — 2026-05-29

**Motivational message in daily summary**

- Daily summary card now shows a contextual motivational message based on the day's data
- Different messages for all tasks done, great mood, all habits checked, halfway progress, tired/bad mood, etc.
- Prioritizes messages in order: perfect day → tasks done → great mood → habits → progress → encouragement
- Message is hidden when no data exists (clean state)

## v1.8 — 2026-05-29

**Improved notes editor**

- Added live word count display below the text field
- Shows "Last edited" timestamp for previously saved notes
- Displays a "Saved!" confirmation after successful save
- Cleaner footer row with word count, timestamp, and compact save button

## v1.7 — 2026-05-29

**Enhanced task priority display**

- Task cards now show a colored left border matching priority level (green/mint for Low, yellow for Medium, pink for High)
- Checkbox fill color reflects priority when checked
- Priority label chip uses subtler background tint for cleaner appearance

## v1.6 — 2026-05-29

**Habit streak display in habits sheet**

- Each habit now shows a current streak badge (e.g. "5 day streak")
- Streak counts consecutive past days where the habit was checked as done
- Badge only appears for streaks of 2+ days to keep the UI clean
- Mint-colored chip matching the habits module color

## v1.5 — 2026-05-29

**Login screen polish with entrance animations**

- Added staggered fade-in + slide-up entrance animation for login screen elements
- Logo, title, subtitle, text field, and button appear sequentially (600ms total)
- Added smooth crossfade page transition (400ms) when navigating from login to calendar
- Broken down login screen into small private widgets for readability

## v1.4 — 2026-05-29

**Weekly expense summary bar in expense sheet**

- Expenses bottom sheet now shows a 7-day mini bar chart of daily net totals
- Green bars for net income days, red bars for net spending days
- Daily net amount labels above each bar
- Day-of-week labels with today highlighted
- Bar auto-hides when no expense data exists in the last 7 days

## v1.3 — 2026-05-29

**Mood trend display in mood sheet**

- Mood bottom sheet now shows a 7-day trend row with emoji icons
- Each day displays its mood emoji (or a dot for days with no entry)
- Today is highlighted with a dot indicator for quick orientation
- Day-of-week labels below each column
- Trend row auto-hides when no mood data exists in the last 7 days

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
