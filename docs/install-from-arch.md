# Installing paco from Arch Linux

paco is an opinionated Arch + Hyprland distribution. This guide covers
the manual install procedure from a stock Arch Linux ISO.

> **Future:** post-v1 paco will ship an `archinstall` profile so this
> manual click-through can be skipped. Until then, follow these steps.

## Prerequisites

- A 64-bit UEFI computer (BIOS-only systems are not supported)
- At least 20 GB free disk space
- At least 4 GB RAM
- An internet connection (wired or wireless)
- A USB stick (8 GB+)

## Step 1: Download the Arch Linux ISO

Get the latest Arch ISO from <https://archlinux.org/download/>.

## Step 2: Write the ISO to a USB stick

Use [balenaEtcher](https://etcher.balena.io/) (cross-platform, GUI) or
`dd` (Linux only):

```bash
sudo dd if=archlinux-x86_64.iso of=/dev/sdX bs=4M status=progress conv=fsync
```

Replace `sdX` with your USB device.

## Step 3: Boot from the USB stick

- Insert the USB and reboot
- Enter your BIOS / UEFI menu (usually F2, F10, F12, or Del)
- Disable Secure Boot
- Boot from the USB stick

## Step 4: Connect to a network

Wired ethernet usually just works. For wifi:

```bash
iwctl
[iwd]# device list
[iwd]# station <device> scan
[iwd]# station <device> get-networks
[iwd]# station <device> connect <SSID>
[iwd]# exit
```

## Step 5: Run archinstall

```bash
archinstall
```

Use these settings:

| Field | Value |
| --- | --- |
| Mirrors | Select your country |
| Partitioning | Default partitioning layout on chosen disk |
| Filesystem | **btrfs (default structure: yes + use compression)** |
| Encryption | **LUKS + Encryption password** (required) |
| Hostname | Your choice |
| Bootloader | **Limine** |
| Root password | Your choice |
| User account | Add a user with Superuser: Yes |
| Audio | **pipewire** |
| Network | **Use NetworkManager** (NOT "Copy ISO network config") |
| Timezone | Your choice |

> **Important:** btrfs + LUKS are required. paco's snapshot/rollback
> features depend on btrfs, and the autologin pattern relies on disk
> encryption gating physical access.

After review, kick off the install. Reboot when prompted.

## Step 6: Log in and bootstrap paco

After reboot, log in as your user. Then:

```bash
curl -fsSL https://raw.githubusercontent.com/fernandoaleman/paco/master/boot.sh | bash
```

The bootstrap will:

1. Clone the paco repo to `~/.local/share/paco`
2. Run preflight checks (disk, RAM, UEFI, btrfs, internet)
3. Prompt for git name + email for initial config
4. Install all packages (system + AUR) — 5–30 minutes
5. Wire up configs (zsh, ghostty, hyprland, theme system, etc.)
6. Set up SDDM + Plymouth + autologin
7. Show a summary of what was installed and what's next
8. Prompt to reboot

## Step 7: First boot

After the reboot, paco's first-run scripts will run:

- Welcome notification with key keybindings
- Wifi setup prompt (if no network is configured)
- Firewall enabled
- Initial GTK theme applied
- Battery monitor, DNS resolver, swayosd started

## Next steps

Once at the desktop, try:

- `Super + Space` — application launcher
- `paco --help` — list all paco commands
- `paco theme set <name>` — switch themes (`catppuccin-macchiato` is
  the default; see `paco theme list` for others)
- `paco webapp install <name> <url> <icon>` — install a web app as a
  desktop application
- `paco update` — keep paco and your system up to date

For testing alternate branches or forks, set `PACO_REPO` and `PACO_REF`
environment variables before running boot.sh:

```bash
PACO_REPO=yourfork/paco PACO_REF=mybranch curl -fsSL <boot.sh URL> | bash
```

## Known limitations

### Wired keyboard required at the LUKS passphrase prompt

The LUKS passphrase prompt runs from the initramfs, before the kernel
loads the Bluetooth subsystem and before `/var/lib/bluetooth/` (where
device pairings live) is accessible. **A wired USB keyboard is required
to enter your LUKS passphrase on every cold boot.**

After unlock, the rest of the session works normally with Bluetooth
peripherals: SDDM autologin lands you in Hyprland, `bluetooth.service`
is running, and paired devices reconnect automatically.

A post-v0.1.0 opt-in helper (`paco setup-bluetooth-luks`) will let
users who want to live without a wired keyboard at the LUKS prompt
bake their paired devices into initramfs — at the cost of a per-machine
setup ritual and a slightly larger boot attack surface. Until then,
keep a USB keyboard handy for unlocks.
