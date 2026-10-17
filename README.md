# STARTcloud Scripts

STARTcloud Scripts packages the operational shell scripts STARTcloud runs on its Debian and Proxmox hosts. The package installs them under `/opt/prominic/bin` and ships a cron template for each.

## Table of Contents

- [Scripts](#scripts)
- [Installation](#installation)
- [Usage](#usage)
- [Contributing](#contributing)
- [License](#license)

## Scripts

### Snapshoter.sh

A ksh script that takes a ZFS snapshot of a dataset from cron and keeps only a set number of them. Deletion is skipped while a scrub or resilver is running.

```text
Snapshoter.sh [options] [zfs path]

  -p <prefix>   prefix for the snapshot name, defaults to 'snapshot'
  -r            recurse, snapshot every child dataset
  -n #          number of snapshots to keep, 0 keeps all, defaults to 0
  -q            run any quiesce/unquiesce scripts found under the path before and after the snapshot
  -V            print the version and exit
  -h            print the help and exit
```

Snapshots are named `<zfs path>@<prefix>-YYYYMMDD-HHMM`. With `-r`, destroys recurse too.

Originally written by A. Hettinger for [prominic/OmniosScripts](https://github.com/prominic/OmniosScripts).

## Installation

### Production Installation (Debian Package)

1. **Download the latest release**:

   ```bash
   wget https://github.com/STARTcloud/startcloud-scripts/releases/latest/download/startcloud-scripts_VERSION_amd64.deb
   ```

2. **Install the package**:

   ```bash
   sudo gdebi -n startcloud-scripts_VERSION_amd64.deb
   ```

   The package depends on `ksh93u+m` and `zfsutils-linux`.

3. **Enable the schedules you want**:

   Uncomment the lines for the pools the host carries in `/etc/cron.d/snapshoter`. The file is a conffile, so upgrades keep your edits.

For detailed packaging and build instructions, see [packaging/README.md](packaging/README.md).

## Usage

Hourly snapshots of `Array-0/vms` and every child, keeping 24:

```bash
/opt/prominic/bin/Snapshoter.sh -p hourly -r -n 24 Array-0/vms
```

The installed cron template carries hourly (keep 24), daily (keep 8) and weekly (keep 5) lines for `Array-0/vms`, `Array-1/vms` and `Array-2/vms`.

## Contributing

Contributions are welcome! Please follow these steps:

1. Fork the repository.
2. Create a new branch (`git checkout -b feature/your-feature-name`).
3. Commit your changes (`git commit -m 'Add some feature'`).
4. Push to the branch (`git push origin feature/your-feature-name`).
5. Open a pull request.

## License

This project is licensed under the GPL-3.0 License. See the [LICENSE.md](LICENSE.md) file for details.
