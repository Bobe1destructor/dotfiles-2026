" Basic configuration
set number
set relativenumber
set mouse=a
set encoding=utf-8
set showcmd
set showmatch
set expandtab
set tabstop=4
set shiftwidth=4
set softtabstop=4
set autoindent
set smarttab
syntax enable

" Bootstrap vim-plug once, without making Neovim unusable if offline.
let s:plug_path = stdpath('data') . '/site/autoload/plug.vim'
if empty(glob(s:plug_path))
    silent! call mkdir(stdpath('data') . '/site/autoload', 'p')
    silent! execute '!curl -fLo ' . shellescape(s:plug_path) . ' --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
endif

if !empty(glob(s:plug_path))
    call plug#begin(stdpath('data') . '/plugged')
    Plug 'nvim-lualine/lualine.nvim'
    Plug 'nvim-tree/nvim-web-devicons'
    Plug 'navarasu/onedark.nvim'
    Plug 'catppuccin/nvim', { 'as': 'catppuccin' }
    call plug#end()

    " Install missing plugins on first launch, then reload this config.
    autocmd VimEnter * if len(filter(values(g:plugs), '!isdirectory(v:val.dir)')) | silent! PlugInstall --sync | source $MYVIMRC | endif
endif

" Fall back cleanly until plugins have been installed.
silent! colorscheme onedark

lua << EOF
local ok_onedark, onedark = pcall(require, 'onedark')
if ok_onedark then
    onedark.setup({ style = 'dark', transparent = true })
    onedark.load()
end

local ok_lualine, lualine = pcall(require, 'lualine')
if ok_lualine then
    lualine.setup({ options = { icons_enabled = true, theme = 'material' } })
end
EOF
