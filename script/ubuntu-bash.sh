#! /bin/sh
GITHUB=$1
FOLDER=~/.oh-my-bash
BASHRC=~/.bashrc
VIMRC=~/.vimrc

# Check if a username exist
if [ -z $GITHUB ]; then
	echo "Requires your github account username"
	exit 1
fi

# Vim
if ! command -v vim >/dev/null 2>&1; then
	sudo apt update && sudo apt install vim
	echo "vim is now installed"
fi
if [ ! -e $VIMRC ]; then
	echo 'set number' > $VIMRC
	echo 'set tabstop=4' >> $VIMRC
fi

# Git
if ! command -v git >/dev/null 2>&1; then
	sudo add-apt-repository ppa:git-core/ppa
	sudo apt update; sudo apt-get install git
	echo "git is now installed"
fi
git config --global user.name $GITHUB
git config --global user.email $GITHUB@gmail.com
git config --global init.defaultBranch main
git config --global credential.helper store
git config --global core.editor vim
git config --global core.pager cat

# Bash
if [ ! -d $FOLDER ]; then
	git clone https://github.com/brianlewyn/fork_oh-my-bash.git $FOLDER
	cd $FOLDER/themes/
	mv rr ./../ && rm -rf * && mv ./../rr .
	sed -i '27s/\(\${.*} \) \(\${.*} \)\$/\2\1$/' rr/rr.theme.sh
	sed -i '36s/}/  PS1+="\\n$ "\n}/' rr/rr.theme.sh
	cp $FOLDER/templates/bashrc.osh-template $BASHRC
	sed -i '12s/font/rr/' $BASHRC
fi

# script done
echo "script done! now run 'source ~/.bashrc'"
