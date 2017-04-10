_cloudfuzzer()
{
    local cur prev opts
    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"
    opts="setup-swarm run-containers distribute-docker-image get-results get-stats ssh-to-master help"


    if [[ ${cur} == * ]] ; then
        COMPREPLY=( $(compgen -W "${opts}" ${cur}) )
        return 0
    fi
}
complete -F _cloudfuzzer cloudfuzzer
