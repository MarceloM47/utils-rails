1. Activate WSL and Ubuntu in Windows
```powershell
 wsl --install
 wsl --update
 wsl --set-default-version 2
```

2. Install base
```powershell
sudo apt update
sudo apt install -y git curl gnupg build-essential libssl-dev libreadline-dev zlib1g-dev libsqlite3-dev
```

3. Install ruby by rbenv
```powershell
git clone https://github.com/rbenv/rbenv.git ~/.rbenv
echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc
echo 'eval "$(rbenv init - bash)"' >> ~/.bashrc
source ~/.bashrc

# Install ruby-build plugin
git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build

# Install Ruby
rbenv install 3.2.4
rbenv global 3.2.4
```

4. Install Bundler and Rails
```powershell
gem install bundler
gem install rails
```



