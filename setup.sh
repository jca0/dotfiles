#!/bin/bash

cd "$(dirname "$0")"
stow --ignore='\.DS_Store' nvim ghostty tmux zsh terminator bash
