# Pivot OS Image Generator (pivot-gen)

## Project Overview
`pivot-gen` is a tool for creating Pivot OS images, forked from the Raspberry Pi `pi-gen` project. It builds custom Debian-based operating system images (Raspbian for 32-bit, Debian for 64-bit) primarily targeting Raspberry Pi hardware.

### Architecture
The build process is modular and organized into **Stages**:
- **Stage 0**: Bootstrap a minimal filesystem using `debootstrap`.
- **Stage 1**: Configure boot files, system tweaks, and network basics.
- **Stage 2**: Lite system (Raspberry Pi OS Lite equivalent).
- **Stage 3**: Desktop system (X11, LXDE).
- **Stage 4**: Standard image with user documentation.
- **Stage 5**: Full image with extra development and office tools.
- **export-image**: Finalizes `.img` and compressed archives.
- **export-noobs**: Generates NOOBS-compatible bundles.

## Building and Running

### Prerequisites
- Debian-based OS (Post-2017) or Docker.
- Keyring: `debian-archive-keyring` (Required for arm64 host builds).
- Dependencies: `coreutils`, `quilt`, `parted`, `qemu-user-binfmt`, `debootstrap`, `zerofree`, `zip`, `dosfstools`, `e2fsprogs`, `libarchive-tools`, `libcap2-bin`, `grep`, `rsync`, `xz-utils`, `file`, `git`, `curl`, `bc`, `gpg`, `pigz`, `xxd`, `arch-test`, `bmap-tools`, `kmod`.

### Key Commands
- **Standard Build (Host)**:
  ```bash
  sudo ./build.sh
  ```
- **Docker Build (Recommended for non-Debian hosts)**:
  ```bash
  ./build-docker.sh
  ```
- **Fast Iteration (Docker)**:
  ```bash
  PRESERVE_CONTAINER=1 CONTINUE=1 ./build-docker.sh
  ```
- **Clean and Rebuild**:
  ```bash
  sudo CLEAN=1 ./build.sh
  ```
- **Custom Config**:
  ```bash
  sudo ./build.sh -c my_custom_config
  ```

### Configuration
Build settings are controlled via a `config` file in the root directory. Key variables include:
- `IMG_NAME`: Root name of the generated image.
- `ARCH`: Target architecture (`arm64` default, `armhf` for 32-bit).
- `RELEASE`: Debian release (e.g., `trixie`).
- `DEPLOY_COMPRESSION`: Compression format (`zip`, `gz`, `xz`, `none`).
- `ENABLE_SSH`: Set to `1` to enable SSH by default.

## Development Conventions

### Stage Structure
Each stage contains subdirectories named with a two-digit prefix (e.g., `00-packages`). The following file types control the build within each sub-stage:
- `00-packages`: List of standard packages to install via `apt-get`.
- `00-packages-nr`: Packages to install without recommended dependencies.
- `00-run.sh`: Shell script run on the host.
- `00-run-chroot.sh`: Shell script run inside the target image chroot.
- `00-debconf`: Pre-seed values for `debconf-set-selections`.
- `00-patches/`: Directory for `quilt` patches.

### Adding New Features
1. Create a new stage or add a sub-directory to an existing stage.
2. Use `00-packages` for simple installations.
3. Use `00-run-chroot.sh` for configuration changes inside the image.
4. If a stage should be skipped, add an empty `SKIP` file to its directory.
