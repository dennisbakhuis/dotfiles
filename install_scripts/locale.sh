#!/bin/bash
##########################
# Locale                 #
##########################
# Ensures en_US.UTF-8 and nl_NL.UTF-8 are generated so the fish-side
# LANG=nl_NL.UTF-8 / LC_MESSAGES=en_US.UTF-8 setup in fish/conf.d/00_locale.fish
# actually resolves to a real locale instead of falling back to C.
#
# macOS ships these locales pre-built. Arch handles it in stage 0
# (install_scripts/arch_base.sh). This script covers Ubuntu / Debian.

print_header "Locale"

if [ "$OS_TYPE" != "ubuntu" ]; then
    print_info "Locale setup not needed on $OS_TYPE (handled elsewhere)"
    return 0 2>/dev/null || exit 0
fi

# Install the locales package if missing
if ! dpkg -s locales >/dev/null 2>&1; then
    print_step "Installing locales package"
    eval "$PKG_INSTALL_NONINTERACTIVE locales"
    print_success "Installed locales"
else
    print_info "locales package already installed"
fi

# Uncomment the locales we need in /etc/locale.gen
LOCALE_GEN_CHANGED=0
for loc in en_US.UTF-8 nl_NL.UTF-8; do
    if grep -qE "^# *${loc} UTF-8" /etc/locale.gen; then
        print_step "Enabling $loc in /etc/locale.gen"
        sudo sed -i "s/^# *\(${loc} UTF-8\)/\1/" /etc/locale.gen
        LOCALE_GEN_CHANGED=1
    elif grep -qE "^${loc} UTF-8" /etc/locale.gen; then
        print_info "$loc already enabled in /etc/locale.gen"
    else
        print_step "Adding $loc to /etc/locale.gen"
        echo "${loc} UTF-8" | sudo tee -a /etc/locale.gen >/dev/null
        LOCALE_GEN_CHANGED=1
    fi
done

# Regenerate locales only if we changed something or the target is missing
if [ "$LOCALE_GEN_CHANGED" = "1" ] || ! locale -a 2>/dev/null | grep -qiE "^nl_NL\.utf-?8$"; then
    print_step "Running locale-gen"
    sudo locale-gen
    print_success "Locales generated"
else
    print_info "Locales already generated"
fi

# Set the system-wide default in /etc/default/locale so non-fish shells
# (cron jobs, scp/ssh login envs that read it, etc.) also pick it up.
DEFAULT_LOCALE_FILE=/etc/default/locale
DESIRED_DEFAULT_LOCALE="LANG=nl_NL.UTF-8
LC_MESSAGES=en_US.UTF-8"

if [ ! -f "$DEFAULT_LOCALE_FILE" ] || ! diff -q <(echo "$DESIRED_DEFAULT_LOCALE") "$DEFAULT_LOCALE_FILE" >/dev/null 2>&1; then
    print_step "Writing system default locale to $DEFAULT_LOCALE_FILE"
    echo "$DESIRED_DEFAULT_LOCALE" | sudo tee "$DEFAULT_LOCALE_FILE" >/dev/null
    print_success "System default locale set (LANG=nl_NL.UTF-8, LC_MESSAGES=en_US.UTF-8)"
else
    print_info "System default locale already configured"
fi

print_success "Locale configured"
