# Phone Setup

Steps to set up 0config on a GrapheneOS phone using the Android Terminal (Linux VM).

## 1. Enable the Linux Terminal

1. Go to Settings > About phone and tap Build number 7 times to enable Developer Options
2. Go to Settings > System > Developer options
3. Enable Linux terminal
4. Open the new Terminal app - it will download and install a ~565MB Debian VM
5. Once booted, you're logged in as `droid@debian`

## 2. Set up sudo

The VM doesn't configure sudo by default. Set a root password and add `droid` to sudoers:
```bash
su -
passwd root
usermod -aG sudo droid
exit
```

Log out and back in (close and reopen the terminal).

## 3. Clone 0config

```bash
sudo apt install git
git clone https://github.com/averagewagon/0config.git ~/0config
```

## 4. Fix DNS (if needed)

If downloads time out, the VM's DNS may not be configured:
```bash
echo "nameserver 8.8.8.8" | sudo tee /etc/resolv.conf
```

## 5. Install Nix

```bash
curl -sSfL https://artifacts.nixos.org/nix-installer | sh -s -- install
```

Restart the terminal.

## 6. Activate Home Manager

```bash
nix-shell -p home-manager
home-manager switch --flake ~/0config#phone
```

## Notes

- The VM runs `aarch64-linux` (ARM64)
- The VM can be reset by the Terminal app (e.g. during disk resize) - if this happens, re-run setup from step 2
