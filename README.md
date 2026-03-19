# 0config
My personal computer configuration using Home Manager.

## Helpful Commands

Reloading the Nix Home Manager:
```
home-manager switch --flake ~/0config
```

Registering my personal key (each boot):
```
ssh-add ~/.ssh/personal_key
```

Configuring the git user in this repo (once per clone):
```
git config user.name "Joni Hendrickson"
git config user.email "contact@joni.site"
```

Setting my remote (once per clone):
```
git remote set-url origin git@github-personal:averagewagon/0config.git
```


## TODO List
- Set default browser
  - https://unix.stackexchange.com/questions/379632/how-to-set-the-default-browser-in-nixos
- Switch Zed from flatpak to direct install, which means fixing openGL stuff
- Find a better way of overriding Git config for work vs personal machines
