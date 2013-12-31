#!/bin/zsh

DOTFILES_ROOT="$(pwd)"
PLATFORM="$(uname)"
SERVER_APPS_PATH="/srv/apps"
SERVER_VENV_PATH="/srv/virtualenvs"
OSX_TMUX_CHANGES='

# clipboard
set-option -g default-command "reattach-to-user-namespace -l zsh" # or bash...
bind C-c run "tmux save-buffer - | reattach-to-user-namespace pbcopy"
bind C-v run "reattach-to-user-namespace pbpaste | tmux load-buffer - && tmux paste-buffer"
'

# deleting existing files first
rm -rf $HOME/.bin/arch-packages-news.py &> /dev/null
rm -rf $HOME/.bin/genpwd &> /dev/null
rm -rf $HOME/.zshrc &> /dev/null
rm -rf $HOME/.ssh/authorized_keys &> /dev/null
rm -rf $HOME/.gitconfig &> /dev/null
rm -rf $HOME/.oh-my-zsh &> /dev/null
rm -rf $HOME/.vim* &> /dev/null
rm -rf $HOME/.isort.cfg &> /dev/null
rm -rf $HOME/.pythonrc &> /dev/null
rm -rf $HOME/.tmux.conf &> /dev/null

# resetting changes to these files
git checkout .

# initializing submodules
git submodule init
git submodule update

# installing scripts
mkdir -p $HOME/.bin
ln -sf $DOTFILES_ROOT/scripts/arch-packages-news.py $HOME/.bin/arch-packages-news.py
ln -sf $DOTFILES_ROOT/scripts/generate-password.py $HOME/.bin/genpwd

# zsh
ln -sf $DOTFILES_ROOT/settings/zshrc $HOME/.zshrc

# ssh
ln -sf $DOTFILES_ROOT/settings/ssh/authorized_keys $HOME/.ssh/authorized_keys

# git
ln -sf $DOTFILES_ROOT/settings/gitconfig $HOME/.gitconfig

# oh-my-zsh
ln -sf $DOTFILES_ROOT/settings/oh-my-zsh $HOME/.oh-my-zsh

# vim
ln -sf $DOTFILES_ROOT/settings/vim $HOME/.vim
ln -sf $DOTFILES_ROOT/settings/vimrc $HOME/.vimrc

# others
ln -sf $DOTFILES_ROOT/settings/isort.cfg $HOME/.isort.cfg
ln -sf $DOTFILES_ROOT/settings/pythonrc $HOME/.pythonrc
ln -sf $DOTFILES_ROOT/settings/tmux.conf $HOME/.tmux.conf

# server path definition changes
if [[ "$(hostname -s)" != pengu* ]]; then
    sed -i -e 's|$HOME/projects|/srv/apps|g' settings/zshrc
    sed -i -e 's|$HOME/.virtualenvs|/srv/virtualenvs|g' settings/zshrc
fi

# OSX tmux changes
if [[ $PLATFORM == "Darwin" ]]; then
    echo $OSX_TMUX_CHANGES >> $HOME/.tmux.conf
fi

# enabling settings
source $HOME/.zshrc &> /dev/null
