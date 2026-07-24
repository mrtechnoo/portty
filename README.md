# Portty

**Securely share a terminal with a paired phone** — and approve coding-agent
actions from your pocket. Portty is a small desktop command-line tool
(`portty` + `portty-host`) that mirrors a terminal to a paired iPhone or Android
device over an encrypted, peer-to-peer link.

This repository hosts the **official release binaries** for Portty. The source is
maintained privately; the downloads here are the ready-to-run builds.

> **Free to install and use.** See [LICENSE.txt](LICENSE.txt).

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

**Homebrew on Linux**
```sh
brew install mrtechnoo/tap/portty
```

**Direct download** — grab the Linux tarball from the
[latest release](https://github.com/mrtechnoo/portty/releases/latest), extract it,
and put `portty` and `portty-host` on your `PATH`:
```sh
tar -xzf portty-v0.1.0-x86_64-unknown-linux-gnu.tar.gz
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
Get-FileHash .\portty-v0.1.0-x86_64-pc-windows-msvc.zip -Algorithm SHA256   # Windows
```

**Supported platforms:** Windows (x64), macOS (Apple Silicon + Intel),
Linux (x64).

---

## First run

```sh
portty share          # wrap your shell and mirror it to the paired phone
portty pair           # reopen the pairing QR / ticket / PIN
portty agent claude   # chat with a coding agent; approvals sync to your phone
portty-host status    # is the background host running?
portty-host stop      # stop the background host
```

Pair the phone app by scanning the QR (or entering the ticket + PIN). The host
daemon never starts on its own — sharing a terminal is always an explicit action,
and after the first pairing your phone reconnects by token with no PIN.

---

## Security

- Terminal traffic is **end-to-end encrypted** between the host and the paired
  device. Pairing keys and paired-device data stay on your machine.
- No terminal contents pass through any relay.
- Report security issues to **security@corvuxmindware.com**.

## Support

- Questions and bug reports: open an issue on this repository.
- Portty is developed by **Corvux Mindware Private Limited**.
