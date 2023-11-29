if 0 | endif

" checking Vimrc read order
" :set runtimepath
" :scriptnames
" https://stackoverflow.com/questions/3495124/not-reading-vimrc

if &compatible
  set nocompatible
endif
" dein.vimのディレクトリ
let s:dein_dir = expand('~/.dein')
let s:dein_repo_dir = s:dein_dir . '/repos/github.com/Shougo/dein.vim'

" なければgit clone
if !isdirectory(s:dein_repo_dir)
  execute '!git clone https://github.com/Shougo/dein.vim' s:dein_repo_dir
endif
execute 'set runtimepath^=' . s:dein_repo_dir

" Required:
call dein#begin(s:dein_dir)

" Let dein manage dein
" Required:
call dein#add('Shougo/dein.vim')

call dein#add('Shougo/vimproc.vim', {'build': 'make'}) " 非同期処理化
call dein#add('Shougo/neosnippet.vim') " 補完
call dein#add('Shougo/neosnippet-snippets')
" call dein#add('Shougo/vimshell', { 'rev': '3787e5' }) " vim 8 default
call dein#add('Shougo/unite.vim')
" call dein#add('Shougo/neomru.vim') Catalina Error, String as a Float
call dein#add('Shougo/unite-outline')
call dein#add('Shougo/vimfiler')
call dein#add('itchyny/lightline.vim')
call dein#add('tpope/vim-fugitive')
call dein#add('taka84u9/unite-git')
call dein#add('sgur/unite-git_grep')
call dein#add('osyo-manga/vim-over')
call dein#add('mattn/webapi-vim')
call dein#add('mattn/gist-vim', {'depends': 'mattn/webapi-vim'})
call dein#add('tpope/vim-markdown')
call dein#add('cohama/agit.vim')
call dein#add('sjl/gundo.vim')
call dein#add('mhinz/vim-startify')
call dein#add('AndrewRadev/switch.vim')
call dein#add('tsukkee/unite-tag')
call dein#add('editorconfig/editorconfig-vim')
call dein#add('ConradIrwin/vim-bracketed-paste') " se pastetoggle=<C-z>
call dein#add('stephpy/vim-yaml')
call dein#add('cohama/lexima.vim')
call dein#add('thinca/vim-quickrun') " exec: \r , close: Ctrl+w+o or Ctrl-c
call dein#add('osyo-manga/vim-anzu')
call dein#add('Shougo/denite.nvim')
" python
call dein#add('nvie/vim-flake8')

" Required:
call dein#end()

if dein#check_install()
  call dein#install()
endif

" vim-quickrun
nnoremap <C-c> :only<CR>
" 削除されたkey mappingを復活
" https://github.com/thinca/vim-quickrun/commit/e2177d36e2b8b471e8c49c20a05961e349b0a7a6#diff-90db34bf956d442cf9fdb89d743b39d6309b79468fa44e0de29038dd7afb4d3a
nnoremap <silent> <Leader>r <Plug>(quickrun)

" Required:
filetype plugin indent on

"End dein Scripts-------------------------


" Settings
set tabstop=4
set shiftwidth=4
set softtabstop=4
set encoding=utf-8
set fileencodings=utf-8,iso-2022-jp,sjis,cp932,euc-jp
set nu
nnoremap <silent> <C-m> :<C-u>setlocal number!<CR>
set backspace=indent,eol,start
set autoindent
set expandtab
set clipboard=unnamed
set display=lastline
set ruler
set wrap
set list
set cursorline
set listchars=tab:>-,trail:-,nbsp:%
set smartindent
set showmatch
set whichwrap=b,s,<,>
set laststatus=2
set ignorecase
set smartcase
set hlsearch
set noswapfile
set showcmd
if !has('gui_running')
  set t_Co=256
endif

