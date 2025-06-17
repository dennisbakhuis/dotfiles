#!/bin/bash
# Script to list repositories and their tags from an Azure Container Registry (ACR).
#
# This script accepts the ACR name as an input and retrieves a JSON representation
# of all repositories along with their respective tags.
#
# Author: Dennis Bakhuis
# Date  : 6 January 2025
#
# Parameters
# ----------
# ACR_NAME : str
#     The name of the Azure Container Registry.
#
# Usage
# -----
# Run the script by passing the ACR name as an argument:
#     ./script_name.sh <ACR_NAME>
#
# Outputs
# -------
# A JSON object containing repositories as keys and their respective tags as values.
# If ACR_NAME is not provided, an error message is returned, and the script exits.
#
# Example
# -------
# Input:
#     ./script_name.sh my-acr-name
# Output:
#     {
#         "repository1": ["tag1", "tag2"],
#         "repository2": ["tag1", "tag2"]
#     }

ACR_NAME=$1

if [ -z "$ACR_NAME" ]; then
  printf "{\"error\": \"ACR_NAME is required\"}\n"
  exit 1
fi

REPOSITORIES="$(az acr repository list -n $ACR_NAME --output tsv)"

printf "{\n"
DELIMITER=""
for REPO in $REPOSITORIES; do
  TAGS="$(az acr repository show-tags -n $ACR_NAME --repository $REPO --output json)" # ensure tags are in JSON format

  printf "%s\n  \"%s\": %s" "$DELIMITER" "$REPO" "$TAGS"

  DELIMITER=","
done
printf "\n}\n"
