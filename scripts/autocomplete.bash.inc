_cloudfuzzer()
{
    local cur prev opts
    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"
    opts="create-keys send-docker-data bastion ssh get-results get-stats help"


    if [[ ${cur} == * ]] ; then
        COMPREPLY=( $(compgen -W "${opts}" ${cur}) )
        return 0
    fi
}
complete -F _cloudfuzzer cloudfuzzer
