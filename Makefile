PATHOGEN=	dotfiles-install-pathogen
SOLARIZED=	dotfiles-install-solarized

all:
	@echo 'usage: make [tune-vim|clean-vim]'

tune-vim: install-pathogen install-solarized

clean-vim: uninstall-pathogen

install-pathogen: check-curl
	mkdir -p ~/.vim/autoload ~/.vim/bundle && curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim
	@echo 'editing ~/.vimrc (pathogen) ...'
	@{ echo '" ${PATHOGEN}'; echo '" WARNING: 3 following lines to be removed automatically'; echo 'execute pathogen#infect()'; echo 'syntax on'; echo 'filetype plugin indent on'; } >> ~/.vimrc

check-curl:
	@command -V curl 2>&1 >/dev/null || { echo >&2 "curl not found"; exit 1; }
	
uninstall-pathogen: uninstall-solarized
	rm -rf ~/.vim/autoload ~/.vim/bundle
	@echo 'editing ~/.vimrc (pathogen) ...'
	@sed -i '/^" ${PATHOGEN}$$/,+4d' ~/.vimrc

install-solarized: check-git
	(cd ~/.vim/bundle; git clone git://github.com/altercation/vim-colors-solarized.git)
	@echo 'editing ~/.vimrc (solarized) ...'
	@{ echo '" ${SOLARIZED}'; echo '" WARNING: 3 following lines to be removed automatically'; echo 'syntax enable'; echo 'set background=dark'; echo 'colorscheme solarized'; } >> ~/.vimrc

uninstall-solarized:
	rm -rf ~/.vim/bundle/vim-colors-solarized
	@echo 'editing ~/.vimrc (solarized) ...'
	@sed -i '/^" ${SOLARIZED}$$/,+4d' ~/.vimrc

check-git:
	@command -V git 2>&1 >/dev/null || { echo >&2 "git not found"; exit 1; }
