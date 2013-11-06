# Bash autocompletion for Easybuild

Easybuild is a collaborative framework for automating the installation of scientfic software. This is a script to enhance Easybuild with auto-completion abilities. 

### Demo

![demo.gif](demo.gif "A simpe demo of the bash completion script for eb")

### Installation

To test it, just download the `eb_completion` script and source it. To install it permanently, copy it in your `/etc/bash_completion.d` directory or source it in your shell startup file (e.g.: `.bashrc`).

### Known issues

This version is just a proof of concept ; it will only autocomplete on easyconfigs and on long options.
