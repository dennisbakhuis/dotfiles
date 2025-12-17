#!/bin/bash
#########################################
# Script to install base Arch tools     #
#                                       #
# Installs + sets up:                   #
# - Creates new user                    #
# - Installs sudo                       #
# - Adds user to wheel group            #
# - installs base-devel                 #
#                                       #
# Author: Dennis Bakhuis                #
# Date: 2023-11-22                      #
#########################################

# Exit on error; only set if not already set
if [ -z "$-printf" ]; then
    set -e
fi


############
# Settings #
############
BASE_ARCH_INSTALL=${BASE_ARCH_INSTALL:-true}    # Install base arch tools (default: true)
BASE_USER=${BASE_USER:-dennis}                  # Add user with username
BASE_PASSWORD=${BASE_PASSWORD}                  # Password must be set in environment


########
# Main #
########
if [ -f /etc/arch-release ]; then  # Only run if on Arch

    if [ "$BASE_ARCH_INSTALL" = true ]; then

        # Only run as root
        if [ "$(id -u)" -eq 0 ]; then

            #############
            # Arch init #
            #############

            # Make Pacman colorful and enable parallel downloads if required
            printf " *** Setting up pacman...\n"
            if grep -q "^Color" /etc/pacman.conf; then
                printf " *** Color is already enabled...\n"
            else
                printf " *** Enabling color...\n"
                sed -i "s/^#Color/Color/" /etc/pacman.conf
            fi
            if grep -q "^#ParallelDownloads = 5" /etc/pacman.conf; then
                printf " *** ParallelDownloads is already enabled...\n"
            else
                printf " *** Enabling ParallelDownloads...\n"
                sed -i "s/^#ParallelDownloads = 5/ParallelDownloads = 5/" /etc/pacman.conf
            fi

            # init pacman keyring if required and create secret key
            if [ ! -f /etc/pacman.d/gnupg ]; then
                printf " *** Initializing pacman keyring...\n"
                pacman-key --init

                # check if on arm or amd64
                if uname -m | grep -q arm; then
                    printf " *** Installing archlinuxarm keyring...\n"
                    pacman-key --populate archlinuxarm
                else
                    printf " *** Installing archlinux keyring...\n"
                    pacman-key --populate archlinux
                fi
            fi

            # update
            printf " *** Updating system...\n"
            pacman -Syy --noconfirm && pacman -Syu --noconfirm


            ########
            # Sudo #
            ########

            # Install sudo if required
            if command -v sudo &> /dev/null; then
                printf " *** sudo is already installed...\n"
            else
                printf " *** Installing sudo...\n"
                pacman -Sy --noconfirm sudo
            fi

            # Uncommend wheel group in sudoers if required
            printf " *** Enabling wheel group in sudoers...\n"
            sed -i "s/^# %wheel ALL=(ALL:ALL) ALL/%wheel ALL=(ALL:ALL) ALL/" /etc/sudoers

            # Check if sudo insults are already enabled
            if grep -q insults /etc/sudoers; then
                printf " *** sudo insults are already enabled...\n"
            else
                printf " *** Enabling sudo insults...\n"
                printf "Defaults insults" >> /etc/sudoers
            fi


            ############
            # New user #
            ############

            # Create new user if not exists and add to wheel
            if id -u $BASE_USER > /2>&1; then
                printf " *** User $BASE_USER already exists...\n"

                # check if user is in wheel group
                if groups $BASE_USER | grep -q wheel; then
                    printf " *** User $BASE_USER is already in wheel group...\n"
                else
                    printf " *** Adding user $BASE_USER to wheel group...\n"
                    usermod -aG wheel $BASE_USER
                fi
            else
                printf " *** Creating new user $BASE_USER...\n"

                # Check if password is set
                if [ -z "$BASE_PASSWORD" ]; then
                    printf "BASE_PASSWORD is required to create user, exiting...\n"
                    exit 1
                fi

                useradd -rm -G wheel -s /bin/bash -u 1001 $BASE_USER

                printf " *** Setting password for new user $BASE_USER...\n"
                printf " -----> \`$BASE_USER\`:\`$BASE_PASSWORD\`\n"
                echo "$BASE_USER:$BASE_PASSWORD" | chpasswd
            fi


            #######################
            # Turn off root login #
            #######################

            # Check if root is already disabled
            if passwd -S root | grep -q "NP"; then
                printf " *** Root is already disabled...\n"
            else
                printf " *** Disabling root login...\n"
                passwd -d root
            fi


            ####################################
            # Install base-devel and inetutils #
            ####################################

            # Install base-devel if required
            if pacman -Qs base-devel > /dev/null; then
                printf " *** base-devel is already installed...\n"
            else
                printf " *** Installing base-devel...\n"
                pacman -Sy --noconfirm base-devel
            fi

            # Install inetutils if required
            if pacman -Qs inetutils > /dev/null; then
                printf " *** inetutils is already installed...\n"
            else
                printf " *** Installing inetutils...\n"
                pacman -Sy --noconfirm inetutils
            fi


            ###############################################
            # Setup locale to en_US.UTF-8 and nl_NL.UTF-8 #
            ###############################################

            # Turn on en_US.UTF-8 and nl_NL.UTF-8 locales
            printf " *** Uncommenting en_US.UTF-8 and nl_NL.UTF-8 in /etc/locale.gen ...\n"
            sed -i "s/^#en_US.UTF-8/en_US.UTF-8/g" /etc/locale.gen
            sed -i "s/^#nl_NL.UTF-8/nl_NL.UTF-8/g" /etc/locale.gen

            # Set system locale to en_US.UTF-8
            printf " *** Setting system locale to NL but have EN speaking system...\n"
            echo -e "LANG=nl_NL.UTF-8\nLC_MESSAGES=en_US.UTF-8" > /etc/locale.conf

            # Generate locales
            # in docker containers many locales are missing (only used for my tests)
            # check if lines with the string i18n are in pacman.conf
            if grep -q "i18n" /etc/pacman.conf; then
                printf " *** In container with NoExtract for glibc (reinstalling)...\n"
                sed -i '/i18n/d' /etc/pacman.conf
                pacman -S --noconfirm glibc
            else
                printf " *** Generating locales...\n"
                locale-gen
            fi

            # Set timezone to Europe/Amsterdam
            printf " *** Setting timezone to Europe/Amsterdam...\n"
            ln -sf /usr/share/zoneinfo/Europe/Amsterdam /etc/localtime


        else
            printf " *** Skipping Arch Base install, already running as regular user...\n"
        fi
    fi
else
    printf " *** Skipping Arch Base install, this is not Arch Linux...\n"
fi
