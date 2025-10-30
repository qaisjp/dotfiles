###
# time but better https://superuser.com/a/767491/200031
###
if [[ `uname` == Darwin ]]; then
    MAX_MEMORY_UNITS=KB
else
    MAX_MEMORY_UNITS=MB
fi

TIMEFMT='%J   %U  user %S system %P cpu %*E total'$'\n'\
'avg shared (code):         %X KB'$'\n'\
'avg unshared (data/stack): %D KB'$'\n'\
'total (sum):               %K KB'$'\n'\
'max memory:                %M '$MAX_MEMORY_UNITS''$'\n'\
'page faults from disk:     %F'$'\n'\
'other page faults:         %R'
###### done



setopt correct
#export GIT_TRACE=1
export EDITOR=nvim
export GH_HOST=git.corp.stripe.com
function gcp-lite () { git diff $1~1 $1 | git apply }

a() {
	cd "$HOME/stripe/$1"
}

#b() {
#	cd "$HOME/stripe-b/$1"
#}

export PAY_DEFAULT_EDITOR=cursor
alias dotfiles-pull="git -C ~/.dotfiles pull"
alias t="pay remote ssh --tmux"
alias code=cursor
alias rg="rg -S"
#alias st="pay stack"
alias gcaf='git commit -a --fixup'
alias gri='git rebase -i'
alias grc='git rebase --continue'
alias skip="git commit -m '[ci-skip]'"
alias skipa="git commit -m '[ci-skip]' -a"
alias tf="sc-terraform"
alias vim='nvim'
alias vi='nvim'
alias caffeinate='caffeinate -dims'
alias terraform=sc-terraform
alias fetch="git fetch origin master"
alias fetchout="git fetch origin master && git checkout -B master origin/master && git checkout"
alias fetcherge="git fetch origin master && git merge origin/master --no-edit"
alias fetchbase="git fetch origin master && git rebase origin/master"
alias buildfast="pay ci:build --all-blocking --custom-json-params '{\"desired_worker_count\": 120}'"
alias gdc="git diff --cached"
alias dep="henson deploy --qa --no-amp --force --skip-rollout --no-prompt"
alias repoint-test-master="git branch -f qaisjp/test-master origin/master && git push origin qaisjp/test-master:qaisjp/test-master"
alias boop="git commit -am 'boop' && git push"
alias boopc="git commit -am 'boop [ci-skip]' && git push"
alias empty="git commit --allow-empty --no-edit"
alias stc="pay exec scripts/bin/typecheck"
alias flagon="pay exec lib/flag/scripts/set_flag_value.rb --on --flag-name"
alias flagoff="pay exec lib/flag/scripts/set_flag_value.rb --off --flag-name"
path+=~/.local/bin
path+=~/go/bin
path+=~/.nodenv/versions/18.14.0/bin
path+=~/.cargo/bin


# gmb = git merge branch
unalias gbm
function gmb() (
  set -e
  branch_name="$1"
  commit_to_merge="$2"

  git_tree=$(git merge-tree "$branch_name" "$commit_to_merge")
  merge_commit=$(git commit-tree "$git_tree" -p "$branch_name" -p "$commit_to_merge" -m "Merge $commit_to_merge into $branch_name")
  git branch -f "$branch_name" "$merge_commit"
)

function gmm() (
  set -e
  branch_name="$1"
  commit_to_merge="$(git rev-parse HEAD origin/master)"
  gmb "$branch_name" "$commit_to_merge"
)


function update-branch() {
  url="$1"
  # Extract "stripe-internal/devtools-testing" from "https://git.corp.stripe.com/stripe-internal/devtools-testing/pull/2300"
  repo="$(echo "$url" | sed -E 's/.*\/([^/]+)\/([^/]+)\/pull\/[0-9]+$/\1\/\2/')"
  pr_num="$(echo "$url" | sed -E 's/.*\/[^/]+\/[^/]+\/pull\/([0-9]+)$/\1/')"
  gh api -H 'Accept: application/vnd.github.lydian-preview+json' -X PUT "repos/${repo}/pulls/${pr_num}/update-branch"
}
