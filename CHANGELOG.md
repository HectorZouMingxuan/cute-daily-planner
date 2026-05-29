# Changelog

## v3.37 — 2026-05-29

**Habit module subtitle for all-done state**

- Habits module card now shows "All done today!" when every habit is checked in
- Previously always showed the ratio (e.g. "3/3 today"), which was less celebratory
- Matches the task module pattern from v1.1

## v3.36 — 2026-05-29

**Category emojis in spending breakdown**

- Weekly overview "Spending by Category" bars now show a representative emoji alongside each category name
- Food 🍽, Transport 🚗, Shopping 🛍, Bills 📄, Health 💊, Study 📚, Entertainment 🎬, Other 📌
- Makes categories instantly recognizable without reading the text labels

## v3.35 — 2026-05-29

**Reminder indicator on event cards**

- Event cards now show a small bell icon when reminders are configured for the event
- Provides a visual cue to distinguish events with active reminders from those without
- Appears on event cards, draggable tiles, and the upcoming events preview

## v3.34 — 2026-05-29

**Weekend column tint in calendar grid**

- Saturday and Sunday columns now have a subtle background tint for visual distinction
- Helps quickly identify weekends when scanning the month grid
- Today and selected day backgrounds take priority over the weekend tint

## v3.33 — 2026-05-29

**Priority breakdown in task list header**

- Task list header now shows a count of high, medium, and low priority tasks (e.g. "2 high · 3 med · 1 low")
- Each priority count uses its associated color (pink=high, yellow=medium, mint=low)
- Only shown when tasks exist; hidden when the list is empty

## v3.32 — 2026-05-29

**Events sorted by start time**

- Events for a selected day are now sorted chronologically by start time
- Ensures event cards, module subtitles, and indicators all follow time order
- Particularly helpful on busy days with multiple events

## v3.31 — 2026-05-29

**Mood emoji in daily summary card**

- The daily summary card now shows the mood emoji alongside the label (e.g. "🌟 Great" instead of just "Great")
- Matches the emoji style used in the mood sheet, mood trend row, and weekly overview
- No change when no mood is recorded for the day

## v3.30 — 2026-05-29

**Add Note to quick actions menu**

- Long-press any day on the calendar to reveal the quick-action bottom sheet, now with an "Add Note" option
- Opens the note editor directly for the selected day, prepopulating any existing note
- Joins Event, Task, and Expense as the fourth quick action from the calendar grid

## v3.29 — 2026-05-29

**"Today" label in selected date title**

- When the selected calendar day is today, the date title now shows "Today, May 29" instead of "Friday, May 29"
- Makes it instantly clear you're viewing the current day
- Other days continue to show the full weekday name for context

## v3.28 — 2026-05-29

**Habit completions in monthly summary**

- The monthly summary line on the calendar now includes habit check-ins (e.g. "45 habits done")
- Counts all completed habit check-ins for the viewed month
- Auto-hides when no habits have been completed in the month

## v3.27 — 2026-05-29

**Event duration in upcoming preview**

- Upcoming events section on the home screen now shows event duration alongside the day and time
- Format: "Today · 14:00 · 1h 30m" or "Tomorrow · 10:00 · 2h"
- Consistent with the event card duration display added in v3.15

## v3.26 — 2026-05-29

**Pending habit visibility in weekly overview**

- Day rows in the weekly overview now show the habit chip even when no habits are checked (e.g. "0/3 hab")
- Unchecked habits display in dimmed text to indicate pending routines
- "No data" message no longer appears for days that have habits defined

## v3.25 — 2026-05-29

**Year in monthly expense total**

- Monthly total line in the expense sheet now shows the full month and year (e.g. "May 2026" instead of "May")
- Helps distinguish between same months in different years when browsing historical data

## v3.24 — 2026-05-29

**All habits done encouragement**

- When every habit for the selected day is checked in, a "All habits checked in today!" message appears at the bottom of the habit list
- Provides immediate positive feedback for completing all daily routines
- Message automatically hides if any habit is unchecked

## v3.23 — 2026-05-29

**Habit-colored week dots**

- Weekly completion dots now use the habit's chosen color instead of always green
- Today's dot border also matches the habit color for visual consistency
- Unifies all habit visual elements (avatar, streak badge, dots) under one color

## v3.22 — 2026-05-29

**Expense count in module subtitle**

- Expense module card now shows the number of transactions alongside the net amount
- Format: "+500 · 2 items" or "-250 · 3 items" or "Balanced · 1 item"
- Helps gauge daily transaction volume at a glance without opening the sheet

## v3.21 — 2026-05-29

