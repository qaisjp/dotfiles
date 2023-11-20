#!/usr/bin/env bash

# Notes:
# - Using `fname () ( ... )` instead of `function fname { ... }` because the
#   former creates a subshell, which allows `set -e` to not close the terminal.

# psc = push stack (by) commit
function psc () (
  set -e

  commits=()

  for commit in "$@"
  do
    # Read the commit title at that commit
    title=$(git log -1 --format=%s "$commit")

    # Check that title starts with "[STACK POINTER] "
    if [ "${title:0:16}" != "[STACK POINTER] " ]; then
      echo "psc: commit $commit does not start with [STACK POINTER]"
      return
    fi

    # Extract the stack pointer
    stack_pointer=${title:16}
    echo "psc: pushing ${commit} to ${stack_pointer}"
    commits+=("${commit}:refs/heads/${stack_pointer}")
  done

  # Make sure the commit is specified
  if [ ${#commits[@]} -eq 0 ]; then
    echo "psc: commit not specified"
    return
  fi

  # TODO: not sure how this behaves for branches with spaces in them?
  git push --force --atomic origin "${commits[@]}"
)

# psa = push stack all
function psa () (
  set -e

  commits=()
  while IFS='' read -r line; do
    commits+=("$line")
  done < <(git log origin/master.. --format='%H %s' | grep '\[STACK POINTER\]' | cut -w -f1)

  psc "${commits[@]}"
)
