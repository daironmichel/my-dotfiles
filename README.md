## How to

1. Install dependencies.

```shell
brew install ripgrep fd fzf zoxide git lazygit pyenv poetry volta stow luarocks neovim
volta install node pnpm
npm install -g neovim
pyenv install 3.12  # or the version you want
pyenv shell 3.12
pip install neovim
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
```

2. Download and Install Menslo LG Nerd Font (variant MensloLGL Propo): https://www.nerdfonts.com/font-downloads

3. Clone repo and stow the config files.

```shell
cd ~
git clone git@github.com:daironmichel/my-dotfiles.git dotfiles
cd dotfiles
stow
tmux # then press `C-a + r` to reload config, followed by `C-a + I` to install plugins
```

4. Configure neovim's python

```lua
-- Add this to ~/.config/nvim/lua/config/options.lua
vim.g.python3_host_prog = os.getenv("HOME") + "/.pyenv/versions/3.12.5/bin/python"
```

5. Open neovim