**Word count in note module subtitle**

- Notes module card now shows word count alongside the preview (e.g. "Groceries list... · 45 words")
- Lets users gauge how much they've written without opening the editor
- Matches the word count display already present inside the note editor

## v3.20 — 2026-05-29

**Quick actions on calendar day long-press**

- Long-press any day cell on the calendar to show a quick-action bottom sheet
- Options: Add Event, Add Task, Add Expense — directly opens the creation form for that day
- Automatically selects the day before opening the form, no need to tap-and-then-add

## v3.19 — 2026-05-29

**Mood note displayed in feedback card**

- The mood sheet now shows your reflection note when one exists, instead of the generic "Today feels X" message
- Generic message still appears when no note has been written
- Makes the mood journaling feature (v3.10) more visible and rewarding

## v3.18 — 2026-05-29

**Confirmation before clearing done tasks**

- "Clear X done" button now shows an AlertDialog asking for confirmation
- Warns that bulk deletion cannot be undone, preventing accidental data loss
- Cancel button lets users back out safely

## v3.17 — 2026-05-29

**Current date in app bar greeting**

- The greeting now includes today's full date (e.g. "Good Morning, Hector · Friday, May 29")
- Combines time-based greeting with the current date for quick reference
- Helps users see today's date without looking at the calendar grid

## v3.16 — 2026-05-29

**Quick month picker**

- Tapping the month title in the calendar app bar now opens a month/year picker dialog
- Year navigation with left/right arrows for jumping across years
- Current month highlighted; tap any month to jump directly to it
- Eliminates the need to swipe through many months to reach a distant date

## v3.15 — 2026-05-29

**Event duration display**

- Event cards now show the duration alongside the time range (e.g. "2:00 PM - 3:30 PM  1h 30m")
- Duration auto-formats as "Xh Ym", "Xh", or "Ym" depending on length
- All-day events omit the duration label since they span the full day

## v3.14 — 2026-05-29

**Event delete confirmation**

- Deleting an event now shows an AlertDialog asking for confirmation
- Shows the event title being deleted and warns the action cannot be undone
- Prevents accidental data loss from mis-tapping the delete button

## v3.13 — 2026-05-29

**Settings screen enrichment**

- Settings now shows app name, icon, and version at the top
- Added About dialog with licenses and app info (built-in Flutter widget)
- Removed Firebase setup placeholder for a cleaner look

## v3.12 — 2026-05-29

**Swipe to delete habits**

- Habit cards now support swipe-left-to-delete, matching the task card pattern
- Red delete background appears on swipe for clear visual feedback
- Deleting a habit soft-deletes it (filtered from lists but preserved in storage)
- Streak badge now uses the habit's chosen color instead of always mint

## v3.11 — 2026-05-29

**Habit icon and color customization**

- Habit form now lets you pick an icon (check, star, heart, bolt, flame, book) and color
- Each habit's circle avatar in the checklist reflects its chosen icon and color
- Existing habits retain their default check icon and mint color

## v3.10 — 2026-05-29

**Mood reflection notes**

- Mood sheet now includes an optional note field for journaling why you feel that way
- Notes are saved alongside the mood selection and persist across mood changes
- Previously saved notes appear when reopening the mood sheet

## v3.9 — 2026-05-29

**Celebration on all tasks done**

- Completing the last remaining task for the day now shows a congratulatory snackbar
- Snackbar appears only when every task for the selected date is finished
- No snackbar when toggling tasks that don't complete the full list

## v3.8 — 2026-05-29

**Category colors on expense cards**

- Each expense card now shows a colored left border matching its category
- Expense circle avatar also uses the category color (income cards keep mint green)
- Color-coded for quick visual scanning: amber=Food, blue=Transport, pink=Shopping, red=Bills, etc.

## v3.7 — 2026-05-29

**Today highlight on calendar weekday headers**

- The current day's weekday letter (M/T/W/T/F/S/S) in the calendar header is now highlighted
- Uses primary gold color and bolder weight for instant visual orientation
- Helps users quickly find today's column when scanning the month grid

## v3.6 — 2026-05-29

**Colored expense categories**

- Each expense category now has a distinct color (Food=amber, Transport=blue, Shopping=pink, Bills=red, Health=green, Study=purple, Entertainment=gold)
- Category breakdown bars in weekly overview now use per-category colors instead of uniform red
- Amount labels also match category color for clearer visual grouping

## v3.5 — 2026-05-29

**Weekly habit completion dots**

