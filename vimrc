if has("gui_macvim")
	set macmeta
	set go-=T	"hide toolbar
	set guifont=Monaco:h13
	:colorscheme torte
	"set showtabline=2
endif

syntax on

set nocp
set transparency=10

set ruler
set nu
set nowrap

set cindent
set autoindent
set smarttab
set smartindent

set showmode
set showcmd
set cursorline

set shiftwidth=4
set softtabstop=4
set tabstop=4
set mouse=a

filetype on
filetype plugin on

" <errormarker.vim>
let &errorformat="%f:%l:%c: %t%*[^:]:%m,%f:%l: %t%*[^:]:%m," . &errorformat 

" <nerdtree>
let NERDTreeChDirMode=2

" <omnicppcomplete>
set tags+=~/.vim/tags/cpp
let OmniCpp_NamespaceSearch = 1
let OmniCpp_GlobalScopeSearch = 1
let OmniCpp_ShowAccess = 1
let OmniCpp_ShowPrototypeInAbbr = 1 " show function parameters
let OmniCpp_MayCompleteDot = 1 " autocomplete after .
let OmniCpp_MayCompleteArrow = 1 " autocomplete after ->
let OmniCpp_MayCompleteScope = 1 " autocomplete after ::
let OmniCpp_DefaultNamespaces   = ["std", "_GLIBCXX_STD"]
set completeopt=menuone,longest,preview
au CursorMovedI,InsertLeave * if pumvisible() == 0|silent! pclose|endif
au BufWritePost *.c,*.cpp,*.h silent! !ctags * --c++-kinds=+p --fields=+iaS --extra=+q --language-force=C++

" <minibufexpl>
let g:miniBufExplMapWindowNavVim = 1
let g:miniBufExplMapWindowNavArrows = 1
let g:miniBufExplMapCTabSwitchBufs = 1
let g:miniBufExplModSelTarget = 1 

" <layout>
autocmd VimEnter * winp 0 0
autocmd VimEnter * win 156 100
autocmd VimEnter * NERDTree
autocmd VimEnter * vertical resize -10

autocmd TabEnter * NERDTree
autocmd TabEnter * vertical resize -10

" <mapping>
no <F3> :call NTree()<cr>
no <F4> :call Qfix()<cr>
no <F5> :wall<cr>:call Compile_project()<cr>
no <F6> :wall<cr>:call Project_run()<cr>

no <M-m> :w!<cr>:call Compile_one_file()<cr>
no <C-m> :w!<cr>:call Compile_and_run()<cr>

no <F7> :wall<cr>:call Makefile()<cr>

no <enter> :w!<cr>:call OpenHTML()<cr>

no <leader>r :call ReplaceAll("<c-r>=expand("<cword>")<cr>", "")

" <open html file>
function! OpenHTML()
	if &filetype == "html" || &filetype == "xhtml" || &filetype == "htm"
		:silent !open %
	endif
endfunction

" <makefile>
function! Makefile()
	set makeprg=make
	:make
endfunction

" <compile>
function! Compile_project()
	if &filetype == "cpp"
		set makeprg=g++\ -Wall\ -c\ *.cpp
	elseif &filetype == "c"
		set makeprg=gcc\ -Wall\ -c\ *.c
	endif
	:make
	if &filetype == "cpp"
		:!g++ -o main *.o
	elseif &filetype == "c"
		:!gcc -o main *.o
	endif
	set makeprg=make
endfunction

function! Project_run()
	call Compile_project()
	:!./main
endfunction

function! Compile_one_file()
	if &filetype == "cpp"
		set makeprg=g++\ -Wall\ -o\ %:r\ %
	elseif &filetype == "c"
		set makeprg=gcc\ -Wall\ -o\ %:r\ %
	endif
	:make
	set makeprg=make
endfunction
	
function! Compile_and_run()
	call Compile_one_file()
	:!./%:r
endfunction

" <toggle Qfix>
function! Qfix()
	if exists("g:qfix_win")
		cclose
		unlet g:qfix_win
	else
		copen 6
		let g:qfix_win = bufnr("$")
	endif
endfunction

" <toggle NTree>
function! NTree()
	if exists("g:ntree_win")
		NERDTree
		vertical resize -10
		unlet g:ntree_win
	else
		NERDTreeClose
		let g:ntree_win = 1
	endif
endfunction

" <for ease the replacing pain>
function! ReplaceAll(cword, newvar)
	let cw = a:cword
	let nw = a:newvar
	let replace = "%s/\\<"
	let replace .= expand(cw)
	let replace .= "\\>/"
	let replace .= expand(nw)
	let replace .= "/g"
	exec replace
endfunction
