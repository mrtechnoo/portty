# Portty

**Securely share a terminal with a paired phone** — and approve coding-agent
actions from your pocket. Portty is a small desktop command-line tool
(`portty` + `portty-host`) that mirrors a terminal to a paired iPhone or Android
device over an encrypted, peer-to-peer link.

This repository hosts the **official release binaries** for Portty — the
ready-to-run builds. Portty is **open source**: the source code is at
[corvuxmindware/portty](https://github.com/corvuxmindware/portty).

> **Free and open source** under the [Apache License 2.0](LICENSE.txt). See
> [License](#license) for details.

---

## Install

### Quick install (any platform)

**macOS / Linux**
```sh
curl -fsSL https://raw.githubusercontent.com/mrtechnoo/portty/main/install.sh | sh
```

**Windows (PowerShell)**
```powershell
irm https://raw.githubusercontent.com/mrtechnoo/portty/main/install.ps1 | iex
```

The script picks the right build for your OS/arch, verifies its checksum, and
installs `portty` + `portty-host`. Prefer a package manager? See below.

### Windows

**Scoop**
```powershell
scoop bucket add portty https://github.com/mrtechnoo/portty
scoop install portty
```

**WinGet**
```powershell
winget install CorvuxMindware.Portty
```

### macOS

**Homebrew** (Apple Silicon & Intel)
```sh
brew install mrtechnoo/tap/portty
```

### Linux

**Quick install** (recommended)
```sh
curl -fsSL https://raw.githubusercontent.com/mrtechnoo/portty/main/install.sh | sh
```

**Homebrew on Linux** _(coming soon)_
```sh
brew install mrtechnoo/tap/portty
```

**Direct download** — grab the Linux tarball from the
[latest release](https://github.com/mrtechnoo/portty/releases/latest), extract it,
and put `portty` and `portty-host` on your `PATH`:
```sh
tar -xzf portty-v0.1.3-x86_64-unknown-linux-gnu.tar.gz
sudo install portty portty-host /usr/local/bin/
```

### Any platform — direct download
Every release attaches per-platform archives plus a `SHA256SUMS` file. Download
the archive for your OS from the
[latest release](https://github.com/mrtechnoo/portty/releases/latest) and verify
it before use:
```sh
shasum -a 256 -c SHA256SUMS      # macOS / Linux
```
```powershell
Get-FileHash .\portty-v0.1.3-x86_64-pc-windows-msvc.zip -Algorithm SHA256   # Windows
```

**Supported platforms:** Windows (x64), macOS (Apple Silicon + Intel),
Linux (x64, glibc 2.34 or newer — e.g. Ubuntu 22.04+, Debian 12+).

---

## First run

Use the latest Portty phone app: v0.1.3 and older app builds cannot connect to
each other.

```sh
portty-host           # start the background host (pairing stays closed)
portty pair           # add a phone: shows a QR / ticket / six-word phrase, then waits
portty share          # wrap your shell and mirror it to the paired phone
portty agent claude   # chat with a coding agent; approvals sync to your phone
portty-host status    # is the background host running?
portty-host stop      # stop the background host
```

To pair, run `portty pair` and scan the QR (or paste the ticket) in the Portty
app. Both screens then show the same six-digit code: check that they match and
answer `y` in the `portty pair` terminal. There is no PIN. Pairing never opens
on its own — adding a phone is always an explicit action — and after the first
pairing your phone reconnects by itself.

---

## Security

- Terminal traffic is **end-to-end encrypted** between the host and the paired
  device. Pairing keys and paired-device data stay on your machine.
- No terminal contents pass through any relay.
- Report security issues to **security@corvuxmindware.com**.

## Support

- Questions and bug reports: open an issue on this repository.
- Portty is developed by **Corvux Mindware Private Limited**.

## License

Portty is licensed under the [Apache License 2.0](LICENSE.txt); see also
[NOTICE](NOTICE). The source code is at
[corvuxmindware/portty](https://github.com/corvuxmindware/portty). Bundled
third-party components keep their own licenses, listed in
`THIRD-PARTY-NOTICES.txt` inside each release archive.

Release archives for v0.1.2 and earlier still contain an older freeware license
(`LICENSE.txt`, also referred to at the top of `THIRD-PARTY-NOTICES.txt`). That
license has been replaced: Corvux Mindware licenses those releases under the
Apache License 2.0 as well. From v0.1.3 on, the archives include `LICENSE` and
`NOTICE` instead.
