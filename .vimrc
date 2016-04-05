"""""""""""""""""""""""""""Plugin Settings"""""""""""""""""""""""""""""""""""""
set nocompatible
filetype off
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'gmarik/Vundle.vim'
Plugin 'kien/ctrlp.vim'
Plugin 'terryma/vim-multiple-cursors'
Plugin 'MovEaxEsp/bdeformat'
Plugin 'wesQ3/vim-windowswap'

if $ARCSTR_CM == "Linux"
    Plugin 'Valloric/YouCompleteMe'
endif

call vundle#end()
filetype plugin indent on

set filetype=unix

syntax enable

"""""""""""""""""""""""""""""""Settings""""""""""""""""""""""""""""""""""""""""
"Information on the following setting can be found with
":help set

">>>>>>> Common Settings <<<<<<

set tabstop=4
set expandtab           "use spaces to replace tab
set autoindent          "automatic indentation
set shiftwidth=4        "this is the level of autoindent, adjust to taste
set ruler               "set to show line number and charactor number
set number              "set linenumber
set backspace=indent,eol,start
set visualbell
set colorcolumn=80
set hlsearch            "set search result to be high lighted
set list listchars=trail:�
set foldmethod=manual
set modeline            "enable modeline
set modelines=20        "set modelines to 20 to skip the copyright notice

">>>>>> Conditional Settings <<<<<<

" set \t not expanded to spaces for Makefile --> Makefile require \t to parse
" (and python)
autocmd FileType make,python set noexpandtab

" set textwidth = 79, so textwrapping and gq} will work
autocmd FileType cpp,vim,xsd,python,c,javascript,sh set tw=79
" set tab to be hlighlighted
autocmd FileType cpp,c,javascript set listchars=tab:��,trail:�

" cmake pattern match
autocmd BufRead,BufNew */libs-vrs/*.t.cpp set makeprg=make\ -C\ cmake.bld/Linux/\ %:t:r

" schema make
autocmd FileType xsd set makeprg=make\ schema

" remove trailing space on certain filetype
autocmd FileType cpp,c,javascript,python autocmd BufWrite <buffer> silent! %s/\s\+$//g

" no absolute linenumber for file has more than 999 line
function SetLineNumber()
    if line('$') > 999
        set nonumber relativenumber
    else
        set number norelativenumber
    endif
endfunction
" by default apply this line number setting
autocmd BufRead,BufNew * call SetLineNumber()
" line number and colorcolumn make no sense in quick fix buffer
autocmd Filetype qf autocmd BufRead,BufNew <buffer> set nonumber norelativenumber colorcolumn=

"^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

" Uncomment below to make screen not flash on error
" set vb t_vb=""
let g:ycm_global_ycm_extra_conf = '/home/zwang311/.vim/ycm_extra_conf.py'
let g:ctrlp_follow_symlinks = 1
syntax on

"===================This is solarized colorscheme settings=====================

" >>>>>>> Solarized <<<<<<<
set t_Co=256
set background=dark
let g:solarized_termcolors=256
colorscheme solarized

" >>>>>>> Primary <<<<<<<<
"set t_Co=256
"set background=light
"colorscheme primary

"^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

"================================Functions=====================================

function ToggleHeaderAndImpl()
    let b:extension = expand("%:e")
    if b:extension ==? "h"
        execute ":e %<.cpp"
    elseif b:extension ==? "cpp"
        execute ":e %<.h"
    endif
endfunction

"===============================Keymappings====================================

let mapleader = ','

">>>>>>> Helper Keymappings <<<<<<<

" mark current cursor to cursor location 'z' and copy current identifier to
" register 'z', mark the position of first char of current identifier to
" location 'x', mark the last char to location 'y'
" ,,1 is for purely identifier
" ,,2 also includes the namespace
" ,,3 copy whatever between two while space charactors
nmap ,,1 mz/^\\|[^0-9A-Za-z_]<CR>?[0-9A-Za-z_]<CR>my?$\\|[^0-9A-Za-z_]<CR>/[0-9A-Za-z_]<CR>mxv`y"zy
nmap ,,2 mz/^\\|[^0-9A-Za-z_:]<CR>?[0-9A-Za-z_:]<CR>my?$\\|[^0-9A-Za-z_:]<CR>/[0-9A-Za-z:_]<CR>mxv`y"zy
nmap ,,3 mz/^\\|\s<CR>?\S<CR>my?$\\|\s<CR>/\S<CR>mxv`y"zy

">>>>>>>> Mapping table <<<<<<<
"
" * F key mappings not included in this table
"
"  KEY   SHORT                           DESCRIPTION
" ----- ------- --------------------------------------------------------------
"  bbf   f       find a Bloomberg type definition (in XML Schema, C++ header)
"  bnd   b       bind scrolling
"  cpp   p       ctrlp plugin for .
"  cpq   q       ctrlp plugin for ..
"  err   c       open compiler error window at most bottom position
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
"  thi   h       toggle header and implementation

">>>>>>>> Mapping Defs <<<<<<<

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
nmap <leader>cqq :CtrlP ..<CR>
nmap <leader><leader>p <leader>cpp
nmap <leader><leader>q <leader>cpq

" compile error window
nmap <leader>err :bo cw<CR>
nmap <leader><leader>c <leader>err

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
nmap <leader>thi :call ToggleHeaderAndImpl()<CR>
nmap <leader><leader>h <leader>thi

">>>>>>>> <F2> - <F10> Keymappings <<<<<<<

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

"^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
