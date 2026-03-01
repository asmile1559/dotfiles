# Nixvim template

This template gives you a good starting point for configuring Nixvim standalone.

## Configuring

To start configuring, just add or modify the nix files in `./config`.
If you add a new configuration file, remember to add it to the
[`config/default.nix`](./config/default.nix) file

## Testing your new configuration

To test your configuration simply run the following command

```
nix run .
```

## Install NixVim

To install NixVim in machine, run the following command

```bash
nix profile add .
```

```bash
nix profile remove .config/home-manager/packages/nixvim
nix profile add .
```

## TODO

1. Rust can't debug now
2. add remote-nvim to `lsp`
3. add markdown preview
4. make 'ai' folder and add ai support