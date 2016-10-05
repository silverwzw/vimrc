"==============================================================================
"                                  PLUGINS
"==============================================================================

set nocompatible                         " required by Vundle
filetype off                             " required by Wundle
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'gmarik/Vundle.vim'
Plugin 'kien/ctrlp.vim'
Plugin 'MovEaxEsp/bdeformat'
Plugin 'wesQ3/vim-windowswap'
Plugin 'Valloric/MatchTagAlways'
Plugin 'dbakker/vim-projectroot'

call vundle#end()
filetype plugin indent on                " required by Vundle

                            " =============== "
                            " Plugin Settings "
                            " =============== "

" let g:ycm_global_ycm_extra_conf = '~/.vim/ycm_extra_conf.py'

let g:ctrlp_follow_symlinks = 1
let g:ctrlp_custom_ignore = {
    \ 'dir': '\.cmake.bld$'
    \ }

"==============================================================================
"                                 FUNCTIONS
"==============================================================================

function ToggleExtension()
    let l:extension = expand("%:e")
    if l:extension ==? "h"
        execute ":e %<.cpp"
    elseif l:extension ==? "cpp"
        execute ":e %<.h"
    elseif l:extension ==? "js"
        execute ":e %<.bml"
    elseif l:extension ==? "bml"
        execute ":e %<.js"
    endif
endfunction

function SetLineNumber()
    if line('$') > 999
        setlocal nonumber relativenumber
    else
        setlocal number norelativenumber
    endif
endfunction

function SetSpellFile()
    try
        let l:cmd = ":setlocal spellfile=" . ProjectRootGuess() . "/.repo-dictionary.utf-8.add"
        execute l:cmd
    catch
    endtry
endfunction

"==============================================================================
"                                 VARIABLES
"==============================================================================

autocmd BufEnter * let b:extension = expand("%:e")
autocmd BufEnter * let b:project_root = ProjectRootGuess()

"==============================================================================
"                                 SETTINGS
"==============================================================================

                              " ================ "
                              " Default Settings "
                              " ================ "

set tabstop=4
set expandtab           "use spaces to replace tab
set autoindent          "automatic indentation
set shiftwidth=4        "this is the level of indent/fold
set ruler               "set to show line number and column number
set number              "set line number
set backspace=indent,eol,start
set visualbell
set colorcolumn=80
set hlsearch            "set search result to be high lighted
set list listchars=trail:·
set foldmethod=manual
set modeline            "enable modeline
set modelines=20        "set modelines to 20 to skip the copyright notice
set spell
set filetype=unix

syntax enable

                            " ==================== "
                            " Conditional Settings "
                            " ==================== "

" set \t not expanded to spaces for Makefile --> Makefile require \t to parse
" (and python)
autocmd FileType make,python autocmd BufEnter <buffer> setlocal noexpandtab

" set textwidth = 79, so textwrapping and gq} will work
autocmd FileType cpp,vim,xsd,python,c,javascript,sh setlocal tw=79
" set tab to be hlighlighted
autocmd FileType cpp,c,javascript setlocal listchars=tab:»·,trail:·

