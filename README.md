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
- Closing the lid on battery does suspend-then-hibernate: it suspends, and hibernates when
  the battery runs low (the firmware low-battery alarm, or about 5%). On AC it only
  suspends; this is decided when the lid closes, so unplugging later does not switch it.
  Set by `hibernate_lid_action`, `hibernate_lid_action_ac` and `hibernate_delay` in
  `roles/hibernate/defaults/main.yml` (`/etc/systemd/logind.conf.d/10-lid-hibernate.conf`;
  a non-empty `hibernate_delay` such as `3h` writes
  `/etc/systemd/sleep.conf.d/10-hibernate-delay.conf` to hibernate after a fixed time instead).
  Before booting Windows, use Hibernate (the lid may never hibernate).

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

### Google Drive at ~/google-mini (rclone)

Mounted with `rclone mount` instead of google-drive-ocamlfuse. google-drive-ocamlfuse
hung in FUSE readdir after the network dropped, and a task stuck on a FUSE request
cannot be frozen, so every suspend attempt failed with "Device or resource busy" for
a whole night (fan on, battery drained). rclone fails requests on timeout instead.

The `rclone-gdrive` role (listed in `target_roles`):

- Removes `google-drive-ocamlfuse`, installs rclone from the upstream `.deb` (the Ubuntu
  package is old) and `fuse3`.
- Installs the user unit `~/.config/systemd/user/rclone-gdrive.service`: short network
  timeouts (`--timeout 30s --contimeout 15s`), a 24h dir cache, a 20G file cache
  (`--vfs-cache-mode full`), and `--drive-export-formats desktop`, so Docs/Sheets/Slides
  are Type=Link `.desktop` files that the `gdrive-desktop-links` opener handles.
  `Restart=always`, because rclone exits cleanly (status 0) when the network is gone, e.g.
  DNS failing right after resume, and `on-failure` would leave the mount down.
- Installs `/usr/lib/systemd/system-sleep/fuse-abort-hung`: before suspend, it aborts any
  rclone FUSE connection that still has requests waiting after 5s, so stuck tasks are
  released and suspend goes through. The service then remounts.
- Enables the service only once the `gdrive:` remote exists, otherwise prints a reminder.

Settings are in `roles/rclone-gdrive/defaults/main.yml`.

The remote needs a browser login, so create it once by hand between two runs of the role:
```bash
ansible-playbook -i inventory.ini main.yml --ask-become-pass -e '{"target_roles":["rclone-gdrive"]}'
rclone config        # answers below
ansible-playbook -i inventory.ini main.yml --ask-become-pass -e '{"target_roles":["rclone-gdrive"]}'
```

`rclone config` answers:

| Prompt | Answer |
|---|---|
| `n/s/q>` | `n` (new remote) |
| `name>` | `gdrive` |
| `Storage>` | `drive` (Google Drive; the number changes between versions) |
| `client_id>` / `client_secret>` | your own OAuth client, see below |
| `scope>` | `1` (`drive`, full access) |
| `service_account_file>` | Enter (blank) |
| `Edit advanced config?` | `n` |
| `Use web browser to automatically authenticate?` | `y`, log in; on "Google hasn't verified this app": Advanced -> Go to ... (unsafe) |
| `Configure this as a Shared Drive (Team Drive)?` | `n` |
| `Keep this "gdrive" remote?` | `y`, then `q` |

Don't leave `client_id` blank: rclone's shared client is being retired during 2026 and is
rate limited. The google-drive-ocamlfuse client works, its values are still in
`~/.gdfuse/default/config` (`grep -E 'client_(id|secret)' ~/.gdfuse/default/config`).
For a new one, in https://console.cloud.google.com: create a project, enable the
Google Drive API, set up Google Auth Platform (External), **publish the app** (Audience ->
"In production"; in "Testing" the login expires after 7 days), then Clients -> Create
client -> Desktop app.

Without Ansible, the same in one go:
```bash
set -e
M="$HOME/google-mini"
sudo apt-get remove -y google-drive-ocamlfuse || true
command -v rclone >/dev/null || { curl -fsSLo /tmp/rclone.deb https://downloads.rclone.org/rclone-current-linux-amd64.deb && sudo apt-get install -y /tmp/rclone.deb; }
sudo apt-get install -y fuse3
sudo tee /usr/lib/systemd/system-sleep/fuse-abort-hung >/dev/null <<'EOF'
#!/bin/sh
[ "$1" = pre ] || exit 0
conns=$(awk '{for (i = 7; i <= NF; i++) if ($i == "-") { if ($(i + 1) == "fuse.rclone") { split($3, d, ":"); print d[2] } break }}' /proc/self/mountinfo)
for c in $conns; do
  dir=/sys/fs/fuse/connections/$c; [ -d "$dir" ] || continue
  for _ in 1 2 3 4 5; do [ "$(cat "$dir/waiting")" -eq 0 ] && continue 2; sleep 1; done
  logger -t fuse-abort-hung "aborting hung rclone FUSE connection $c"; echo 1 > "$dir/abort"
done
EOF
sudo chmod 755 /usr/lib/systemd/system-sleep/fuse-abort-hung
mkdir -p ~/.config/systemd/user
cat > ~/.config/systemd/user/rclone-gdrive.service <<EOF
[Unit]
Description=Google Drive (rclone) at $M
[Service]
Type=notify
ExecStartPre=-/usr/bin/fusermount3 -uz $M
ExecStartPre=/usr/bin/mkdir -p $M
ExecStart=/usr/bin/rclone mount gdrive: $M --vfs-cache-mode full --vfs-cache-max-size 20G --dir-cache-time 24h --poll-interval 1m --timeout 30s --contimeout 15s --low-level-retries 3 --drive-export-formats desktop
ExecStop=/usr/bin/fusermount3 -uz $M
Restart=always
RestartSec=10
[Install]
WantedBy=default.target
EOF
rclone listremotes | grep -qx 'gdrive:' || rclone config
systemctl --user daemon-reload && systemctl --user enable --now rclone-gdrive.service
```

Verify:
```bash
systemctl --user status rclone-gdrive     # active (running)
findmnt ~/google-mini                     # FSTYPE fuse.rclone
journalctl -t fuse-abort-hung             # lines only when the hook had to abort a mount
```

Notes:
- The first listing of a big folder is slow (fetched over the network), later ones come
  from the cache.
- If a suspend still hangs, `fusermount -uz ~/google-mini` frees stuck tasks.
- `~/.gdfuse` (google-drive-ocamlfuse config and cache) is left behind; delete it once
  rclone works, after copying the client ID and secret somewhere if you still need them.
- Undo: `systemctl --user disable --now rclone-gdrive`, remove
  `~/.config/systemd/user/rclone-gdrive.service` and
  `/usr/lib/systemd/system-sleep/fuse-abort-hung`, and drop `rclone-gdrive` from `target_roles`.

# On thinkpad
for realtek network cards

for file /etc/modprobe.d/30-rtw89.conf
```
options rtw89pci disable_aspm_l1=y options rtw89pci disable_aspm_l1ss=y
```
