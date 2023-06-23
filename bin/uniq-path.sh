#!/bin/bash

env_var_name=$1

old_IFS="$IFS"
IFS=':'
read -ra path_array <<< "${!env_var_name}"
IFS="$old_IFS"

declare -A unique_paths
unique_path_array=()

for path in "${path_array[@]}"; do
    if [ -z "${unique_paths[$path]}" ]; then
        unique_paths[$path]=1
        unique_path_array+=("$path")
    fi
done

new_env_var=$(IFS=':'; echo "${unique_path_array[*]}")

echo "$new_env_var"
