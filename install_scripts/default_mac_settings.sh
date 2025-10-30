#!/bin/sh
#########################################
# macOS System Defaults Configuration   #
#                                       #
# Configures various macOS settings    #
# for better developer experience       #
#                                       #
# Author: Dennis Bakhuis                #
# Date: 2025-10-10                      #
#########################################

# Exit on error
set -e

printf " *** Configuring macOS system defaults...\n"

#####################
# General UI/UX     #
#####################
printf " *** Configuring General UI/UX settings...\n"

# Refresh sudo timestamp (assumes password was already provided by main installer)
# This prevents sudo from asking for password again during this script
# Use BASE_PASSWORD if available
if [ -n "$BASE_PASSWORD" ]; then
    echo "$BASE_PASSWORD" | sudo -S -v 2>/dev/null
else
    sudo -v
fi

# Disable the sound effects on boot
sudo nvram SystemAudioVolume=" "

# Expand save panel by default
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true

# Expand print panel by default
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint2 -bool true

# Disable the "Are you sure you want to open this application?" dialog
defaults write com.apple.LaunchServices LSQuarantine -bool false

# Disable automatic capitalization
defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false

# Disable smart dashes
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false

# Disable automatic period substitution
defaults write NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool false

# Disable smart quotes
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false

# Disable auto-correct
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false


#####################
# Display           #
#####################
printf " *** Configuring Display settings...\n"

# Disable auto-brightness adjustment
sudo defaults write /Library/Preferences/com.apple.iokit.AmbientLightSensor "Automatic Display Enabled" -bool false

# Disable auto-brightness for current user (backup method)
defaults write com.apple.BezelServices dAuto -bool false

# Disable True Tone (if available)
defaults write com.apple.CoreBrightness TrueTone -bool false


#####################
# Keyboard & Input  #
#####################
printf " *** Configuring Keyboard & Input settings...\n"

# Set a blazingly fast keyboard repeat rate
defaults write NSGlobalDomain KeyRepeat -int 2
defaults write NSGlobalDomain InitialKeyRepeat -int 15

# Enable full keyboard access for all controls (Tab in modal dialogs)
defaults write NSGlobalDomain AppleKeyboardUIMode -int 3

# Remap Caps Lock to Control
# Note: This requires the keyboard identifier which varies per device
# We'll attempt to set it for all connected keyboards
printf " *** Remapping Caps Lock to Control...\n"

# Get all keyboard product IDs and vendor IDs
KEYBOARD_IDS=$(ioreg -n IOHIDKeyboard -r | grep -E '(VendorID|ProductID)' | awk '{ print $4 }' | paste -s -d'-\n' -)

if [ -n "$KEYBOARD_IDS" ]; then
    # Loop through each keyboard and set Caps Lock to Control
    while IFS='-' read -r vendor product; do
        defaults -currentHost write -g "com.apple.keyboard.modifiermapping.${vendor}-${product}-0" -array-add '
        <dict>
            <key>HIDKeyboardModifierMappingDst</key>
            <integer>30064771302</integer>
            <key>HIDKeyboardModifierMappingSrc</key>
            <integer>30064771129</integer>
        </dict>
        '
        printf " *** Set Caps Lock → Control for keyboard ${vendor}-${product}\n"
    done <<< "$KEYBOARD_IDS"
else
    printf " *** Warning: No keyboards detected. Caps Lock remapping will apply on next connection.\n"
fi

# Alternative: Use hidutil for immediate effect (requires reboot or logout to persist)
# This works for the current session
hidutil property --set '{"UserKeyMapping":[{"HIDKeyboardModifierMappingSrc":0x700000039,"HIDKeyboardModifierMappingDst":0x7000000E0}]}' >/dev/null 2>&1 || true


#####################
# Trackpad & Mouse  #
#####################
printf " *** Configuring Trackpad & Mouse settings...\n"

# Trackpad: DISABLE tap to click (require physical press)
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool false
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 0
defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 0

# Enable three finger drag
defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerDrag -bool true
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadThreeFingerDrag -bool true


#####################
# Screenshots       #
#####################
printf " *** Configuring Screenshot settings...\n"

# Save screenshots to the desktop
defaults write com.apple.screencapture location -string "${HOME}/Desktop"

# Save screenshots in PNG format (other options: BMP, GIF, JPG, PDF, TIFF)
defaults write com.apple.screencapture type -string "png"

# Disable shadow in screenshots
defaults write com.apple.screencapture disable-shadow -bool true


#####################
# Finder            #
#####################
printf " *** Configuring Finder settings...\n"

# Show all filename extensions
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# Show status bar
defaults write com.apple.finder ShowStatusBar -bool true

# Show path bar
defaults write com.apple.finder ShowPathbar -bool true

# Display full POSIX path as Finder window title
defaults write com.apple.finder _FXShowPosixPathInTitle -bool true

# Keep folders on top when sorting by name
defaults write com.apple.finder _FXSortFoldersFirst -bool true
defaults write com.apple.finder _FXSortFoldersFirstOnDesktop -bool true

# When performing a search, search the current folder by default
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

# Disable the warning when changing a file extension
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