if has("syntax")
  syntax on

  " PODバグ対策
  syn sync fromstart
  function! ActivateInvisibleIndicator()
    "# 下の行の"　"は全角スペース
    syntax match InvisibleJISX0208Space "　" display containedin=ALL
    highlight InvisibleJISX0208Space term=underline ctermbg=Blue guibg=darkgray gui=underline
    "syntax match InvisibleTrailedSpace "[ \t]\+$" display containedin=ALL
    "highlight InvisibleTrailedSpace term=underline ctermbg=Red guibg=NONE gui=undercurl guisp=darkorange
    "syntax match InvisibleTab "\t" display containedin=ALL
    "highlight InvisibleTab term=underline ctermbg=white gui=undercurl guisp=darkslategray
  endf
  augroup invisible
  autocmd! invisible
  autocmd BufNew,BufRead * call ActivateInvisibleIndicator()
  augroup END
endif

" カーソル位置の復元
augroup vimrcEx
  au BufRead * if line("'\"") > 0 && line("'\"") <= line("$") |
  \ exe "normal g`\"zz" | endif
augroup END

" sudo write
cabbrev sudo w !sudo tee %

" copy
autocmd InsertLeave * set nopaste


" 設定の保存と復元
"autocmd BufWinLeave ?* silent mkview
"autocmd BufWinEnter ?* silent loadview

" grepの表示にcwindowを使う
autocmd QuickFixCmdPost *grep* cwindow


"""""""""""""""""""""""""""""""""""""""""""""""""
" key remap
"--------------------------------------------------
" コマンド       ノーマル 挿入 コマンド ビジュアル
" map /noremap       @     -      -        @
" nmap / nnoremap    @     -      -        -
" imap / inoremap    -     @      -        -
" cmap / cnoremap    -     -      @        -
" vmap / vnoremap    -     -      -        @
" map! / noremap!    -     @      @        -
"--------------------------------------------------

nmap     <Space>   [Space]
nnoremap [Space]   <Nop>

" ctags
nnoremap <C-]> g<C-]>

nnoremap <Space>r :source ~/.vimrc<CR>
nnoremap q :<C-u>q<CR>

" タブ移動
nnoremap <silent> tn :<C-u>tabnext<CR>
nnoremap <silent> tp :<C-u>tabprevious<CR>

" For cursor moving in insert mode
inoremap <C-h> <left>
inoremap <C-j> <down>
inoremap <C-k> <up>
" inoremap <C-l> <right> " => neosnippet

""""""""""""""""""""""""""""""""""""""""""""""""
" neosnippet
imap <expr><C-l> neosnippet#expandable() ? "<Plug>(neosnippet_expand_or_jump)" : pumvisible() ? "<C-y>" : "<right>"

imap <expr><TAB> pumvisible() ? "<C-n>" : neosnippet#jumpable() ? "<Plug>(neosnippet_expand_or_jump)" : "<TAB>"

""""""""""""""""""""""""""""""""""""""""""""""""
" neocomplcache
"Note: This option must set it in .vimrc(_vimrc).  NOT IN .gvimrc(_gvimrc)!
" Disable AutoComplPop.
let g:acp_enableAtStartup = 0
" Use neocomplcache.
let g:neocomplcache_enable_at_startup = 1
" Use smartcase.
let g:neocomplcache_enable_smart_case = 1
" Set minimum syntax keyword length.
let g:neocomplcache_min_syntax_length = 3
let g:neocomplcache_lock_buffer_name_pattern = '\*ku\*'

" Enable heavy features.
" Use camel case completion.
"let g:neocomplcache_enable_camel_case_completion = 1
" Use underbar completion.
"let g:neocomplcache_enable_underbar_completion = 1

" Define dictionary.
let g:neocomplcache_dictionary_filetype_lists = {
    \ 'default' : '',
    \ 'vimshell' : $HOME.'/.vimshell_hist',
    \ 'scheme' : $HOME.'/.gosh_completions'
        \ }

" Define keyword.
if !exists('g:neocomplcache_keyword_patterns')
    let g:neocomplcache_keyword_patterns = {}
endif
let g:neocomplcache_keyword_patterns['default'] = '\h\w*'

