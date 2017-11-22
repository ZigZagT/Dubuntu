# Shared Content Directory

This folder is shared among vms, and mount at `/shared`.

## Additional controls to the VM
Put a file with specific name in this directory to override corresponding settings in VM. 
All file overriding is in symbol linking.

Available config files:
- `sources.list`: override `/etc/apt/sources.list` in VM.
- `resolv.conf`: override `/etc/resolv.conf` in VM.
- `authorized_keys`: override `/root/.ssh/authorized_keys` in VM.
- `dircolors`: override color mapping of the inside console.
- `profile`: addition `zsh` startup source script.
