local ret_status="%(?:%{$fg_bold[green]%}➜ :%{$fg_bold[red]%}➜ )"

if [[ $(hostname) =~ qa-mydev* ]]; then
    hostname="%n@$(cat /pay/conf/box-name)"
else
    hostname="%n@%m"
fi

# You may choose to remove %n@ vv here!
PROMPT='%{$fg_bold[green]%}'$hostname':%{$fg[cyan]%} %~%{$reset_color%} $(git_prompt_info)
${ret_status}%{$reset_color%}'

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg_bold[blue]%}git:(%{$fg[red]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%} "
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[blue]%}) %{$fg[yellow]%}✗"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[blue]%})"
