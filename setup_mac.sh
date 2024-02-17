#!/bin/sh
##########################
# Dock & Mission Control #
##########################
# Dock
defaults write com.apple.dock "tilesize" -int "36"
defaults write com.apple.dock "show-recents" -bool "false"
defaults write com.apple.dock autohide -bool "true"
defaults write com.apple.dock autohide-delay -float 0
defaults write com.apple.dock autohide-time-modifier -float 0.4

# Mission control
defaults write com.apple.dock "mru-spaces" -bool "false"
defaults write com.apple.dock "expose-group-apps" -bool "false"
defaults write NSGlobalDomain "AppleSpacesSwitchOnActivate" -bool "false"

killall Dock


####################
# Finder & Desktop #
####################
# Finder
defaults write NSGlobalDomain "AppleShowAllExtensions" -bool "true"
defaults write com.apple.finder "ShowPathbar" -bool "true"
defaults write com.apple.finder "FXPreferredViewStyle" -string "clmv"               # Column view
defaults write com.apple.finder "_FXSortFoldersFirst" -bool "true"
defaults write com.apple.finder "FXEnableExtensionChangeWarning" -bool "false"
defaults write NSGlobalDomain "NSTableViewDefaultSizeMode" -int "1"                 # size of icons in sidebar (small)

# Desktop
defaults write com.apple.finder "CreateDesktop" -bool "false" 
defaults write com.apple.finder "_FXSortFoldersFirstOnDesktop" -bool "true"

killall Finder


###############
# Screenshots #
###############
defaults write com.apple.screencapture "location" -string "~/Desktop" 
defaults write com.apple.screencapture "type" -string "png"

killall SystemUIServer

