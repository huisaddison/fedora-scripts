" An example for a vimrc file.
"
" Maintainer:   Addison Hu <huisaddison@gmail.com>
" Originator:	Bram Moolenaar <Bram@vim.org>
" Last change:	2016 Feb 26
"
" To use it, copy it to
"     for Unix and OS/2:  ~/.vimrc
"	      for Amiga:  s:.vimrc
"  for MS-DOS and Win32:  $VIM\_vimrc
"	    for OpenVMS:  sys$login:.vimrc

" When started as "evim", evim.vim will already have done these settings.
if v:progname =~? "evim"
  finish
endif

" Use Vim settings, rather than Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

if has("vms")
  set nobackup		" do not keep a backup file, use versions instead
else
  set backup		" keep a backup file (restore to previous version)
  set undofile		" keep an undo file (undo changes after closing)
endif
set history=50		" keep 50 lines of command line history
set ruler		" show the cursor position all the time
set showcmd		" display incomplete commands
set incsearch		" do incremental searching

" For Win32 GUI: remove 't' flag from 'guioptions': no tearoff menu entries
" let &guioptions = substitute(&guioptions, "t", "", "g")

" Don't use Ex mode, use Q for formatting
map Q gq

" use - for deleting word to reduce strain on middle finger
map - daw

" CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo,
" so that you can undo CTRL-U after inserting a line break.
inoremap <C-U> <C-G>u<C-U>

" In many terminal emulators the mouse works just fine, thus enable it.
if has('mouse')
  set mouse=a
endif

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
  syntax on
  set hlsearch
endif

" Only do this part when compiled with support for autocommands.
if has("autocmd")

  " Enable file type detection.
  " Use the default filetype settings, so that mail gets 'tw' set to 72,
  " 'cindent' is on in C files, etc.
  " Also load indent files, to automatically do language-dependent indenting.
  filetype plugin indent on

  " Put these in an autocmd group, so that we can delete them easily.
  augroup vimrcEx
  au!

  " For all text files set 'textwidth' to 78 characters.
  autocmd FileType text setlocal textwidth=78

  " When editing a file, always jump to the last known cursor position.
  " Don't do it when the position is invalid or when inside an event handler
  " (happens when dropping a file on gvim).
  " Also don't do it when the mark is in the first line, that is the default
  " position when opening a file.
  autocmd BufReadPost *
    \ if line("'\"") > 1 && line("'\"") <= line("$") |
    \   exe "normal! g`\"" |
    \ endif

  augroup END

else

  set autoindent		" always set autoindenting on

endif " has("autocmd")

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r ++edit # | 0d_ | diffthis
		  \ | wincmd p | diffthis
endif

if has('langmap') && exists('+langnoremap')
  " Prevent that the langmap option applies to characters that result from a
  " mapping.  If unset (default), this may break plugins (but it's backward
  " compatible).
  set langnoremap
endif

" Pathogen for easy plugin and runtime file management
execute pathogen#infect() 

" Install vimwiki; depends on Pathogen
let g:vimwiki_list = [{
    \ 'path': '$HOME/Dropbox/wiki',
    \ 'template_path': '$HOME/Dropbox/wiki/templates',
    \ 'template_default': 'default',
    \ 'template_ext': '.html'}]
  
let tabsize = 2

" Set TAB width
execute "set tabstop=".tabsize
" Set indent width
execute "set shiftwidth=".tabsize
" Set number of columns for a TAB
execute "set softtabstop=".tabsize
set expandtab     " Expand TABs to spaces

" Install powerline, a pretty and useful status bar!
python from powerline.vim import setup as powerline_setup
python powerline_setup()
python del powerline_setup
set laststatus=2
set t_Co=256


" Ensure that vim is started with dark background for base16
set background=dark

" Select the color scheme
colorscheme base16-ocean

" Ensure that the background is transparent
highlight Normal ctermbg=none
highlight NonText ctermbg=none
highlight MatchParen cterm=none ctermbg=gray ctermfg=white
highlight LineNr term=bold cterm=NONE ctermfg=white  ctermbg=blue gui=NONE guifg=DarkGrey guibg=NONE
highlight ColorColumn ctermbg=lightgrey guibg=lightgrey
