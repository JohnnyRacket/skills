---
name: roguelike-planner
description: >
  Interactive roguelike-style planning skill. Use when the user wants to plan
  anything interactively — tech stacks, team offsites, vacations, product
  roadmaps, home renovations, or any scenario involving a sequence of choices.
  Trigger on: "help me plan", "help me decide", "let's plan a", "I need to
  figure out my", "what should I pick for", "roguelike planner", "card planning".
user-invocable: true
---

# roguelike-planner

## Trigger
Use this skill when the user wants to plan *anything* interactively — tech stacks, team offsites, vacations, product roadmaps, home renovations, weddings, or any scenario involving a sequence of choices. Trigger on phrases like "help me plan", "help me decide", "let's plan a", "I need to figure out my", "what should I pick for", "roguelike planner", "card planning". Tech stack planning is one canonical example — the skill is a general-purpose planning methodology.

## Instructions

You are running an interactive roguelike-style planning session. Every decision is presented as exactly 3 ASCII cards side-by-side. The user picks one card per round, and their choice shapes the options in subsequent rounds. The session ends with a clean summary of all decisions.

### Step 1 — Ask what we're planning

Start with exactly this:

```
What are we planning? (describe your goal in a sentence or two)
```

Wait for the user's response before proceeding.

### Step 2 — Generate the decision sequence

From the user's answer, infer 5–10 decision categories appropriate to the domain. Each category must:
- Be a real, meaningful fork in the road (not trivial)
- Naturally constrain or inform the *next* category
- Have exactly 3 meaningful, distinct options

**Do NOT copy example sequences or default to generic tech-stack patterns.** Derive the categories fresh from what the user actually described. Think: what are the real decisions someone making this plan needs to work through, in the order that makes sense?

Before showing the first card set, briefly announce the plan with a one-liner like:
```
Great — let's plan your trip. I'll walk you through 6 decisions.
```
(Adapt the label and count to the domain.)

### Step 3 — Render cards

**Before rendering each card set, think through the full option space for this category given prior choices.** Ask yourself: what are all the realistic, meaningfully-different options someone could pick here? Then select the 3 that best represent distinct trade-offs — not just the first 3 that come to mind, and not the same defaults every time. The goal is 3 options that each have a genuine case for being chosen.

For each decision category, render 3 cards side-by-side in this exact monospace format using Unicode box-drawing characters:

```
 Category: FRONTEND FRAMEWORK
 ─────────────────────────────────────────────────────────────────────────────────

╔═══════════════════════╗   ╔═══════════════════════╗   ╔═══════════════════════╗
║         REACT         ║   ║        SVELTE          ║   ║          VUE          ║
╠═══════════════════════╣   ╠═══════════════════════╣   ╠═══════════════════════╣
║                       ║   ║                       ║   ║                       ║
║  WHY:                 ║   ║  WHY:                 ║   ║  WHY:                 ║
║  Industry standard,   ║   ║  Compiled = fast,     ║   ║  Gentle learning      ║
║  massive ecosystem    ║   ║  less boilerplate     ║   ║  curve, flexible      ║
║                       ║   ║                       ║   ║                       ║
║  WHY NOT:             ║   ║  WHY NOT:             ║   ║  WHY NOT:             ║
║  Heavy patterns,      ║   ║  Smaller community,   ║   ║  Version fragmented,  ║
║  boilerplate-heavy    ║   ║  fewer enterprise     ║   ║  less opinionated     ║
║                       ║   ║                       ║   ║                       ║
╚═══════════════════════╝   ╚═══════════════════════╝   ╚═══════════════════════╝

  ♠  [1] REACT              ♥  [2] SVELTE             ♦  [3] VUE

  Your choice (1/2/3) — or [s] skip, [b] back:
```

**Card formatting rules:**
- Each card is exactly 23 characters wide (inner), bordered by `╔`, `╗`, `╠`, `╣`, `╚`, `╝`, `║`, `═`
- The title row is centered, ALL CAPS
- WHY text: 2 lines max, wrapping at ~21 chars
- WHY NOT text: 2 lines max, wrapping at ~21 chars
- Cards are separated by 3 spaces
- The option list below uses suit symbols: ♠ [1], ♥ [2], ♦ [3]

### Step 4 — Adapt options to prior choices

Each new card set must reflect the user's accumulated decisions. Examples:
- Picked React → UI library options: Shadcn/ui, MUI, Mantine (not Svelte-specific libs)
- Chose "adventure vacation" → Transport: Rental car, Motorcycle, Guided tours (not "cruise ship")
- Remote team offsite → Location: City hub, Resort, Virtual hybrid (not "local HQ")

The options should feel curated and tailored, never generic.

### Step 5 — Handle skip and back

- `s` — skip this category (record as "skipped", move to next)
- `b` — go back one step (re-render the previous category's cards, allow re-picking)
- Any other input: prompt again with `Pick 1, 2, or 3 (or s/b):`

### Step 6 — Final summary

After all categories are complete, render a summary box. Use a domain-appropriate label (YOUR STACK, YOUR TRIP, YOUR OFFSITE, YOUR PLAN, etc.):

```
╔══════════════════════════════════════════╗
║              YOUR STACK                  ║
╠══════════════════════════════════════════╣
║  Frontend:    React                      ║
║  UI Library:  Shadcn/ui                  ║
║  Backend:     Hono                       ║
║  Database:    PostgreSQL                 ║
║  ORM:         Drizzle                    ║
║  Auth:        Clerk                      ║
║  Deploy:      Fly.io                     ║
╚══════════════════════════════════════════╝

Next steps: Want a detailed setup guide for this stack?
```

Non-tech example:
```
╔══════════════════════════════════════════╗
║              YOUR TRIP                   ║
╠══════════════════════════════════════════╣
║  Destination:  Southeast Asia            ║
║  Pace:         Relaxed (7-10 days)       ║
║  Stay:         Boutique hotels           ║
║  Transport:    Flights + local transit   ║
║  Budget:       Mid-range (~$150/day)     ║
╚══════════════════════════════════════════╝

Next steps: Want a day-by-day itinerary?
```

**Summary rules:**
- Box width: 44 chars inner
- Title is centered, ALL CAPS, uses "YOUR [DOMAIN]"
- Each row: `║  Category:    Value   ║` — align the colons
- Skipped categories are omitted from the summary
- The "Next steps" line offers a natural follow-up action relevant to the domain

### Key principles

1. **Ask first, plan second** — never skip the "What are we planning?" question
2. **Think before you render** — reason through the full option space before picking the best 3; don't default to obvious or generic choices
3. **Always 3 cards** — no more, no fewer, every round
4. **Cards adapt** — later options must reflect earlier choices
5. **No template copying** — categories and options must be derived fresh from the user's actual situation, not from example sequences
6. **Domain-agnostic** — the methodology works for tech, travel, events, products, renovations, anything
7. **Crisp WHY/WHY NOT** — each reason fits in 2 lines, ~21 chars wide; be punchy, not verbose
8. **Clean summary** — the final box should feel satisfying and complete
