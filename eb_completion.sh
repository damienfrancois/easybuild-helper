# Author: Damien François <damien.francois@uclouvain.be>
# Status: Proof of concept
# Version: 0.1
# Copyright 2013 Damien François


function compute_set_diff(){
    res=""
    for i in $1; do
        [[ "$2" =~ ${i%%=*} ]] && continue 
        res="$i $res"
    done
    echo $res 
}

_split_long_opt() {
    [[ $cur == = || $cur == : ]] && cur=""
    [[ $prev == = ]] && prev=${COMP_WORDS[$cword-2]}
}

function offer (){
    remainings=$(compute_set_diff "$1" "${COMP_WORDS[*]}")
    COMPREPLY=( $( compgen -W "$remainings" -- $cur ) ) 
    if [[ "$1" == *=* || "$1" == *%* || "$1" == *:* ]];
    then
        compopt -o nospace
    fi
}

function _list_longoptions() {
echo $(eb --help | grep -o -- '^ \{4\}--[a-z-]*\w')
}
function _list_shortoptions() {
echo $(eb --help | grep -w -o -- "-[a-z]")
}
function _list_easyblocks() {
echo $(eb --robot $robotpath --quiet --search .eb | grep "^== -" | rev | cut -d/ -f1 | rev) 
}


_eb()
{
    _get_comp_words_by_ref cur prev words cword
    _split_long_opt

    for i in "${!words[@]}" ; do
        [[ ${words[$i]} == -r  && ${words[$((i+1))]} != -*  ]] && robotpath="${words[$((i+1))]}"
        [[ ${words[$i]} == --robot  && ${words[$((i+1))]} != -*  ]] && robotpath="${words[$((i+1))]}"
        [[ ${words[$i]} == --robot  && ${words[$((i+1))]} == =  ]] && robotpath="${words[$((i+2))]}"
    done
   
    [[ $cur == - ]] && { offer "$(_list_shortoptions)" ; return ; }
    [[ $cur == --* ]] && { offer "$(_list_longoptions)" ; return ; }

    case $prev in 
    --robot) _filedir ;;
    *)  COMPREPLY=( $( compgen -W "$(_list_easyblocks)" -- $cur ) ) ;  ;;
    esac
    unset robotpath
}
complete -F _eb eb

# vim: sw=4:ts=4:expandtab
