autoload -Uz compaudit compinit
compinit
if [[ -s "${ZDOTDIR}/zsh_plugins.sh" ]]; then
  source "${ZDOTDIR}/zsh_plugins.sh"
fi

if [ -d ${TMUXDIR} ];then
    alias tmux="tmux -f ${TMUXDIR}/.tmux.conf"
fi
