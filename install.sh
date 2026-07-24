#!/bin/sh
# Portty installer for macOS and Linux.
#
#   curl -fsSL https://raw.githubusercontent.com/mrtechnoo/portty/main/install.sh | sh
#
# Downloads the correct release archive for your OS/arch from GitHub, verifies it
# against the release SHA256SUMS, and installs `portty` + `portty-host`.
#
# Env overrides:
#   PORTTY_VERSION      e.g. v0.1.0 (default: latest release)
#   PORTTY_INSTALL_DIR  install location (default: /usr/local/bin if writable,
#                       else ~/.local/bin)
set -eu

REPO="mrtechnoo/portty"
RELEASES="https://github.com/$REPO/releases"

info() { printf '  %s\n' "$*"; }
err()  { printf 'error: %s\n' "$*" >&2; exit 1; }

command -v curl >/dev/null 2>&1 || err "curl is required"
command -v tar  >/dev/null 2>&1 || err "tar is required"

# ── Detect platform ────────────────────────────────────────────────────
os="$(uname -s)"
arch="$(uname -m)"
case "$os" in
  Darwin)
    case "$arch" in
      arm64|aarch64) target="aarch64-apple-darwin" ;;
      x86_64)        target="x86_64-apple-darwin" ;;
      *) err "unsupported macOS architecture: $arch" ;;
    esac ;;
  Linux)
    case "$arch" in
      x86_64)        target="x86_64-unknown-linux-gnu" ;;
      aarch64|arm64) target="aarch64-unknown-linux-gnu" ;;
      *) err "unsupported Linux architecture: $arch" ;;
    esac ;;
  *) err "unsupported OS: $os (on Windows use install.ps1)" ;;
esac

# ── Resolve version ────────────────────────────────────────────────────
version="${PORTTY_VERSION:-}"
if [ -z "$version" ]; then
  version="$(curl -fsSL "https://api.github.com/repos/$REPO/releases/latest" \
    | grep '"tag_name"' | head -n1 \
    | sed -n 's/.*"tag_name": *"\([^"]*\)".*/\1/p')"
  [ -n "$version" ] || err "could not determine the latest version (set PORTTY_VERSION)"
fi
case "$version" in v*) ;; *) version="v$version" ;; esac

name="portty-$version-$target"
url="$RELEASES/download/$version/$name.tar.gz"

# ── Download ───────────────────────────────────────────────────────────
tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT
info "downloading $name.tar.gz"
curl -fSL "$url" -o "$tmp/pkg.tar.gz" \
  || err "download failed ($url) — this platform may not be published yet"

# ── Verify checksum against the release SHA256SUMS ─────────────────────
if curl -fsSL "$RELEASES/download/$version/SHA256SUMS" -o "$tmp/SHA256SUMS" 2>/dev/null; then
  expected="$(grep " $name.tar.gz\$" "$tmp/SHA256SUMS" 2>/dev/null | awk '{print $1}')"
  if [ -n "$expected" ]; then
    if command -v sha256sum >/dev/null 2>&1; then
      actual="$(sha256sum "$tmp/pkg.tar.gz" | awk '{print $1}')"
    else
      actual="$(shasum -a 256 "$tmp/pkg.tar.gz" | awk '{print $1}')"
    fi
    [ "$expected" = "$actual" ] || err "checksum mismatch (expected $expected, got $actual)"
    info "checksum verified"
  fi
fi

# ── Install ────────────────────────────────────────────────────────────
tar -xzf "$tmp/pkg.tar.gz" -C "$tmp"

dir="${PORTTY_INSTALL_DIR:-}"
if [ -z "$dir" ]; then
  if [ -d /usr/local/bin ] && [ -w /usr/local/bin ]; then
    dir="/usr/local/bin"
  else
    dir="$HOME/.local/bin"
  fi
fi
mkdir -p "$dir"
install -m 0755 "$tmp/portty" "$dir/portty"
install -m 0755 "$tmp/portty-host" "$dir/portty-host"
info "installed portty + portty-host to $dir"

case ":$PATH:" in
  *":$dir:"*) ;;
  *) info "note: add $dir to your PATH -> export PATH=\"$dir:\$PATH\"" ;;
esac

"$dir/portty" --version 2>/dev/null || true
info "done. Run 'portty share' to get started."
