# Locale
# Author: Dennis Bakhuis
# Date: 2026-05-18
#
# Some terminals / SSH sessions arrive with LANG unset, which makes tools
# (man, perl, python, locale-aware sorts) fall back to the C locale and
# emit "Unknown locale, assuming C" or break UTF-8 rendering.

if test -z "$LANG"
    set -gx LANG en_US.UTF-8
end
