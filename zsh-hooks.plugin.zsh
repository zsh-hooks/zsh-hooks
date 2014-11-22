# Add to HOOK the given FUNCTION.
#
# With -d, remove the function from the hook instead; delete the hook
# variable if it is empty.
#
# -D behaves like -d, but pattern characters are active in the
# function name, so any matching function will be deleted from the hook.
#
# Without -d, the FUNCTION is marked for autoload; -U is passed down to
# autoload if that is given, as are -z and -k.  (This is harmless if the
# function is actually defined inline.)


hooks-add-hook(){

  emulate -L zsh

  local opt
  local -a autoopts
  integer del list help

  while getopts "dDhLUzk" opt; do
    case $opt in
      (d)
      del=1
      ;;

      (D)
      del=2
      ;;

      (h)
      help=1
      ;;

      (L)
      list=1
      ;;

      ([Uzk])
      autoopts+=(-$opt)
      ;;

      (*)
      return 1
      ;;
    esac
  done
  shift $(( OPTIND - 1 ))

  if (( list )); then
    if [[ -z "$1" ]]; then
      echo 'what hook do you want listed?' 2>&1
      return 1
    fi
    typeset -mp $@
    return $?
  elif (( help || $# != 2 )); then
    print -u$(( 2 - help )) $usage
    return $(( 1 - help ))
  fi

  local hook="${1}"
  local fn="$2"

  if (( del )); then
    # delete, if hook is set
    if (( ${(P)+hook} )); then
      if (( del == 2 )); then
        set -A $hook ${(P)hook:#${~fn}}
      else
        set -A $hook ${(P)hook:#$fn}
      fi
      # unset if no remaining entries --- this can give better
      # performance in some cases
      if (( ! ${(P)#hook} )); then
        unset $hook
      fi
    fi
  else
    if (( ${(P)+hook} )); then
      if (( ${${(P)hook}[(I)$fn]} == 0 )); then
        set -A $hook ${(P)hook} $fn
      fi
    else
      set -A $hook $fn
    fi
    autoload $autoopts -- $fn
  fi

}

hooks-run-hook(){
  for f in "${(P)1}"; do
    $f
  done
}

hooks-define-hook(){
  typeset -ag "$1"
}

hooks-define-hook zle_line_init_hook
zle-line-init(){
  ZSH_CUR_KEYMAP=$KEYMAP
  hooks-run-hook zle_line_init_hook
}
zle -N zle-line-init

hooks-define-hook zle_keymap_select_hook
zle-keymap-select(){
  ZSH_CUR_KEYMAP=$KEYMAP
  hooks-run-hook zle_keymap_select_hook
}
zle -N zle-keymap-select
