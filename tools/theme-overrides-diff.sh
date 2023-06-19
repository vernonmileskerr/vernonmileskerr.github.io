#!/bin/bash
set -euo pipefail

echo "Only expecting small single line tweaks. If a large diff is displayed the theme
was probably updated. Consider updating the theme and then re-applying the overrides."

# Find the root directory of the current git repository
root_dir=$(git rev-parse --show-toplevel)
jekyll_dir=$(bundle info --path jekyll-theme-chirpy)
cd "${root_dir}"

# Find all directories in the root directory
for dir in $(find ${jekyll_dir} -type d -depth 1); do

  # Compute the relative path of the directory
  rel_dir=$(realpath $dir | sed "s|${jekyll_dir}/||")
  echo "Checking ${rel_dir}..."

  # Run git diff for each relevant directory
  if [[ -d "$root_dir/$rel_dir" ]]; then
    git --no-pager diff --no-index --diff-filter=M $jekyll_dir/$rel_dir $rel_dir || true
  else
    echo "skipped ${rel_dir} (no override)."
  fi
done
