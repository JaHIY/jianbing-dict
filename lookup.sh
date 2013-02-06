#!/bin/sh -

char() {
    local ascii_oct_code
    while IFS='' read -r line
    do
        case "$line" in
            \\[[:digit:]][[:digit:]][[:digit:]])
                ascii_oct_code=$(cut -c '2-4' <<< "$line")
                printf $(bc <<< "obase=16;${ascii_oct_code}" | sed 's/^.*$/\\x&/')
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
        dig "$1.jianbing.org" txt +short +tcp | sed -e 's/^"\(.*\)"$/\1\\010/g' | \
            grep -o '\\[[:digit:]]\{3\}\|.' | char
        printf '\n'
        shift
    done
}

main "$@"
