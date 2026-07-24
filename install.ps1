# Portty installer for Windows (PowerShell).
#
#   irm https://raw.githubusercontent.com/mrtechnoo/portty/main/install.ps1 | iex
#
# Downloads the Windows release archive from GitHub, verifies it against the
# release SHA256SUMS, installs portty.exe + portty-host.exe, and adds them to
# your user PATH.
#
# Env overrides:
#   $env:PORTTY_VERSION      e.g. v0.1.0 (default: latest release)
#   $env:PORTTY_INSTALL_DIR  install location (default: %LOCALAPPDATA%\Portty\bin)

$ErrorActionPreference = "Stop"
$repo = "mrtechnoo/portty"
$target = "x86_64-pc-windows-msvc"

# ── Resolve version ────────────────────────────────────────────────────
$version = $env:PORTTY_VERSION
if (-not $version) {
    $latest = Invoke-RestMethod "https://api.github.com/repos/$repo/releases/latest"
    $version = $latest.tag_name
}
if ($version -notmatch '^v') { $version = "v$version" }

$name = "portty-$version-$target"
$url  = "https://github.com/$repo/releases/download/$version/$name.zip"
$sums = "https://github.com/$repo/releases/download/$version/SHA256SUMS"

$tmp = Join-Path $env:TEMP ("portty-" + [guid]::NewGuid().ToString())
New-Item -ItemType Directory -Force -Path $tmp | Out-Null
$zip = Join-Path $tmp "pkg.zip"

Write-Host "  downloading $name.zip"
try {
    Invoke-WebRequest -Uri $url -OutFile $zip
} catch {
    throw "download failed ($url) - this platform may not be published yet"
}

# ── Verify checksum ────────────────────────────────────────────────────
try {
    $sumsText = (Invoke-WebRequest -Uri $sums).Content
    $line = ($sumsText -split "`n") | Where-Object { $_ -match [regex]::Escape("$name.zip") } | Select-Object -First 1
    if ($line) {
        $expected = ($line -split '\s+')[0].ToLower()
        $actual   = (Get-FileHash $zip -Algorithm SHA256).Hash.ToLower()
        if ($expected -ne $actual) { throw "checksum mismatch (expected $expected, got $actual)" }
        Write-Host "  checksum verified"
    }
} catch {
    Write-Warning "could not verify checksum: $_"
}

# ── Install ────────────────────────────────────────────────────────────
$dir = $env:PORTTY_INSTALL_DIR
if (-not $dir) { $dir = Join-Path $env:LOCALAPPDATA "Portty\bin" }
New-Item -ItemType Directory -Force -Path $dir | Out-Null
Expand-Archive -Path $zip -DestinationPath $tmp -Force
Copy-Item (Join-Path $tmp "portty.exe")      -Destination $dir -Force
Copy-Item (Join-Path $tmp "portty-host.exe") -Destination $dir -Force
Write-Host "  installed portty + portty-host to $dir"

# ── Add to user PATH ───────────────────────────────────────────────────
$userPath = [Environment]::GetEnvironmentVariable("Path", "User")
if (($userPath -split ';') -notcontains $dir) {
    [Environment]::SetEnvironmentVariable("Path", "$userPath;$dir", "User")
    Write-Host "  added $dir to your user PATH (restart the terminal to pick it up)"
}

& (Join-Path $dir "portty.exe") --version
Write-Host "  done. Run 'portty share' to get started."
