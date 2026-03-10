#!/usr/bin/env bash
# install.sh - Copy skills from this repo into the Claude skills ecosystem
#
# Copies each skill directory into ~/.agents/skills/ and ~/.claude/skills/.
# Re-running overwrites existing copies so changes in this repo stay in sync.

set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILLS_SRC="$REPO_DIR/skills"
AGENTS_SKILLS="$HOME/.agents/skills"
CLAUDE_SKILLS="$HOME/.claude/skills"

mkdir -p "$AGENTS_SKILLS"
mkdir -p "$CLAUDE_SKILLS"

copied=0

for skill_dir in "$SKILLS_SRC"/*/; do
  [[ -d "$skill_dir" ]] || continue
  [[ -f "$skill_dir/SKILL.md" ]] || continue

  name="$(basename "$skill_dir")"

  # Copy into ~/.agents/skills/
  cp -r "$skill_dir" "$AGENTS_SKILLS/$name"
  echo "  copy  ~/.agents/skills/$name"

  # Copy into ~/.claude/skills/
  cp -r "$skill_dir" "$CLAUDE_SKILLS/$name"
  echo "  copy  ~/.claude/skills/$name"

  ((copied++)) || true
done

if [[ $copied -eq 0 ]]; then
  echo "No skills found in $SKILLS_SRC — add a skill directory with a SKILL.md to get started."
else
  echo ""
  echo "Done. $copied skill(s) installed."
fi
