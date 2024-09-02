## How to

1. Install dependencies.

```shell
brew install ripgrep fd fzf zoxide git lazygit pyenv poetry volta stow luarocks neovim
volta install node pnpm
npm install -g neovim
pyenv install 3.12  # or the version you want
pyenv shell 3.12
pip install neovim
```

2. Clone repo and stow the config files.

```shell
cd ~
git clone git@github.com:daironmichel/my-dotfiles.git dotfiles
cd dotfiles
stow
```

3. Configure neovim's python

```lua
-- Add this to ~/.config/nvim/lua/config/options.lua
vim.g.python3_host_prog = os.getenv("HOMW") + "/.pyenv/versions/3.12.5/bin/python"
```

4. Open neovim