" Plugin key-mappings.
inoremap <expr><C-g>     neocomplcache#undo_completion()
" inoremap <expr><C-l>     neocomplcache#complete_common_string()

" Recommended key-mappings.
" <CR>: close popup and save indent.
inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
function! s:my_cr_function()
  "return neocomplcache#smart_close_popup() . "\<CR>"
  " For no inserting <CR> key.
  return pumvisible() ? neocomplcache#close_popup() : "\<CR>"
endfunction
" <BS>: close popup and delete backword char.
inoremap <expr><BS> neocomplcache#smart_close_popup()."\<C-h>"
inoremap <expr><C-e>  neocomplcache#cancel_popup()

" AutoComplPop like behavior.
"let g:neocomplcache_enable_auto_select = 1

" Shell like behavior(not recommended).
"set completeopt+=longest
"let g:neocomplcache_enable_auto_select = 1
"let g:neocomplcache_disable_auto_complete = 1

" Enable omni completion.
autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags

" Enable heavy omni completion.
if !exists('g:neocomplcache_force_omni_patterns')
  let g:neocomplcache_force_omni_patterns = {}
endif
let g:neocomplcache_force_omni_patterns.php = '[^. \t]->\h\w*\|\h\w*::'
let g:neocomplcache_force_omni_patterns.c = '[^.[:digit:] *\t]\%(\.\|->\)'
let g:neocomplcache_force_omni_patterns.cpp = '[^.[:digit:] *\t]\%(\.\|->\)\|\h\w*::'

" For perlomni.vim setting.
" https://github.com/c9s/perlomni.vim
let g:neocomplcache_force_omni_patterns.perl = '\h\w*->\h\w*\|\h\w*::'

""""""""""""""""""""""""""""""""""""""""""""""""
" unite
nnoremap [Unite]  <Nop>
nmap     <Space>u [Unite]
nnoremap <silent> [Unite]u :<C-u>Unite file_mru buffer<CR>
nnoremap <silent> [Unite]t :<C-u>Unite tab<CR>
nnoremap <silent> [Unite]y :<C-u>Unite history/yank<CR>
nnoremap <silent> [Unite]r :<C-u>Unite file_rec<CR>
nnoremap <silent> [Unite]f :<C-u>UniteWithBufferDir -buffer-name=files file<CR>
nnoremap <silent> [Unite]o :<C-u>Unite -vertical -winwidth=45 -no-quit outline<CR>
" grep検索
nnoremap <silent> [Unite]g :<C-u>Unite grep:. -buffer-name=search-buffer<CR>
" カーソル位置の単語をgrep検索
nnoremap [Unite]cg :<C-u>Unite grep:. -buffer-name=search-buffer<CR><C-R><C-W>
let g:unite_enable_start_insert=0
let g:unite_source_history_yank_enable = 1
let g:unite_source_file_mru_limit = 200
" 大文字小文字を区別しない
let g:unite_enable_ignore_case = 1
let g:unite_enable_smart_case = 1
let g:unite_split_rule = 'botright'
"call unite#custom_default_action('file', 'tabopen')
"call unite#custom#profile('default', 'context', { 'prompt_direction': 'top'})


""""""""""""""""""""""""""""""""""""""""""""""""
" lightline settings
let g:lightline = {
  \ 'colorscheme': 'wombat',
  \ 'mode_map': {'c': 'NORMAL'},
  \ 'active': {
  \   'left': [ [ 'mode', 'paste' ], [ 'fugitive', 'filename' ] ]
  \ },
  \ 'component_function': {
  \   'modified': 'MyModified',
  \   'readonly': 'MyReadonly',
  \   'fugitive': 'MyFugitive',
  \   'filename': 'MyFilename',
  \   'fileformat': 'MyFileformat',
  \   'filetype': 'MyFiletype',
  \   'fileencoding': 'MyFileencoding',
  \   'mode': 'MyMode'
  \ }
\ }

