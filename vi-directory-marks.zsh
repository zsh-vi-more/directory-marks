(){
	emulate -L zsh

	typeset -gA dir_marks
	[[ -r ${VI_DIR_MARKS__CACHE_FILE:="${XDG_CACHE_HOME:-$HOME/.cache}/vi-dir-marks.cache.zsh"} ]] &&
		source $VI_DIR_MARKS__CACHE_FILE

	autoload add-zsh-hook
	zmodload zsh/datetime
	zmodload zsh/sched
	zmodload zsh/system
	add-zsh-hook zshexit vi-dir-marks::sync

	zle -N mark-dir vi-dir-marks::mark
	zle -N jump-dir vi-dir-marks::jump
	zle -N marks    vi-dir-marks::list

	bindkey -M vicmd 'm' mark-dir "'" jump-dir '`' jump-dir
}

function vi-dir-marks::mark(){
	emulate -L zsh

	local REPLY
	[[ -n ${REPLY:=$1} ]] || read -k1
	if (($+WIDGET)) && zle .vi-set-mark <<< $REPLY; then
		return
	fi
	dir_marks[$REPLY]=${${2:a}:-$PWD}
	# schedule cache writeout
	if [[ $REPLY = [[:upper:]] && ! ${(M)zsh_scheduled_events:#*vi-dir-marks::sync} ]]; then
		sched +${VI_DIR_MARkS__SYNC_SECONDS:=30} vi-dir-marks::sync
	fi
}

function vi-dir-marks::jump(){
	emulate -L zsh

	local REPLY
	[[ -n ${REPLY:=${1[1]}} ]] || read -k1
	if [[ -v WIDGET && $KEYS = '`' ]] && zle .vi-goto-mark <<< $REPLY; then
		return
	elif [[ -v WIDGET && $KEYS = "'" ]] && zle .vi-goto-mark-line <<< $REPLY; then
		return
	fi
	if [[ -n $dir_marks[$REPLY] ]] && cd ${dir_marks[$REPLY]#*:} &>/dev/null; then
		for f (chpwd $chpwd_functions precmd $precmd_functions)
			(($+functions[$f])) && $f &>/dev/null
		zle .reset-prompt
		zle -R
	fi
}

function vi-dir-marks::sync(){
	emulate -L zsh
	local -i fd
	if [[ ! $1 = noflock ]] && zsystem supports flock; then
		zsystem flock -f fd $VI_DIR_MARKS__CACHE_FILE
		($funcstack[1] noflock)
		zsystem flock -u $fd
		return
	fi
	local -A old=(${(kv)dir_marks})
	source $VI_DIR_MARKS__CACHE_FILE
	local k v changed
	# overwrite new global marks
	dir_marks+=("${(@kv)old[(I)[[:upper:]]]}")
	# write out new global marks
	typeset -p dir_marks >| $VI_DIR_MARKS__CACHE_FILE
	zcompile $VI_DIR_MARKS__CACHE_FILE
	# join local marks
	dir_marks+=("${(@kv)old[(I)^[[:upper:]]]}")
}

function vi-dir-marks::list(){
	emulate -L zsh
	# TODO: find a better solution than | column | column
	printf '%s: %q\n' ${(kv)dir_marks#?*:}|
		column -c$COLUMNS |
		column -t
	if (($+WIDGET)); then
		zle .reset-prompt
		zle -R
	fi
}
