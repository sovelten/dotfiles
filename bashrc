#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
PS1='[\u@\h \W]\$ '
PATH="${PATH}:/home/eric/.cabal/bin:/usr/lib/smlnj/bin"
export PYTHONPATH=$PYTHONPATH:/home/eric/Dropbox/IC/scikit-learn
export EDITOR="vim"
