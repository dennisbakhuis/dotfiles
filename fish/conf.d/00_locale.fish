# Locale
# Author: Dennis Bakhuis
# Date: 2026-05-18
#
# Dutch formatting (dates, numbers, currency, paper, sort order) with
# English program output. Mirrors the system locale set on Arch in
# install_scripts/arch_base.sh. Loaded with a 00_ prefix so it runs before
# fetch.fish and any other conf.d files that read locale env vars.

if test -z "$LANG"
    set -gx LANG nl_NL.UTF-8
end

if test -z "$LC_MESSAGES"
    set -gx LC_MESSAGES en_US.UTF-8
end
