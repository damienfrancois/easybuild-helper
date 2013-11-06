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

function _list_easyblocks() {
echo $(eb --robot $robotpath --quiet --search .eb | grep "^== -" | rev | cut -d/ -f1 | rev) 
}

short_eb_options="-h -H -d -f -l -b -r -k -s -C -a -e -p -t "
long_eb_options="
  --version    
  --shorthelp  
  --help       
  --debug      
  --info       
  --quiet      
  --configfiles
  --ignoreconfigfiles
  --force
  --job     
  --logtostdout
  --only-blocks
  --robot
  --skip
  --stop
  --strict
  --avail-repositories
  --buildpath
  --config
  --installpath
  --logfile-format
  --moduleclasses
  --prefix
  --repository
  --repositorypath
  --show-default-moduleclasses
  --sourcepath
  --subdir-modules
  --subdir-software
  --testoutput
  --tmp-logdir
  --avail-easyconfig-constants
  --avail-easyconfig-licenses
  --avail-easyconfig-params
  --avail-easyconfig-templates
  --dep-graph
  --list-easyblocks
  --list-toolchains 
  --search
  --easyblock
  --pretend       
  --skip-test-cases
  --aggregate-regtest
  --regtest         
  --regtest-online  
  --regtest-output-dir
  --sequential     
  --amend
  --software-name
  --software-version
  --toolchain
  --toolchain-name
  --toolchain-version
  --try-amend
  --try-software-name
  --try-software-version
  --try-toolchain
  --try-toolchain-name
  --try-toolchain-version
  --unittest-file
  "

_eb()
{
    _get_comp_words_by_ref cur prev words cword
    _split_long_opt

    for i in "${!words[@]}" ; do
        [[ ${words[$i]} == -r  && ${words[$((i+1))]} != -*  ]] && robotpath="${words[$((i+1))]}"
        [[ ${words[$i]} == --robot  && ${words[$((i+1))]} != -*  ]] && robotpath="${words[$((i+1))]}"
        [[ ${words[$i]} == --robot  && ${words[$((i+1))]} == =  ]] && robotpath="${words[$((i+2))]}"
    done
   
    [[ $cur == - ]] && { offer "$short_eb_options" ; return ; }
    [[ $cur == --* ]] && { offer "$long_eb_options" ; return ; }

    case $prev in 
    --robot) _filedir ;;
    *)  COMPREPLY=( $( compgen -W "$(_list_easyblocks)" -- $cur ) ) ;  ;;
    esac
    unset robotpath
}
complete -F _eb eb

# vim: sw=4:ts=4:expandtab
