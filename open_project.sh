#!/bin/env bash
source ~/.nurc
export PATH=$PATH:~/.cabal/bin:~/.local/bin
termite -e "bash -c \"cd $NU_HOME/$1; lein nu-test :postman :autotest; exec bash\"" &
termite -e "bash -c 'cd $NU_HOME/$1; lein nu-test :test :autotest; exec bash'" &
termite -e "bash -c 'cd $NU_HOME/$1; git branch; exec bash'" &
