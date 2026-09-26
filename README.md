# setup-ubuntu

Automated Ubuntu setup using Ansible.

## Usage

Run the installation script:
```bash
./install.sh
```

Or use Ansible directly:
```bash
ansible-playbook -i inventory.ini main.yml --ask-become-pass
```

## Post-Installation Manual Steps
Instsall vscode manually

Install fzf
```bash
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install
```

### Configure ibus-mozc as default input method
```bash
im-config -n ibus
```

### Disable KVM for VirtualBox (if needed)
```bash
echo "blacklist kvm"       | sudo tee /etc/modprobe.d/blacklist-kvm.conf
echo "blacklist kvm_intel" | sudo tee -a /etc/modprobe.d/blacklist-kvm.conf
sudo update-initramfs -u
```
Install copilot cli
```
curl -fsSL https://gh.io/copilot-install | bash
```

Install orca slicer
```
https://github.com/OrcaSlicer/OrcaSlicer/releases/tag/v2.3.1

flatpak install --user ./file.flatpak
```

Install Chitubox

Download the Linux x64 `.tar.gz` (needs a free account) from
https://www.chitubox.com/en/download/previous/chitubox-free
```bash
# Qt runtime deps
sudo apt install libxcb-xinerama0 libxcb-cursor0 libgl1

tar -xzf CHITUBOX_Basic_x64_V*.tar.gz
# run the bundled installer, then launch from the install dir:
#   right-click CHITUBOX_Basic.sh -> "Run as a Program" (or ./CHITUBOX_Basic.sh)
```

Install platformio
```bash
curl -fsSL -o get-platformio.py https://raw.githubusercontent.com/platformio/platformio-core-installer/master/get-platformio.py
python3 get-platformio.py
```

Freeze kernel at generic
```bash
sudo apt-mark hold linux-image-generic-hwe-24.04 linux-headers-generic-hwe-24.04
```
Execute below:

```bash
sudo rm /etc/apt/sources.list.d/google-chrome.list
```

Install antigravity
```bash
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://us-central1-apt.pkg.dev/doc/repo-signing-key.gpg | \
  sudo gpg --dearmor --yes -o /etc/apt/keyrings/antigravity-repo-key.gpg
echo "deb [signed-by=/etc/apt/keyrings/antigravity-repo-key.gpg] https://us-central1-apt.pkg.dev/projects/antigravity-auto-updater-dev/ antigravity-debian main" | \
  sudo tee /etc/apt/sources.list.d/antigravity.list > /dev/null
sudo apt update && sudo apt install antigravity
```

Install stuff from rustup
```bash
rustup default stable
```

Install jj
```bash
cargo install --locked --bin jj jj-cli
```

Install claude code
```bash
curl -fsSL https://claude.ai/install.sh | bash
```

Install ollama
```bash
curl -fsSL https://ollama.com/install.sh | sh
```

Install proton
https://protonvpn.com/ja/support/official-linux-vpn-ubuntu
```
wget https://repo.protonvpn.com/debian/dists/stable/main/binary-all/protonvpn-stable-release_1.0.8_all.deb
sudo dpkg -i ./protonvpn-stable-release_1.0.8_all.deb && sudo apt update
sudo apt install proton-vpn-gnome-desktop
sudo apt install gnome-shell-extension-appindicator
```

Install act
```bash
gh extension install https://github.com/nektos/gh-act
```

Install gemini-cli and stuff
```bash
npm install -g  @google/gemini-cli
gemini mcp add -s user chrome-devtools npx chrome-devtools-mcp@latest
```

Install coderabbit cli
```bash
curl -fsSL https://cli.coderabbit.ai/install.sh | sh
```

Install openclaw
```bash
curl -fsSL https://openclaw.ai/install.sh | bash
```

Install Minecraft: Education Edition via Waydroid

There is no native Linux build, so run the Android version inside Waydroid.
Ansible installs the `waydroid` package; the steps below are one-time and interactive.
```bash
# 1. Initialize with Google Play (downloads ~1-2 GB Android image) and start the service
sudo waydroid init -s GAPPS
sudo systemctl enable --now waydroid-container

# 2. Switch to a Wayland session: log out -> gear icon -> "Ubuntu on Wayland" -> log back in

# 3. Launch the Android UI
waydroid show-full-ui

# 4. Certify the device with Google (Play Store blocks uncertified devices)
sudo waydroid shell -- sh -c "sqlite3 /data/data/*/*/gservices.db 'select * from main where name = \"android_id\";'"
# Register the printed number at https://www.google.com/android/uncertified

# 5. Restart the session so certification takes effect
waydroid session stop   # wait 1-2 min, then:
waydroid show-full-ui

# 6. In the UI: sign into Google Play, install "Minecraft Education",
#    then launch it and sign in with a Microsoft 365 Education account.
```

Install antigravity cli
```bash
curl -fsSL https://antigravity.google/cli/install.sh | bash
```


Enable stacked PRs in gh-act
```
gh extension install github/gh-stack
```

### Workspace grid (田の字 / 3x3 virtual desktops)

Handled by the `gnome-workspace-grid` role — no GUI steps needed.

