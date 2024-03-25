###################
# Isomorphic copy #
###################
# Isomorphic-copy makes sure that copying between tmux, vim, and the system clipboard works.
# https://github.com/ms-jpq/isomorphic_copy/tree/master


# Settings
ZSH_INIT_ISOMORPHIC_COPY=${ZSH_INIT_ISOMORPHIC_COPY:-"true"}   # enable exa
PRIORITY=200                           # priority of this script
ISOMORPHIC_COPY_PATH="$HOME/.tools/isomorphic_copy"


# Init Exa
if [ "$ZSH_INIT_ISOMORPHIC_COPY" = "true" ]; then
  if [ -d "$ISOMORPHIC_COPY_PATH" ]; then
    export PATH="$ISOMORPHIC_COPY_PATH/bin:$PATH"
  fi
fi
