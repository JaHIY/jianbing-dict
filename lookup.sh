#!/bin/sh -

BASE_URL='jianbing.org'

char() {
    while IFS='' read -r line
    do
        case "$line" in
            \\[[:digit:]][[:digit:]][[:digit:]]*)
                printf '%b' $(awk 'BEGIN{FS="\\"}{for(i=2;i<=NF;i++){printf "\\x%x", $i}}' <<< "$line")
                ;;
            *)
                printf '%s' "$line"
                ;;
        esac
    done
}

main() {
    while [ $# -gt 0 ]
    do
        printf '%s\n' "$1"
        dig "${1}.${BASE_URL}" txt +short +tcp | sed -e 's/^"//' -e 's/"$/\\010/' | \
            grep -o '\(\\[[:digit:]]\{3\}\)\{1,\}\|.' | char
    #grep -Po '\\[[:digit:]]{3}+|.+?(?=\\[[:digit:]]{3})|.+' is greater but less compatibility
        printf '\n'
        shift
    done
    return 0
}

main "$@"
