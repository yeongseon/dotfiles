#!/usr/bin/env bash

mkdir -p /home/khuntly/.log/archive;
mkdir -p /home/khuntly/.ssh/;
mkdir -p /home/khuntly/.gnupg/;
mkdir -p /home/khuntly/.config/git;
mkdir -p /home/khuntly/.etc;

ln -s /home/khuntly/.dotfiles/inputrc /home/khuntly/.inputrc;
ln -s /home/khuntly/.dotfiles/my.cnf /home/khuntly/.my.cnf;
ln -s /home/khuntly/.dotfiles/xlaunch /home/khuntly/.xlaunch;
ln -s /home/khuntly/.dotfiles/screenrc /home/khuntly/.screenrc;
ln -s /home/khuntly/.dotfiles/vimrc /home/khuntly/.vimrc;
ln -s /home/khuntly/.dotfiles/wgetrc /home/khuntly/.wgetrc;
ln -s /home/khuntly/.dotfiles/mailrc /home/khuntly/.mailrc;
ln -s /home/khuntly/.dotfiles/digrc /home/khuntly/.digrc;
ln -s /home/khuntly/.dotfiles/profile /home/khuntly/.profile;
ln -s /home/khuntly/.dotfiles/kshrc /home/khuntly/.kshrc;
ln -s /home/khuntly/.dotfiles/alias /home/khuntly/.alias;
ln -s /home/khuntly/.dotfiles/functions /home/khuntly/.functions;
ln -s /home/khuntly/.dotfiles/bashrc /home/khuntly/.bashrc;
ln -s /home/khuntly/.dotfiles/bash_profile /home/khuntly/.bash_profile;
ln -s /home/khuntly/.dotfiles/tmux.conf /home/khuntly/.tmux.conf;
ln -s /home/khuntly/.dotfiles/bin/ /home/khuntly/.bin;
ln -s /home/khuntly/.dotfiles/functions.d/ /home/khuntly/.functions.d;
ln -s /home/khuntly/.dotfiles/gnupg/gpg.conf /home/khuntly/.gnupg/gpg.conf;
ln -s /home/khuntly/.dotfiles/gnupg/gpg-agent.conf /home/khuntly/.gnupg/gpg-agent.conf;
ln -s /home/khuntly/.dotfiles/ssh/config.d /home/khuntly/.ssh/config.d;
ln -s /home/khuntly/.dotfiles/lib/ /home/khuntly/.lib;
ln -s /home/khuntly/.dotfiles/etc/SecurityService /home/khuntly/.etc/SecurityService;
ln -s /home/khuntly/.dotfiles/etc/eSolutionsCore /home/khuntly/.etc/eSolutionsCore;
ln -s /home/khuntly/.dotfiles/etc/templates /home/khuntly/.etc/templates;
ln -s /home/khuntly/.dotfiles/etc/resources /home/khuntly/.etc/resources;
ln -s /home/khuntly/.dotfiles/etc/ansible /home/khuntly/.etc/ansible;
ln -s /home/khuntly/.dotfiles/etc/mail.properties /home/khuntly/.etc/mail.properties;
ln -s /home/khuntly/.dotfiles/etc/logging.properties /home/khuntly/.etc/logging.properties;
ln -s /home/khuntly/.dotfiles/etc/excludes /home/khuntly/.etc/excludes;
ln -s /home/khuntly/.dotfiles/alias.d/ /home/khuntly/.alias.d;
ln -s /home/khuntly/.dotfiles/gitconfig /home/khuntly/.gitconfig;
ln -s /home/khuntly/.dotfiles/profile.d/ /home/khuntly/.profile.d;
ln -s /home/khuntly/.dotfiles/curlrc /home/khuntly/.curlrc;
ln -s /home/khuntly/.dotfiles/subversion/ /home/khuntly/.subversion;
ln -s /home/khuntly/.dotfiles/colordiffrc /home/khuntly/.colordiffrc;
ln -s /home/khuntly/.dotfiles/pythonrc /home/khuntly/.pythonrc;
ln -s /home/khuntly/.dotfiles/config/git/gitignore /home/khuntly/.config/git/gitignore;

