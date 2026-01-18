# Vision — dark-calendar

## Purpose
dark-calendar is a **personal, calendar-first time-blocking tool**.

Its primary job is to answer one question clearly and honestly:

> “What am I actually doing with my time today?”

This is not a social calendar, a task manager, or a general planner.
Everything in the app exists to serve the **day timeline**.

---

## Core Philosophy

### Calendar-First
- The day timeline is the product.
- All features must visibly improve the day view.
- If a feature does not affect the timeline, it is suspect.

### Visual Debugger for Time
- The calendar acts like a debugger or profiler for a day.
- Time flows top → bottom.
- Conflicts, gaps, and constraints should be immediately visible.
- Behavior must be deterministic and explainable.

### Dark, Developer-Tool Aesthetic
Inspired by tools like Morgen, Cron, Discord, and Linear:
- Dark neutral canvas
- Subtle grid and chrome
- Color is used **only** to convey meaning
- Dense but calm layouts
- No decorative UI, gradients, or novelty animations

### Dense but Calm
- Information-rich without visual noise
- Small, restrained typography
- Spacing and rhythm matter more than decoration
- Nothing should fight for attention unnecessarily

---

## Design Constraints (Intentional)

### We prioritize:
- Day view correctness
- Readability over prettiness
- Predictable behavior over “AI magic”

### We deliberately avoid (for now):
- Week / month views
- Feature bloat
- Premature automation
- Over-engineered architecture
- Sync and collaboration complexity

---

## Decision Test
Before adding or changing anything, ask:

> “Does this make my day easier to understand at a glance?”

If the answer is no, it does not belong — yet.