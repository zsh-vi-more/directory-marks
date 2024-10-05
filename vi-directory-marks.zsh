(){
	emulate -L zsh

	: ${VI_DIR_MARKS__CACHE_FILE:="${XDG_CACHE_HOME:-$HOME/.cache}/vi-dir-marks.cache.zsh"}

	autoload add-zsh-hook
	zmodload zsh/datetime
	zmodload zsh/sched
	zmodload zsh/system

	zle -N mark-dir vi-dir-marks::mark
	zle -N jump-dir vi-dir-marks::jump
	zle -N marks    vi-dir-marks::list

	bindkey -M vicmd 'm' mark-dir "'" jump-dir '`' jump-dir
}

function vi-dir-marks::mark(){
	emulate -L zsh
	local REPLY
	[[ -n ${REPLY:=$1} ]] || read -k1
	local -A dir_marks
	dir_marks[$REPLY]=${${2:a}:-$PWD}
	# schedule cache writeout
	typeset -p dir_marks >| $VI_DIR_MARKS__CACHE_FILE
}

function vi-dir-marks::jump(){
	emulate -L zsh
	local -i fd
	local -A dir_marks
	. $VI_DIR_MARKS__CACHE_FILE

	local REPLY
	[[ -n ${REPLY:=${1[1]}} ]] || read -k1
	# if [[ -v WIDGET && $KEYS = '`' ]] && zle .vi-goto-mark <<< $REPLY; then
	# 	return
	# elif [[ -v WIDGET && $KEYS = "'" ]] && zle .vi-goto-mark-line <<< $REPLY; then
	# 	return
	# fi

	# we have to manually run chpwd/precmd functions and reset the prompt
	if [[ -n $dir_marks[$REPLY] ]] && cd ${dir_marks[$REPLY]#*:} &>/dev/null; then
		for f (chpwd $chpwd_functions precmd $precmd_functions)
			(($+functions[$f])) && $f &>/dev/null
		zle .reset-prompt
		zle -R
	fi
}

function vi-dir-marks::list(){
	emulate -L zsh
	# TODO: find a better solution than | column | column
	local -A dir_marks
	. $VI_DIR_MARKS__CACHE_FILE
	print -raC2 "${(@kvq+)dir_marks}"
	if (($+WIDGET)); then
		zle .reset-prompt
		zle -R
	fi
}
