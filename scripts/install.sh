#!/usr/bin/env bash
#
# giants-shoulders — one-time setup
#
# Asks the user (opt-in) whether to make "巨人之肩 / Giants' Shoulders" a default
# rule for their agent, so it gets called automatically before build-from-scratch
# tasks. If yes, idempotently appends a rule block to the agent instruction files
# it finds (AGENTS.md for Codex/TRAE/Cursor, CLAUDE.md for Claude Code).
#
# Safe to run multiple times: the rule is wrapped in marker comments and skipped
# if already present.
#
# Non-interactive use:
#   GIANTS_SHOULDERS_ASSUME_YES=1  ./install.sh   # install without prompting
#   GIANTS_SHOULDERS_ASSUME_NO=1   ./install.sh   # decline without prompting
#   GIANTS_SHOULDERS_HOME=/path    ./install.sh   # override target home (for testing)

set -euo pipefail

BEGIN_MARKER="<!-- giants-shoulders:begin -->"
END_MARKER="<!-- giants-shoulders:end -->"

HOME_DIR="${GIANTS_SHOULDERS_HOME:-$HOME}"

# The rule block. Kept identical to what SKILL.md documents so manual and scripted
# installs converge on the same text.
read -r -d '' RULE_BLOCK <<'EOF' || true
<!-- giants-shoulders:begin -->
## 开工前调研（巨人之肩 / Giants' Shoulders）

Before any **build-from-scratch task** — building a tool / script / library /
CLI / skill / plugin / agent / workflow / integration / prototype / product,
designing an architecture, choosing a framework or algorithm, or "reinventing
the wheel" — first invoke the `giants-shoulders` skill to scan for prior art:
search the internet for who has already solved this or an adjacent problem,
what to reuse, and how the current task differs, then proceed.

- Skip for trivial tasks (a one-line edit, translation, checking the time) and
  tasks with no external prior art (editing the user's own private files/data).
- If unsure whether it's worth it, ask the user one sentence first.

<!-- giants-shoulders:end -->
EOF

# Candidate agent instruction files, in priority order.
CANDIDATES=(
  "$HOME_DIR/AGENTS.md"          # Codex / TRAE / Cursor (machine-wide)
  "$HOME_DIR/.codex/AGENTS.md"   # Codex home
  "$HOME_DIR/.claude/CLAUDE.md"  # Claude Code
  "$HOME_DIR/CLAUDE.md"          # Claude Code (project-style, home root)
)

say()  { printf '%s\n' "$*"; }
info() { printf '  %s\n' "$*"; }

ask_consent() {
  if [ "${GIANTS_SHOULDERS_ASSUME_YES:-}" = "1" ]; then return 0; fi
  if [ "${GIANTS_SHOULDERS_ASSUME_NO:-}"  = "1" ]; then return 1; fi
  if [ ! -t 0 ]; then
    # No TTY and no explicit choice: do nothing rather than surprise the user.
    say "No interactive terminal detected and no choice set; skipping."
    say "Re-run with GIANTS_SHOULDERS_ASSUME_YES=1 to install non-interactively."
    return 1
  fi

  say ""
  say "🔭 巨人之肩 / Giants' Shoulders"
  say ""
  say "要不要把「巨人之肩」设为你 agent 的默认规则（推荐）？"
  say "设为默认后，agent 在开始创造类任务前会自动先做一遍现有方案调研。"
  say ""
  say "Make Giants' Shoulders a default rule for your agent (recommended)?"
  say "It will auto-run a prior-art scan before build-from-scratch tasks."
  say ""
  printf "  [Y/n] "
  read -r reply || reply=""
  case "$reply" in
    ""|y|Y|yes|YES|Yes) return 0 ;;
    *) return 1 ;;
  esac
}

# Append the rule block to a file if not already present. Creates the file
# (and parent dir) when missing. Returns 0 if it wrote, 1 if it skipped.
inject() {
  local file="$1"
  local dir
  dir="$(dirname "$file")"

  if [ -f "$file" ] && grep -qF "$BEGIN_MARKER" "$file"; then
    info "already configured: $file"
    return 1
  fi

  mkdir -p "$dir"
  if [ -f "$file" ]; then
    # Separate from existing content with a blank line.
    printf '\n%s\n' "$RULE_BLOCK" >> "$file"
    info "updated: $file"
  else
    printf '%s\n' "$RULE_BLOCK" > "$file"
    info "created: $file"
  fi
  return 0
}

main() {
  if ! ask_consent; then
    say ""
    say "Skipped. You can still call the skill manually with \$giants-shoulders,"
    say "or re-run this script anytime to set it as a default rule."
    exit 0
  fi

  say ""
  say "Setting Giants' Shoulders as a default rule..."

  local wrote_any=0 touched_any=0
  for f in "${CANDIDATES[@]}"; do
    # Only touch AGENTS.md files that already exist, plus always ensure at least
    # the primary AGENTS.md. CLAUDE.md files are touched only if they exist,
    # to avoid creating agent files the user doesn't use.
    case "$f" in
      "$HOME_DIR/AGENTS.md")
        touched_any=1
        if inject "$f"; then wrote_any=1; fi
        ;;
      *)
        if [ -f "$f" ]; then
          touched_any=1
          if inject "$f"; then wrote_any=1; fi
        fi
        ;;
    esac
  done

  say ""
  if [ "$wrote_any" = "1" ]; then
    say "Done. Giants' Shoulders is now a default rule."
    say "Restart your agent (or start a new session) to pick it up."
  elif [ "$touched_any" = "1" ]; then
    say "Already set up — nothing to change."
  else
    say "No agent instruction files were written."
  fi
}

main "$@"