" cmake pattern match
autocmd BufEnter */blt/*.t.cpp,*/libs-vrs/*.t.cpp,*/libs-rav/*.t.cpp,*/rplus/*.t.cpp,*/tdk/*.t.cpp setlocal makeprg=make\ -C\ cmake.bld/Linux/\ %:t:r
autocmd FileType cpp autocmd BufEnter */blt/*,*/libs-rav/*,*/rplus/*,*/tdk/* setlocal makeprg=make\ -C\ cmake.bld/Linux/

" schema make
autocmd FileType xsd autocmd BufEnter <buffer> setlocal makeprg=make\ schema

" remove trailing space on certain filetype
autocmd FileType cpp,c,javascript,python,xml autocmd BufWrite <buffer> silent! %s/\s\+$//g

" set rules for bml
autocmd BufEnter *.bml setlocal ft=xml syntax=xml tabstop=2 shiftwidth=2 expandtab

" no absolute linenumber for file has more than 999 line
" by default apply this line number setting
autocmd BufRead,BufNew * call SetLineNumber()
" line number and colorcolumn make no sense in quick fix buffer
autocmd Filetype qf,gitgrep autocmd BufRead,BufNew <buffer> setlocal nonumber norelativenumber colorcolumn=

" debug settings
" autocmd Filetype * echom "ft set to " &filetype
" autocmd BufEnter * echom "BufEnter to " @%
" autocmd Filetype * autocmd BufEnter <buffer> echom "ft:" &filetype " BufEnter:" @%

                           " ==================== "
                           " Colorscheme Settings "
                           " ==================== "

" Solarized Color Scheme
set t_Co=256
set background=dark
let g:solarized_termcolors=256
let g:solarized_italic=0
colorscheme solarized

" Primary Color Scheme
"set t_Co=256
"set background=light
"colorscheme primary

                              " ============= "
                              " Misc Settings "
                              " ============= "

" Screen not flash on error
" set vb t_vb=""

" High light all WORKING keyword
autocmd BufEnter * match CursorLineNr /\<WORKING\>/

" set project specific dictionary
autocmd BufEnter * call SetSpellFile()

"==============================================================================
"                               KEY MAPPINGS
"==============================================================================

" set mapping leader pattern
let mapleader = ','

                             " =============== "
                             " Helper Mappings "
                             " =============== "

" mark current cursor to cursor location 'z' and copy current identifier to
" register 'z', mark the position of first char of current identifier to
" location 'x', mark the last char to location 'y'
" ,,1 is for purely identifier
" ,,2 also includes the namespace
" ,,3 copy whatever between two while space charactors
nmap ,,1 mz/^\\|[^0-9A-Za-z_]<CR>?[0-9A-Za-z_]<CR>my?$\\|[^0-9A-Za-z_]<CR>/[0-9A-Za-z_]<CR>mxv`y"zy
nmap ,,2 mz/^\\|[^0-9A-Za-z_:]<CR>?[0-9A-Za-z_:]<CR>my?$\\|[^0-9A-Za-z_:]<CR>/[0-9A-Za-z:_]<CR>mxv`y"zy
nmap ,,3 mz/^\\|\s<CR>?\S<CR>my?$\\|\s<CR>/\S<CR>mxv`y"zy

                              " ============= "
                              " Mapping table "
                              " ============= "

"  KEY   SHORT                           DESCRIPTION
" ----- ------- --------------------------------------------------------------
"  ast   a       add ASSERT(...)
"  bbf   f       find a Bloomberg type definition (in XML Schema or C++ header)
"  bnd   b       bind scrolling
"  cpp   p       ctrlp plugin for .
"  cpq   q       ctrlp plugin for ..
"  err   c       open compiler error window at most bottom position
"  ggp   g       do git grep 
"  hic   *       highlight the identifier by cursor, independent to search
"  hii   /       highlight the text (to be input), independent to search
"  inc   i       add include for text under cursor
"  mac   m       add macro continuation ('\') at end of line
"  ope   e       open file specified by text under cursor
"  pst           toggle paste insert mode
"  rtn   r       add comment for `return`, `break` and `continue`
"  tbd   t       add TODO comment block
"  tgd   dt      delete a HTML/XML tag
"  tgy   yt      copy a HTML/XML tag
"  thi   h       toggle header and implementation/bml and js

" * F key mappings not included in this table

                           " =================== "
                           " Mapping Definitions "
                           " =================== "

" add assert
nmap <leader>ast 0wiASSERT(<Esc>A);<Esc>j0
nmap <leader><leader>a <leader>ast

" find definition (C++ class, C++ macro def and xsd type)
" (need silent here in case identifier is too long such that vim has to re-draw
" the screen)
nmap <silent> <leader>bbf ,,1/\(<\(.\+:\)\?\(complex\\|simple\)Type name=['"]\(.\+:\)\?<C-r>z['"]\(\([^>]\\|\n\)\+\)\?>\)\\|\(^class <C-r>z\>\)\\|\(^#define <C-r>z\>\)<CR>
nmap <leader><leader>f <leader>bbf

" bind
nmap <leader>bnd :set scrollbind!<CR>:set cursorbind!<CR>
nmap <leader><leader>b <leader>bnd

" ctrlp plugin
nmap <leader>cpp :CtrlP .<CR>
nmap <leader>cpq :CtrlP ..<CR>
nmap <leader><leader>p <leader>cpp
nmap <leader><leader>q <leader>cpq

" compile error window
nmap <leader>err :bo cw<CR>
nmap <leader><leader>c <leader>err

" open git grep
nmap <leader>ggp :bo new \| setlocal buftype=nofile filetype=gitgrep \| 0read !git grep 
nmap <leader><leader>g <leader>ggp

" hlights
nmap <leader>hic :match ErrorMsg '<C-r><C-w>'<CR>
nmap <leader>hii :match ErrorMsg 
nmap <leader><leader>* <leader>hic
nmap <leader><leader>/ <leader>hii

" add include based on class name
nmap <leader>inc ,,2:1<CR>jjo<ESC>"zpv0:s/\(::\)\\|_/_/g<CR>:nohl<CR>gu$i#include <<ESC>A.h><ESC>`z
nmap <leader><leader>i <leader>inc

" add '\' at 79th col (for C++ macro)
nmap <leader>mac A <ESC>0/\s\+$\\|\s*\\\s\+<CR>Dmy"zyy"zPj078R <ESC>A\<ESC>`yv0di<BS><ESC>:nohl<CR>
nmap <leader><leader>m <leader>mac

" open file
nmap <leader>ope ,,3:e <C-r>z<CR>:nohl<CR>
nmap <leader><leader>e <leader>ope

" toggle paste insert mode
nmap <leader>pst :set paste!<CR>

" add return and continue comment
nmap <leader>rtn 0f;mxa;<ESC>D"zyyA;<ESC>0/\><CR>myD"yyy079R <ESC>"yp"zp`yj0vwhdi// <ESC>gU$$hklv0dji<BS><ESC>`xv0djdd`xPj0i<BS><ESC>:nohl<CR>
nmap <leader><leader>r <leader>rtn

" add todo delete mark
nmap <leader>tbd mzO<Esc>0Di// <Esc>a=<Esc>27.iTODO Delete Below<Esc>a=<Esc>30.jo<Esc>0Di// <Esc>a=<Esc>29.iEnd Deletion<Esc>a=<Esc>33.`z
nmap <leader><leader>t <leader>tbd

" delete html tag
nmap <leader>tgd vatd
nmap <leader><leader>dt <leader>tgd

" copy html tag
nmap <leader>tgy vity
nmap <leader><leader>yt <leader>tgy

" switch between header and cpp
nmap <leader>thi :call ToggleExtension()<CR>
nmap <leader><leader>h <leader>thi

                              " ============== "
                              " F-Key Mappings "
                              " ============== "

" find file and linenumber
nmap <F5> /\w\+\(\(.h\)\\|\(.cpp\)\):\d\+<CR>

" BDEFormat plugin
nmap <F6> :BDEFormat<CR>

" include guards
nmap <F7> yyPwdwiifndef INCLUDED<Esc>lr_vw~wDjo#endif<Esc>o<Esc>

" toggle relative line number
nmap <F8> :set number<CR>:set relativenumber!<CR>
imap <F8> <ESC>:set number<CR>:set relativenumber!<CR>a

" = banner
nmap <F10> yyppo<Esc>k:s/./=/g<CR>kk:s/./=/g<CR>vjj:s/^/\/\/ /<CR>vkk:ce<CR>jjj:nohl<CR>

" - banner
nmap <F11> yyppo<Esc>k:s/./-/g<CR>kk:s/./-/g<CR>vjj:s/^/\/\/ /<CR>vkk:ce<CR>jjj:nohl<CR>

" block header
nmap <F12> 0v$gU:ce<CR>O// <Esc>a=<Esc>75.yyjpkR//<Esc>jo<Esc>0D

"==============================================================================
"                             MODELINE OVERRIDE
"==============================================================================

" vim: set colorcolumn=:
