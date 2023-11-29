#!/bin/sh
#########################################
# Test Arch base install script         #
#                                       #
# Author: Dennis Bakhuis                #
# Date: 2023-11-25                      #
#########################################

TESTS_FOR="Arch base"
NUM_ERRORS=0

# Only run when on Arch
if [ "$(uname)" == "Linux" ]; then

    # test if pacman has color enabled
    if ! grep -q "^Color" /etc/pacman.conf; then
        echo "ERROR($TESTS_FOR): pacman does not have color enabled"
        NUM_ERRORS=$((NUM_ERRORS+1))
    fi
    
    # test if pacman has parallel downloads enabled
    if ! grep -q "^ParallelDownloads = 5" /etc/pacman.conf; then
        echo "ERROR($TESTS_FOR): pacman does not have parallel downloads enabled"
        NUM_ERRORS=$((NUM_ERRORS+1))
    fi
    
    # test if user exists
    if ! id -u $BASE_USER > /dev/null; then
        echo "ERROR($TESTS_FOR): user $BASE_USER does not exist"
        NUM_ERRORS=$((NUM_ERRORS+1))
    fi

    # test if user has password
    # does not work yet as I do not know how to hash using yescrypt
    # SALT=$(grep $USERNAME /etc/shadow | awk -F: '{print substr($2,4,8)}')
    # if [ "$SALT" != "" ]; then
    #     NEWPASS=$(echo $BASE_PASSWORD | openssl passwd -stdin -1 -salt $SALT | sed -r 's/^\$.\$//')
    #     # NEWPASS=$(echo $BASE_PASSWORD | openssl passwd -stdin -1 -salt $SALT | sed -r 's/^\$.\$//')
    #     grep $BASE_USER  /etc/shadow | grep -q  $NEWPASS && echo "Success" || echo "Failure"
    # fi
    
    # test if sudo is installed
    if ! pacman -Qs sudo > /dev/null; then
        echo "ERROR($TESTS_FOR): sudo is not installed, installing..."
        NUM_ERRORS=$((NUM_ERRORS+1))
    fi
    
    # test if wheel is turned on in sudoers
    if ! grep -q wheel /etc/sudoers; then
        echo "ERROR($TESTS_FOR): wheel is not turned on in sudoers"
        NUM_ERRORS=$((NUM_ERRORS+1))
    fi
    
    # test if user is in wheel group
    if ! groups $BASE_USER | grep -q wheel; then
        echo "ERROR($TESTS_FOR): user $BASE_USER is not in wheel group"
        NUM_ERRORS=$((NUM_ERRORS+1))
    fi
    
    # test if root is disabled
    if ! passwd -S root | grep -q "NP"; then
        echo "ERROR($TESTS_FOR): root is not disabled"
        NUM_ERRORS=$((NUM_ERRORS+1))
    fi
    
    # test if base-devel is installed
    if ! pacman -Qs base-devel > /dev/null; then
        echo "ERROR($TESTS_FOR): base-devel is not installed, installing..."
        NUM_ERRORS=$((NUM_ERRORS+1))
    fi

    # test if inetutils is installed
    if ! pacman -Qs inetutils > /dev/null; then
        echo "ERROR($TESTS_FOR): inetutils is not installed, installing..."
        NUM_ERRORS=$((NUM_ERRORS+1))
    fi

    # test if locale is set
    if ! grep -q "LANG=nl_NL.UTF-8" /etc/locale.conf; then
        echo "ERROR($TESTS_FOR): Language not set to nl_NL.UTF-8"
        NUM_ERRORS=$((NUM_ERRORS+1))
    fi
    if ! grep -q "LC_MESSAGES=en_US.UTF-8" /etc/locale.conf; then
        echo "ERROR($TESTS_FOR): System messages not set to en_US.UTF-8"
        NUM_ERRORS=$((NUM_ERRORS+1))
    fi

    # test if timezone is set to Europe/Amsterdam
    if ! grep -q "Europe/Amsterdam" <<< $(readlink /etc/localtime); then
        echo "ERROR($TESTS_FOR): Timezone not set to Europe/Amsterdam"
        NUM_ERRORS=$((NUM_ERRORS+1))
    fi
    
    ###############

    if [ $NUM_ERRORS -eq 0 ]; then
        echo " *** $TESTS_FOR: tests passed!"
    else
        echo " *** ERROR($TESTS_FOR): $NUM_ERRORS tests failed"
        exit 1
    fi
else
    echo " *** $TESTS_FOR: tests skipped as not on Arch"
fi
