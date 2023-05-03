#! /bin/sh
MASHINE=$1
GITHUB=$2
FOLDER=~/.oh-my-bash
BASHRC=~/.bashrc
VIMRC=~/.vimrc

# Check if a username exist
if [ -z $MASHINE ]; then
	MASHINE="unknow"
	echo "Run with default username 'unknown'"
fi
if [ -z $GITHUB ]; then
	GITHUB=$MASHINE
fi

# Vim
if ! command -v vim >/dev/null 2>&1; then
	apk add --no-cache vim
	echo "vim is now installed"
fi
if [ ! -e $VIMRC ]; then
	echo 'set number' > $VIMRC
	echo 'set tabstop=4' >> $VIMRC
fi

# Git
if ! command -v git >/dev/null 2>&1; then
	apk add --no-cache git
	echo "git is now installed"
fi
git config --global user.name $GITHUB
git config --global user.email $GITHUB@gmail.com
git config --global init.defaultBranch main
git config --global credential.helper store
git config --global core.editor vim
git config --global core.pager cat

# Bash
if ! command -v bash >/dev/null 2>&1; then
	apk add --no-cache bash
	echo "bash is now installed"
fi
if [ ! -d $FOLDER ]; then
	git clone https://github.com/brianlewyn/fork_oh-my-bash.git $FOLDER
	cd $FOLDER/themes/
	mv rr ./../ && rm -rf * && mv ./../rr .
	sed -i '27s/\(\${.*} \) \(\${.*} \)\$/\2\1$/' rr/rr.theme.sh
	sed -i '36s/}/  PS1+="\\n$ "\n}/' rr/rr.theme.sh
	cp $FOLDER/templates/bashrc.osh-template $BASHRC
	sed -i '12s/font/rr/' $BASHRC
fi
sed -i "18s/}.*\${/}$MASHINE\${/" $FOLDER/themes/rr/rr.theme.sh

# script done
echo "script done! now run 'source ~/.bashrc'"
