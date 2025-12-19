Install if needed

```

npm install -g atcoder-cli @google/gemini-cli
pip install jedi yapf git+https://github.com/rotarymars/oj.git uv

gh completion -s zsh > /usr/local/share/zsh/site-functions/_gh

```

Disabling KVM for virtualbox
```bash
echo "blacklist kvm"       | sudo tee /etc/modprobe.d/blacklist-kvm.conf
echo "blacklist kvm_intel" | sudo tee -a /etc/modprobe.d/blacklist-kvm.conf
sudo update-initramfs -u

```

Installing cursor-cli
```
curl https://cursor.com/install -fsS | bash
```

Installing claude cli
```
curl -fsSL https://claude.ai/install.sh | bash
```

Install vscode manually using deb

Adding Serena into project(For each)
```
claude mcp add serena -- uvx --from git+https://github.com/oraios/serena serena start-mcp-server --context ide-assistant --project $(pwd)
```

Install delta from deb package

Install nvim manually

Install fzf manually
```bash
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install
```

```
```

Add marketplace for claude code 

```
/plugin marketplace add anthropics/claude-code
```
```
```