- Each habit now shows a 7-day mini-grid of dots (Mon–Sun)
- Green filled dot for days the habit was completed, empty dot for missed days
- Today's dot highlighted with a subtle border for quick orientation
- Compact design that fits below the existing status text and streak badge

## v3.4 — 2026-05-29

**Undo snackbar for task deletion**

- Deleting a task now shows a snackbar with "Task deleted" and an "Undo" button
- Undo restores the task with all its original properties
- Works for both swipe-to-delete and the delete icon button

## v3.3 — 2026-05-29

**Calendar swipe navigation**

- Swipe left on the month view to go to next month
- Swipe right on the month view to go to previous month
- Existing arrow buttons retained alongside swipe gesture

## v3.2 — 2026-05-29

**Monthly total in expense sheet**

- Expense bottom sheet now shows monthly income, spending, and net below the weekly bar
- Format: "May  +5000  -2500  net +2500"
- Auto-hides when no expenses exist for the viewed month

## v3.1 — 2026-05-29

**Swipe to delete task cards**

- Task cards now support swipe-left-to-delete gesture
- Red delete background with trash icon slides in on swipe
- Existing delete button retained as fallback for non-swipe interaction

## v3.0 — 2026-05-29

**Dark mode support**

- New dark theme with dark-appropriate colors for background, surface, text, and borders
- Theme toggle in Settings screen (Light / Dark switch)
- Accent colors (primary, mint, sage, pink, lavender, yellow) stay consistent across themes
- AppColors system refactored with brightness-aware getters that resolve correctly per theme
- Material 3 color scheme adapts automatically; custom widgets (SoftCard, calendar cells) follow theme
- Riverpod-based ThemeModeNotifier for reactive theme switching

## v2.9 — 2026-05-29

**Monthly summary line on calendar**

- Calendar screen now shows a monthly aggregate line below the month header
- Displays task completion, event count, and net income for the viewed month
- Format: "8/14 tasks · 5 events · +3,200 net"
- Auto-hides when no data exists for the viewed month

## v2.8 — 2026-05-29

**Clear completed tasks button**

- Task sheet now shows a "Clear X done" button when any tasks are completed
- Bulk-deletes all completed tasks for the selected day in one tap
- Button only visible when there are completed tasks to clear

## v2.7 — 2026-05-29

**Week-over-week comparison deltas**

- Aggregate stats row now shows week-over-week deltas (e.g. "↑3", "↓200")
- Compares current week against previous week for tasks done, net income, events, and habits
- Delta indicators use subtle dimmed text within each aggregate chip
- No delta shown when there's no change from the previous week

## v2.6 — 2026-05-29

**Narrative weekly summary**

- Weekly overview now opens with a natural-language paragraph describing the week
- Intelligently combines task completion, events, mood, finances, and habits into readable text
- Adapts tone: "All tasks completed — a perfect productivity week!" vs encouraging for lower completion
- Shows encouraging prompt when no data exists: "Start by adding a task, mood, or expense!"

## v2.5 — 2026-05-29

**Time-based greeting on home screen**

- Calendar app bar now shows a time-based greeting: "Good Morning/Afternoon/Evening, [username]"
- Greeting changes based on current hour: morning (<12), afternoon (12-16), evening (17+)
- Updated widget test to match the new dynamic greeting format

## v2.4 — 2026-05-29

**Mood distribution row in weekly overview**

- Weekly overview now shows a mood distribution row with all 5 mood types
- Each mood shows its emoji and count (e.g. "🌟 ×3  ☀️ ×2  ☁️ ×1")
- SoftCard layout with evenly spaced mood columns
- Counts dimmed for moods with zero occurrences
- Auto-hides when no mood data exists for the week

## v2.3 — 2026-05-29

**Upcoming events preview on home screen**

- New "Upcoming" section on the main calendar screen showing the next 3 events
- Events from today through the next 7 days, respecting recurrence rules
- Each event shows colored bar, title, relative day (Today/Tomorrow/day name), and time
- Section auto-hides when no upcoming events exist
- Recurring events properly resolved to their next occurrence

## v2.2 — 2026-05-29

**Expense category breakdown in weekly overview**

- Weekly overview now shows a "Spending by Category" section below daily breakdown
- Horizontal bars show proportional spending per category (Food, Transport, Shopping, etc.)
- Categories sorted by amount (highest first)
- Section auto-hides when no expenses exist for the viewed week

## v2.1 — 2026-05-29

**Week navigation arrows on weekly overview**

- Added previous/next week chevron arrows in the weekly overview app bar
- "Today" button appears when browsing non-current weeks to jump back instantly
- Week offset state management for smooth browsing through past and future weeks
- Cleaned up unused imports

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
