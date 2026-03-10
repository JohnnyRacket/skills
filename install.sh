#!/usr/bin/env bash
# install.sh - Link skills from this repo into the Claude skills ecosystem
#
# Creates two-layer symlinks matching the skills.sh convention:
#   Layer 1: ~/.agents/skills/<name>  ->  ~/Development/skills/skills/<name>
#   Layer 2: ~/.claude/skills/<name>  ->  ~/.agents/skills/<name>
#
# Requires: symlinks enabled (Windows: Developer Mode on, or run as admin)

set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILLS_SRC="$REPO_DIR/skills"
AGENTS_SKILLS="$HOME/.agents/skills"
CLAUDE_SKILLS="$HOME/.claude/skills"

mkdir -p "$AGENTS_SKILLS"
mkdir -p "$CLAUDE_SKILLS"

linked=0
skipped=0

for skill_dir in "$SKILLS_SRC"/*/; do
  [[ -d "$skill_dir" ]] || continue
  [[ -f "$skill_dir/SKILL.md" ]] || continue

  name="$(basename "$skill_dir")"
  agents_target="$AGENTS_SKILLS/$name"
  claude_target="$CLAUDE_SKILLS/$name"

  # Layer 1: repo -> ~/.agents/skills/
  if [[ -L "$agents_target" ]]; then
    echo "  skip  $name (already linked in ~/.agents/skills/)"
  else
    ln -s "$skill_dir" "$agents_target"
    echo "  link  ~/.agents/skills/$name -> $skill_dir"
  fi

  # Layer 2: ~/.agents/skills/ -> ~/.claude/skills/
  if [[ -L "$claude_target" ]]; then
    echo "  skip  $name (already linked in ~/.claude/skills/)"
  else
    ln -s "$agents_target" "$claude_target"
    echo "  link  ~/.claude/skills/$name -> ~/.agents/skills/$name"
  fi

  ((linked++)) || true
done

if [[ $linked -eq 0 ]]; then
  echo "No skills found in $SKILLS_SRC — add a skill directory with a SKILL.md to get started."
else
  echo ""
  echo "Done. $linked skill(s) processed."
fi
