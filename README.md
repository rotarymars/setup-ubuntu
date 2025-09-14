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
npm install -g @anthropic-ai/claude-code
```

Install vscode manually using deb

Adding Serena into project
```
claude mcp add serena --scope=user -- uvx --from git+https://github.com/oraios/serena serena start-mcp-server --context ide-assistant --project $(pwd)
```
