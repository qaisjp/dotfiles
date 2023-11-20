#!/usr/bin/env bash

# psc = push stack (by) commit
function psc {
  commit=$1

  # Make sure the commit is specified
  if [ -z "$commit" ]; then
      echo "psc: commit specified"
      return
  fi

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
  git push --force origin "${commit}:refs/heads/${stack_pointer}"
}
