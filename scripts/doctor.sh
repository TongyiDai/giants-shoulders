#!/usr/bin/env bash
set -u

root="$(cd "$(dirname "$0")/.." && pwd)"
git_ok=0
installer_ok=0
command -v git >/dev/null 2>&1 && git_ok=1
[ -x "$root/scripts/install.sh" ] && installer_ok=1

if [ "${1:-}" = "--json" ]; then
  printf '{"ok":%s,"skill_root":"%s","required":{"git":%s,"installer":%s},"capabilities":{"web_search":"host-provided","network":"host-provided"},"next":"%s"}\n' \
    "$([ "$git_ok" = 1 ] && [ "$installer_ok" = 1 ] && echo true || echo false)" \
    "$root" "$([ "$git_ok" = 1 ] && echo true || echo false)" \
    "$([ "$installer_ok" = 1 ] && echo true || echo false)" \
    "$([ "$git_ok" = 1 ] && [ "$installer_ok" = 1 ] && echo 'run the bounded prior-art scan' || echo 'install the missing local prerequisite')"
  exit 0
fi

echo "skill_root=$root"
echo "git=$([ "$git_ok" = 1 ] && echo ready || echo missing)"
echo "installer=$([ "$installer_ok" = 1 ] && echo executable || echo missing)"
echo "web_search=host-provided"
echo "status=$([ "$git_ok" = 1 ] && [ "$installer_ok" = 1 ] && echo ready || echo blocked)"
