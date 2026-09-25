# Screenix

Professional screen recorder for Linux with smooth zoom effects, cursor tracking, and real-time compositing.

## Installation

### Quick Install (recommended)

```bash
curl -fsSL screenix.studio/install | sh
```

The installer auto-detects your distro and installs the right package (.deb, .rpm, AUR, or Nix flake).

### Manual Install

#### Ubuntu / Debian
Download the latest `.deb` from [Releases](https://github.com/mathisdev7/screenix-releases/releases) and install:
```bash
sudo dpkg -i Screenix_*_amd64.deb
```

#### Arch Linux
```bash
yay -S screenix-bin
```

#### NixOS (x86-64)
```bash
nix profile add github:mathisdev7/screenix-releases#screenix-bin
```

Update it with `nix profile upgrade --refresh screenix-bin`. The Nix flake packages the same published `.deb` binary; it does not include the private Screenix source code.

### Run

```bash
screenix-gui
```

## Requirements

- Linux (Wayland or X11)
- PipeWire (for Wayland screen capture)
- FFmpeg (bundled or system)

## Issues & Feedback

Found a bug or have a feature request? [Open an issue](https://github.com/mathisdev7/screenix-releases/issues).

## Links

- Website: [screenix.studio](https://screenix.studio)
- Contact: [screenix.studio/contact](https://screenix.studio/contact)
