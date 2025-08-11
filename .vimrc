" 行番号表示
set number

" インデントをスペースに統一
set expandtab
set tabstop=4
set shiftwidth=4
set smartindent
set autoindent

" 検索の挙動
set ignorecase      " 大文字小文字を区別しない
set smartcase       " 検索に大文字が含まれる場合は区別
set incsearch       " 入力中に検索
set hlsearch        " 検索結果をハイライト

set showcmd
set background=dark
set ruler

" シンタックス
syntax on

" jjでnormalモード
inoremap <silent> jj <ESC>

set laststatus=2

