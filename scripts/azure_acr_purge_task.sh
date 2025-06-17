#!/bin/bash
# Script to create an Azure Container Registry (ACR) purge task.
#
# This script defines and schedules a task to purge untagged images older than 14 days
# from specified repositories in an Azure Container Registry, excluding specific tags.
#
# Author: Dennis Bakhuis
# Date: 6 January 2025
#
# Parameters
# ----------
# None
#     The script uses a predefined registry name (`tennetidcacr`) and filters.
#
# Usage
# -----
# Run the script directly to create the purge task in the specified registry:
#     ./script_name.sh
#
# Details
# -------
# - Filters:
#   The task purges repositories with names matching specified patterns,
#   excluding tags like `prod` and `release`.
# - Schedule:
#   The task is scheduled to run weekly on Sundays at 1:00 AM.
#
# Example
# -------
# The following task is created in ACR:
#   - Task Name: purge_task_devops
#   - Command:
#       Purge images older than 14 days from repositories matching the filters.
#   - Schedule: Weekly, Sundays at 1:00 AM.

REGISTRY_NAME="tennetidcacr"

# PURGE_COMMAND="acr purge \
#   --filter 'interface:^(?!^prod$).*$' \
#   --filter 'core:^(?!^prod$).*$' \
#   --filter 'idc-metrics-exporter:^(?!^prod$).*$' \
#   --filter 'idc-config:^(?!^prod$).*$' \
#   --untagged \
#   --ago 14d
# "

PURGE_COMMAND="acr purge \
  --filter 'interface:^(?!^(prod|release)$).*$' \
  --filter 'core:^(?!^(prod|release)$).*$' \
  --filter 'idc-metrics-exporter:^(?!^(prod|release)$).*$' \
  --filter 'idc-config:^(?!^(prod|release)$).*$' \
  --untagged \
  --ago 14d
"

az acr task create \
  --registry $REGISTRY_NAME \
  --name purge_task_devops \
  --cmd "$PURGE_COMMAND" \
  --schedule "0 1 * * Sun" \
  --context /dev/null
