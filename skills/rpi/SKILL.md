---
name: rpi
description: >
  Research, Plan, Implement (RPI) — a structured 3-phase approach to any coding task.
  Use this skill whenever the user asks to build, add, implement, fix, create, refactor,
  or change anything in a codebase, especially for features or changes that touch multiple
  files. Do NOT jump straight to coding. First spawn a researcher sub-agent to map the
  relevant codebase and return a code-research summary. Then spawn a planner sub-agent
  passing the task and research to produce a detailed step-by-step plan with code snippets
  and a testing strategy. Finally implement to full completion using both documents as
  context. Triggers on: "implement", "build", "add", "fix", "create", "refactor",
  "change", "update". Always prefer RPI over writing code immediately.
---

# RPI — Research, Plan, Implement

You are the RPI orchestrator. Your job is to run three phases in sequence before writing
a single line of code. The agents/ directory contains instructions for specialized
sub-agents. Read the relevant agent file when you need to spawn that sub-agent.

---

## Phase 1 — Research

**Goal:** Understand the existing codebase before touching it.

1. Read `agents/researcher.md` to load the researcher sub-agent instructions.
2. Spawn a `general-purpose` sub-agent with:
   - The full contents of `agents/researcher.md` as the system role/instructions
   - The user's task appended as: `## Task\n{user's full request}`
3. Wait for the sub-agent to complete. Its entire text response is your **code-research**
   document. Hold it in memory — do not write it to a file.
4. Briefly summarise to the user: "✅ Research complete — found X relevant files."

---

## Phase 2 — Plan

**Goal:** Turn the research into a concrete, step-by-step implementation plan.

1. Read `agents/planner.md` to load the planner sub-agent instructions.
2. Spawn a `general-purpose` sub-agent with:
   - The full contents of `agents/planner.md` as the system role/instructions
   - The following context appended:

     ```
     ## Task
     {user's full request}

     ## Code Research
     {full code-research text from Phase 1}
     ```

3. Wait for the sub-agent to complete. Its entire text response is your
   **implementation-plan** document. Hold it in memory — do not write it to a file.
4. Briefly summarise to the user: "✅ Plan complete — N steps identified."

---

## Phase 3 — Implement

**Goal:** Execute the plan to full completion.

Using the original task, the code-research, and the implementation-plan as your complete
context:

1. Follow the implementation steps in order. Do not skip steps.
2. For each step:
   - State which step you are on (e.g., "Step 2/7 — Create the route handler")
   - Write the code exactly as planned, adjusting only if you discover a concrete
     reason during implementation (note the reason if you do)
3. After all steps are done, run the **Testing Plan** from the implementation-plan:
   - Execute each verification step
   - For every failure: diagnose the root cause, fix the code, and re-run that test
   - Keep iterating — do not stop at a failure. A failure is a signal to fix, not to stop.
   - If the same test fails 3 times in a row despite different fixes, pause and explain
     the blocker to the user before continuing.
4. When **all tests pass**, report a final summary:
   - What was built
   - Files created or modified
   - Any deviations from the plan and why

---

## Rules

- **Never skip phases.** Research and planning must complete before implementation begins.
- **Sub-agents return text only.** Do not ask them to write files. Capture their response.
- **Stay in context.** Both the code-research and implementation-plan must be passed
  forward and used — they are not optional background.
- **Complete the work.** The implement phase runs to full completion, including tests.
- **Never stop at a failure.** A failing test means fix and retry, not report and halt.
  Keep iterating until every test in the Testing Plan is green.
