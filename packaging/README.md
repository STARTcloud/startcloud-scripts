# Building STARTcloud Scripts Debian Packages

Production-ready Debian package build process with automated CI/CD via Release Please.

## Prerequisites

```bash
sudo apt update
sudo apt install dpkg-dev gdebi-core
```

## Quick Build Commands

### 1. Create Package Structure

```bash
export VERSION=$(cat version.txt)
export PACKAGE_NAME="startcloud-scripts"
export ARCH="amd64"

mkdir -p "${PACKAGE_NAME}_${VERSION}_${ARCH}"/{opt/prominic/bin,etc/cron.d,DEBIAN}
```

### 2. Copy Files

```bash
cp src/Snapshoter.sh "${PACKAGE_NAME}_${VERSION}_${ARCH}/opt/prominic/bin/"
cp packaging/cron/snapshoter "${PACKAGE_NAME}_${VERSION}_${ARCH}/etc/cron.d/"
cp packaging/DEBIAN/conffiles "${PACKAGE_NAME}_${VERSION}_${ARCH}/DEBIAN/"
```

### 3. Generate Control File

```bash
cat > "${PACKAGE_NAME}_${VERSION}_${ARCH}/DEBIAN/control" << EOF
Package: startcloud-scripts
Version: ${VERSION}
Section: admin
Priority: optional
Architecture: ${ARCH}
Maintainer: Makr91 <makr91@users.noreply.github.com>
Depends: ksh93u+m, zfsutils-linux
Description: STARTcloud Scripts - ZFS snapshot rotation for Proxmox hosts
 Installs Snapshoter.sh, a ksh script that takes a ZFS snapshot from
 cron and keeps only a set number of them, with a cron.d template.
Homepage: https://github.com/STARTcloud/startcloud-scripts
EOF
```

### 4. Set Permissions

```bash
find "${PACKAGE_NAME}_${VERSION}_${ARCH}" -type d -exec chmod 755 {} \;
find "${PACKAGE_NAME}_${VERSION}_${ARCH}" -type f -exec chmod 644 {} \;
chmod 755 "${PACKAGE_NAME}_${VERSION}_${ARCH}/opt/prominic/bin"/*
```

### 5. Build & Install Package

```bash
dpkg-deb --build "${PACKAGE_NAME}_${VERSION}_${ARCH}" "${PACKAGE_NAME}_${VERSION}_${ARCH}.deb"

sudo gdebi -n "${PACKAGE_NAME}_${VERSION}_${ARCH}.deb"
```

## Critical Build Notes

### ⚠️ Required Files

- `src/Snapshoter.sh` into `opt/prominic/bin/`, mode 755
- `packaging/cron/snapshoter` into `etc/cron.d/`, mode 644, every line commented so a fresh install schedules nothing
- `packaging/DEBIAN/conffiles` naming `/etc/cron.d/snapshoter`, so dpkg keeps local edits across upgrades

### 📁 Cron Template

`/etc/cron.d/snapshoter` carries hourly (keep 24), daily (keep 8) and weekly (keep 5) lines for `Array-0/vms`, `Array-1/vms` and `Array-2/vms`. Uncomment the lines for the pools the host carries.

## Automated CI/CD

### Release Please Integration

Every push to main triggers Release Please:

1. **Creates release PR** with version bumps and changelog
2. **Merges PR** → triggers package build
3. **Creates GitHub release** with `.deb` package attached
4. **Uses semantic versioning** based on conventional commits

The version lives in `version.txt`.

### Manual Release Trigger

`release-please.yml` runs on every push to `main` and has no manual trigger. The package build can be re-run for an existing release tag:

```bash
gh workflow run prod-build.yml -f version=0.1.0 -f tag_name=v0.1.0
```

## Package Information

- **Scripts**: `/opt/prominic/bin/`
- **Cron template**: `/etc/cron.d/snapshoter`
- **Repository pool**: `pool/main/s/startcloud-scripts` on `debian.startcloud.com`

## Troubleshooting

### Common Errors

1. **`/usr/bin/ksh: not found`**
   - ❌ `ksh93u+m` not installed
   - ✅ Fix: `sudo apt install ksh93u+m`

2. **Snapshots are taken but never destroyed**
   - ❌ A scrub or resilver is running, or `-n` is 0
   - ✅ Fix: wait for `zpool status` to show the scan finished, or pass `-n` with the number to keep

### Uninstall

```bash
sudo apt remove startcloud-scripts

sudo apt purge startcloud-scripts
```
