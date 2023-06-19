#!/bin/bash
set -euo pipefail

rel_file=$1

# Find the root directory of the current git repository
root_dir=$(git rev-parse --show-toplevel)
jekyll_dir=$(bundle info --path jekyll-theme-chirpy)
cd "${root_dir}"

# If file exists relative to jekyll_dir copy it into the root directory (but only if it doesn't
# already exist in root if it does print an error).

if [[ -f "$jekyll_dir/$rel_file" ]]; then
  if [[ -f "$root_dir/$rel_file" ]]; then
    echo "File already exists in root directory: $rel_file"
    exit 1
  else
    cp "$jekyll_dir/$rel_file" "$root_dir/$rel_file"
  fi
else
  echo "File does not exist in jekyll directory: $rel_file"
  exit 1
fi