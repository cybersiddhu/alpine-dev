autoload -Uz compaudit compinit
compinit

###
# History
###
HISTFILE=~/.zsh_history         # where to store zsh config
HISTSIZE=5024                   # big history
SAVEHIST=5024                   # big history
setopt append_history           # append
setopt inc_append_history	# append in order
setopt extended_history		# extended history format
setopt hist_ignore_all_dups     # no duplicate
setopt hist_save_no_dups	# save no duplicate
setopt hist_allow_clobber	# overwrites no_clobber
unsetopt hist_ignore_space      # ignore space prefixed commands
setopt hist_reduce_blanks       # trim blanks
setopt hist_verify              # show before executing history commands
setopt inc_append_history       # add commands as they are typed, don't wait until shell exit 
setopt share_history            # share hist between sessions
setopt no_hist_beep		# no beep
setopt bang_hist     

if [[ -s "${HOME}/.zsh_plugins.sh" ]]; then
  source "${HOME}/.zsh_plugins.sh"
fi

bindkey "$terminfo[kcuu1]" history-substring-search-up
bindkey "$terminfo[kcud1]" history-substring-search-down