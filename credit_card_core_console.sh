#!/bin/env bash
source ~/.nurc
export PATH=$PATH:~/.cabal/bin:~/.local/bin
termite -e "bash -c 'cd $NU_HOME/playbooks/squads/credit-card-core/bin; ./console.sh $1; exec bash'" &
