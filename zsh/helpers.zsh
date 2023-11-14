#########################################
# Helper functions for init scripts     #
#                                       #
# Author: Dennis Bakhuis                #
# Date: 2023-11-14                      #
#########################################

DEFAULT_PRIORITY=500

# Extract priority parameter from script file
# usage: get_priority <script_file>
# returns: priority
get_priority() {
    local script_file="$1"
    local priority=$(grep -m 1 '^PRIORITY=' "$script_file" | awk -F= '{print $2}')
    echo "${priority:-$DEFAULT_PRIORITY}"
}


# Get all init files from folder sorted by priority
# usage: get_init_files_from_folder <folder>
# returns: sorted init files
get_init_files_from_folder() {
    declare -a script_array  # Declare an array to store script files
    
    # Iterate over all script files in the current directory
    for script_file in "$1"/**/*; do
        if [[ -f "$script_file" ]]; then
            priority=$(get_priority "$script_file")
            script_array+=("$script_file:$priority")
        fi
    done
    
    # Sort the array by priority and then by name
    IFS=$'\n' sorted_array=($(sort -t':' -k2,2n -k1,1 <<<"${script_array[*]}"))
    
    # Extract the sorted script files from the sorted array
    sorted_script_files=("${sorted_array[@]%%:*}")
    
    # Return the sorted script files
    for script_file in "${sorted_script_files[@]}"; do
        echo "$script_file"
    done
}