function! MyModified()
  return &ft =~ 'help\|vimfiler\|gundo' ? '' : &modified ? '+' : &modifiable ? '' : '-'
endfunction

function! MyReadonly()
  return &ft !~? 'help\|vimfiler\|gundo' && &readonly ? 'x' : ''
endfunction

function! MyFilename()
  return ('' != MyReadonly() ? MyReadonly() . ' ' : '') .
    \ (&ft == 'vimfiler' ? vimfiler#get_status_string() :
    \  &ft == 'unite' ? unite#get_status_string() :
    \  &ft == 'vimshell' ? vimshell#get_status_string() :
    \ '' != expand('%:t') ? expand('%:t') : '[No Name]') .
    \ ('' != MyModified() ? ' ' . MyModified() : '')
endfunction

function! MyFugitive()
  try
    if &ft !~? 'vimfiler\|gundo' && exists('*fugitive#head')
      return fugitive#head()
    endif
  catch
  endtry
  return ''
endfunction

function! MyFileformat()
  return winwidth(0) > 70 ? &fileformat : ''
endfunction

function! MyFiletype()
  return winwidth(0) > 70 ? (strlen(&filetype) ? &filetype : 'no ft') : ''
endfunction

function! MyFileencoding()
  return winwidth(0) > 70 ? (strlen(&fenc) ? &fenc : &enc) : ''
endfunction

function! MyMode()
  return winwidth(0) > 60 ? lightline#mode() : ''
endfunction


""""""""""""""""""""""""""""""""""""""""""""""""
" git fugitive
nnoremap [git]    <Nop>
nmap     <Space>g [git]

nnoremap <silent> [git]st  :<C-u>Gstatus<CR>
nnoremap <silent> [git]d   :<C-u>Gdiff<CR>
nnoremap <silent> [git]b   :<C-u>Gblame<CR>
nnoremap <silent> [git]g   :<C-u>UniteWithCursorWord vcs_grep/git<CR>


""""""""""""""""""""""""""""""""""""""""""""""""
" vim-over
nnoremap [over] <Nop>
nmap     <space>m [over]

nnoremap <silent> [over]s :OverCommandLine<CR>%s/
" カーソル下の単語をハイライト付きで置換
nnoremap <silent> [over]m :OverCommandLine<CR>%s/<C-r><C-w>//gc<Left><Left><Left>


""""""""""""""""""""""""""""""""""""""""""""""""
" gist-vim
let g:gist_api_url = 'https://git.corp.yahoo.co.jp/api/v3'


""""""""""""""""""""""""""""""""""""""""""""""""
" todo
command! Todo vsplit ~/todo.md

function! IndentAll()
  normal! mxgg=G'x
  delmarks x
endfunction

function! DeleteSpace()
  normal mxG$
  let flags = "w"
  while search(" $", flags) > 0
    s/ \+$//g
    let flags = "W"
  endwhile
  'x
  delmarks x
endfunction

function! AlignCode()
  retab
  call IndentAll()
  call DeleteSpace()
endfunction

function! AlignAllBuf()
  for i in  range(1, bufnr("$"))
    if buflisted(i)
      execute "buffer" i
      call AlignCode()
      update
      bdelete
    endif
  endfor
  quit
endfunction

""""""""""""""""""""""""""""""""""""""""""""""""
" Gundo.vim
nnoremap <Space>h :<C-u>GundoToggle<CR>

""""""""""""""""""""""""""""""""""""""""""""""""
" Switch.vim
nnoremap <Space>s :<C-u>Switch<CR>
let g:switch_definitions =
  \ [
  \   ['private', 'public'],
  \   ['int ', 'unsigned int '],
  \ ]

""""""""""""""""""""""""""""""""""""""""""""""""
" anzu
nmap n <Plug>(anzu-n-with-echo)
nmap N <Plug>(anzu-N-with-echo)
nmap * <Plug>(anzu-star-with-echo)
nmap # <Plug>(anzu-sharp-with-echo)
""""""""""""""""""""""""""""""""""""""""""""""""
