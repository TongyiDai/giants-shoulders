# Runtime and search capability contract

This Skill has no network client of its own. It uses the active Agent host's
web search, code-host search, package registry, and page-fetch capabilities.

Run `scripts/doctor.sh --json` for local checks, then determine whether the
host exposes web search. If search is unavailable, report `blocked_no_search`
and do not manufacture prior art from memory.

Keep the scan bounded: normally 3–6 targeted queries and at most 10 total. Each
named project needs a verifiable URL, maintenance signal, and license when
reuse is suggested. The result must end with one verdict and a concrete next
step.