# Use column view in all Finder windows by default
# Four-letter codes for the other view modes: `icnv`, `clmv`, `glyv`, `Nlsv`
defaults write com.apple.finder FXPreferredViewStyle -string "clmv"

# Disable the warning before emptying the Trash
defaults write com.apple.finder WarnOnEmptyTrash -bool false

# Show the ~/Library folder
chflags nohidden ~/Library

# Show the /Volumes folder
sudo chflags nohidden /Volumes

# Enable snap-to-grid for icons on the desktop and in other icon views
defaults write com.apple.finder SnapToGrid -bool true


#####################
# Desktop           #
#####################
printf " *** Configuring Desktop settings...\n"

# Show desktop icons (for working with files on desktop)
defaults write com.apple.finder CreateDesktop -bool true

# Desktop icon view settings
# Enable snap-to-grid for desktop icons
/usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:arrangeBy dateAdded" ~/Library/Preferences/com.apple.finder.plist 2>/dev/null || \
/usr/libexec/PlistBuddy -c "Add :DesktopViewSettings:IconViewSettings:arrangeBy string dateAdded" ~/Library/Preferences/com.apple.finder.plist 2>/dev/null || true

# Set grid spacing for desktop icons (larger values = more space between icons)
/usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:gridSpacing 54" ~/Library/Preferences/com.apple.finder.plist 2>/dev/null || \
/usr/libexec/PlistBuddy -c "Add :DesktopViewSettings:IconViewSettings:gridSpacing integer 54" ~/Library/Preferences/com.apple.finder.plist 2>/dev/null || true

# Set icon size for desktop (32-512, default is 64)
/usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:iconSize 64" ~/Library/Preferences/com.apple.finder.plist 2>/dev/null || \
/usr/libexec/PlistBuddy -c "Add :DesktopViewSettings:IconViewSettings:iconSize integer 64" ~/Library/Preferences/com.apple.finder.plist 2>/dev/null || true


#####################
# Dock              #
#####################
printf " *** Configuring Dock settings...\n"

# Set the icon size of Dock items
defaults write com.apple.dock tilesize -int 32

# Minimize windows into their application's icon
defaults write com.apple.dock minimize-to-application -bool true

# Show indicator lights for open applications in the Dock
defaults write com.apple.dock show-process-indicators -bool true

# Don't show recent applications in Dock
defaults write com.apple.dock show-recents -bool false

# Automatically hide and show the Dock
defaults write com.apple.dock autohide -bool true

# Remove the auto-hiding Dock delay
defaults write com.apple.dock autohide-delay -float 0

# Speed up the animation when hiding/showing the Dock
defaults write com.apple.dock autohide-time-modifier -float 0.2

# Do not make Dock icons of hidden applications translucent
defaults write com.apple.dock showhidden -bool false

# Set the minimize/maximize window effect
defaults write com.apple.dock mineffect -string "genie"

# Don't automatically rearrange Spaces based on most recent use
defaults write com.apple.dock mru-spaces -bool false


#####################
# Mission Control   #
#####################
printf " *** Configuring Mission Control settings...\n"

# Don't group windows by application in Mission Control
defaults write com.apple.dock expose-group-apps -bool false

# Don't automatically switch to a Space with open windows for an application
defaults write NSGlobalDomain AppleSpacesSwitchOnActivate -bool false


#####################
# Menu Bar          #
#####################
printf " *** Configuring Menu Bar settings...\n"

# Set menu bar item spacing (requires restart)
defaults -currentHost write -globalDomain NSStatusItemSpacing -int 4
defaults -currentHost write -globalDomain NSStatusItemSelectionPadding -int 4


#####################
# Activity Monitor  #
#####################
printf " *** Configuring Activity Monitor settings...\n"

# Show the main window when launching Activity Monitor
defaults write com.apple.ActivityMonitor OpenMainWindow -bool true

# Show all processes in Activity Monitor
defaults write com.apple.ActivityMonitor ShowCategory -int 0

# Sort Activity Monitor results by CPU usage
defaults write com.apple.ActivityMonitor SortColumn -string "CPUUsage"
defaults write com.apple.ActivityMonitor SortDirection -int 0


#####################
# TextEdit          #
#####################
printf " *** Configuring TextEdit settings...\n"

# Use plain text mode for new TextEdit documents
defaults write com.apple.TextEdit RichText -int 0

# Open and save files as UTF-8 in TextEdit
defaults write com.apple.TextEdit PlainTextEncoding -int 4
defaults write com.apple.TextEdit PlainTextEncodingForWrite -int 4


#####################
# Time Machine      #
#####################
printf " *** Configuring Time Machine settings...\n"

# Prevent Time Machine from prompting to use new hard drives as backup volume
defaults write com.apple.TimeMachine DoNotOfferNewDisksForBackup -bool true


#####################
# Apply Changes     #
#####################
printf " *** Applying changes (restarting affected applications)...\n"

# Restart affected applications
killall Dock 2>/dev/null || true
killall Finder 2>/dev/null || true
killall SystemUIServer 2>/dev/null || true

printf " *** ✓ macOS defaults configured successfully!\n"
printf " *** Note: Some changes may require a logout/restart to take full effect.\n"