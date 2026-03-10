# skills

Personal Claude agent skills repository. Structured to match [skills.sh](https://skills.sh/) conventions so skills can be published via GitHub.

## Local Setup

```bash
bash install.sh
```

This copies each skill into both `~/.agents/skills/` and `~/.claude/skills/`.
Re-running overwrites existing copies, so your changes stay in sync.

## Install from GitHub

Once this repo is public on GitHub:

```bash
npx skills add johnr/skills
```

## Skill Structure

Each skill lives in `skills/<name>/`:

```
skills/
└── my-skill/
    ├── SKILL.md          # required — frontmatter + instructions
    ├── scripts/          # optional — Python/Node helper scripts
    ├── references/       # optional — reference docs bundled with the skill
    ├── assets/           # optional — templates, icons, other static files
    └── evals/            # optional — test cases (excluded from packaging)
        └── evals.json
```

### SKILL.md frontmatter

```yaml
---
name: my-skill
description: >
  What this skill does and when Claude should use it. Be specific about
  trigger conditions — Claude tends to undertrigger skills, so be pushy.
---
```

Rules:
- `name`: kebab-case, max 64 chars
- `description`: no angle brackets; ~100 words is ideal for trigger accuracy

## Packaging for publishing

```bash
python -m scripts.package_skill skills/my-skill/
```

Produces `my-skill.skill` (ZIP), excluding `evals/`, `__pycache__/`, etc.