GNOME 40+ lays workspaces out as a single row, so `Ctrl+Alt+Up`/`Down` are bound but
have nowhere to go. The role installs [Workspace Matrix](https://extensions.gnome.org/extension/1485/workspace-matrix/)
(`wsmatrix@martin.zurowietz.de`), which is the maintained successor to the long-dead
"Workspace Grid" extension, and works on Wayland. It picks the release matching the
running GNOME Shell from the extensions.gnome.org API, so it keeps working across
Ubuntu upgrades.

Grid size lives in `roles/gnome-workspace-grid/defaults/main.yml`:

```yaml
workspace_grid_rows: 3
workspace_grid_columns: 3   # 2 x 2 for a plain 田の字
```

`num-workspaces` is derived from rows x columns, and `dynamic-workspaces` is turned off.

**After the playbook runs, log out and back in.** Wayland cannot restart GNOME Shell in
place (`Alt+F2` -> `r` is X.org only), so the extension is not loaded until the next login.

Tweak the rest interactively with:
```bash
gnome-extensions prefs wsmatrix@martin.zurowietz.de
```

Install epson driver

- go to https://download-center.epson.com/search/?language=ja

### Enable hibernate (Secure Boot on, dual boot with Windows)

With Secure Boot on, the kernel runs in lockdown mode, which disables hibernate
(`/sys/power/disk` shows `[disabled]`, `CanHibernate` returns `na`). Instead of turning
Secure Boot off in the firmware (which Windows would notice: BitLocker, anti-cheat),
turn off signature validation in shim only. The kernel then treats Secure Boot as off
and skips lockdown, while the firmware keeps Secure Boot on for Windows.

Trade-off: Linux no longer gets Secure Boot protection, and shim prints
"Booting in insecure mode" at every boot.

Hibernate target: `/swap2.img` (128G, on the root ext4 partition).

```bash
# 1. Point the kernel at the swap file (a drop-in, so /etc/default/grub stays untouched)
UUID=$(findmnt -no UUID -T /swap2.img)
OFFSET=$(sudo filefrag -v /swap2.img | awk '$1=="0:"{sub(/\.\./,"",$4); print $4}')
echo "UUID=$UUID OFFSET=$OFFSET"   # both must be non-empty
echo "GRUB_CMDLINE_LINUX_DEFAULT=\"\$GRUB_CMDLINE_LINUX_DEFAULT resume=UUID=$UUID resume_offset=$OFFSET\"" \
  | sudo tee /etc/default/grub.d/99-resume.cfg
sudo update-grub
sudo update-initramfs -u -k all

# 2. Keep /boot/efi unmounted when idle, so a hibernated Linux does not hold a stale
#    view of the ESP that Windows may write to. In /etc/fstab change the /boot/efi options:
#      defaults  ->  defaults,noauto,x-systemd.automount,x-systemd.idle-timeout=60
sudo systemctl daemon-reload

# 3. Disable shim validation (asks for a one-time password, 8-16 chars)
sudo mokutil --disable-validation
sudo reboot
```

On the blue MOK management screen at reboot: **Change Secure Boot state** -> enter the
requested characters of the password (e.g. "Password character 3") -> **Yes** -> reboot.

The polkit override and the power-menu button are handled by the `hibernate` role
(listed in `target_roles` in `roles/rotarymars_setup/tasks/main.yml`):

- `roles/hibernate/files/10-enable-hibernate.rules` goes to `/etc/polkit-1/rules.d/`.
  Ubuntu's `/usr/share/polkit-1/rules.d/com.ubuntu.desktop.rules` returns NO for every
  hibernate action ("Disable hibernate by default in Ubuntu"), so `CanHibernate` stays
  `"no"` even when the kernel supports it; this earlier-sorted rule overrides it.
- [Hibernate Status Button](https://extensions.gnome.org/extension/755/hibernate-status-button/)
  (`hibernate-status@dromi`) is installed and enabled, adding Hibernate to the power
  menu (hold Alt for Hybrid Sleep). Log out and back in to load it.
- Closing the lid does suspend-then-hibernate: it suspends, and after 1 hour wakes up and
  hibernates (`/etc/systemd/logind.conf.d/10-lid-hibernate.conf` and
  `/etc/systemd/sleep.conf.d/10-hibernate-delay.conf`, set by `hibernate_lid_action` and
  `hibernate_delay` in `roles/hibernate/defaults/main.yml`). Without a fixed delay systemd
  waits until the battery is estimated at 5%.
  Before booting Windows, use Hibernate (the lid only hibernates after the delay).

Run only this role:
```bash
cat > /tmp/hibernate.yml <<'EOF'
- hosts: all
  roles: [hibernate]
EOF
ANSIBLE_ROLES_PATH=$PWD/roles ansible-playbook -i inventory.ini /tmp/hibernate.yml --ask-become-pass
```

Verify:
```bash
mokutil --sb-state                        # "SecureBoot validation is disabled in shim"
cat /sys/kernel/security/lockdown         # [none]
cat /sys/power/state                      # includes "disk"
cat /proc/cmdline                         # includes resume=... resume_offset=...
busctl call org.freedesktop.login1 /org/freedesktop/login1 \
  org.freedesktop.login1.Manager CanHibernate   # s "yes" (s "no" = polkit rule missing)
systemctl hibernate                       # test; pick Ubuntu in GRUB to resume
```

Notes:
- If `/swap2.img` is ever recreated, its offset changes: redo step 1.
- Hibernating Linux and booting Windows is fine as long as Windows never writes to the
  Linux partition. Choose Ubuntu in GRUB (same kernel) to resume.
- Undo: `sudo mokutil --enable-validation`, reboot, confirm in MOK manager, and
  `sudo rm /etc/default/grub.d/99-resume.cfg && sudo update-grub`.
  Drop `hibernate` from `target_roles` and remove `/etc/polkit-1/rules.d/10-enable-hibernate.rules`.

# On thinkpad
for realtek network cards

for file /etc/modprobe.d/30-rtw89.conf
```
options rtw89pci disable_aspm_l1=y options rtw89pci disable_aspm_l1ss=y
```
