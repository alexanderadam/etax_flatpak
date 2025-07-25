# 🧾 eTax Zug Flatpak 🚀

**Production Ready**: This Flatpak package downloads and runs the official eTax Zug app in a sandboxed environment—no more tax-ing installations! For advanced packaging or yearly updates, see `flatpak/README-flatpak-advanced.md`.

This repository packages the official eTax Zug Java desktop application as a Flatpak for easy installation and sandboxing on Linux systems. Filing your taxes has never been so… contained! 🥳

## Features 🏆

- Downloads the official installer from [the canton Zug website](https://zg.ch/de/steuern-finanzen/steuern/natuerliche-personen/steuererklaerung-ausfuellen) (no shady business—just Swiss precision!)
- Runs the original installer (no funny business, except in this README)
- Sandboxed and isolated from the rest of your system (your other apps won't get "taxed")

## Quick Start - From Zero to Tax Hero 🏁

Install Flatpak (if not already installed)

```sh
sudo apt install flatpak # Debian/Ubuntu
# or
sudo dnf install flatpak # Fedora
```

### From Flatpak Remote

1. **Add the Flatpak repo:**

   ```sh
   flatpak remote-add --user --if-not-exists etaxzug https://alexanderadam.github.io/etax_flatpak/repo/
   ```

2. **(Optional) Import the GPG key:**

   Download the key:
   ```
   wget https://alexanderadam.github.io/etax_flatpak/repo/gpgkey
   flatpak remote-modify --gpg-import=repo/gpgkey etaxzug
   ```

3. **Install the app:**

   ```sh
   flatpak install --user etaxzug ch.zg.etax
   ```

4. **Run eTax Zug:**

   ```sh
   flatpak run ch.zg.etax
   ```

## 🔑 Repository Info

- **Repo URL:** https://alexanderadam.github.io/etax_flatpak/repo/
- **GPG Key:** See above or `.flatpakrepo` file.


### From Repository

#### 1️⃣ Clone the repository

```sh
git clone https://github.com/alexanderadam/etax_flatpak.git
cd etax_flatpak
```

#### 2️⃣ Build the Flatpak (it’s a taxing job, but someone’s gotta do it)

```sh
flatpak-builder --user --install --force-clean build-dir flatpak/ch.zg.etax.yaml
```

## Run eTax Zug (and relax, you’re in a sandbox 😎)

```sh
flatpak run ch.zg.etax
```

## How it works (extra-data) 🧙‍♂️

- [The Flatpak manifest uses `extra-data`](https://docs.flatpak.org/en/latest/module-sources.html#extra-data) to download the official eTax Zug installer zip at install time.
- A post-install script extracts the shell installer and installs the Java app and desktop file inside the Flatpak.

## Updating for a new year 🗓️

New year, new taxes! To update for a new tax year, just update the Flatpak manifest URL, SHA256, and filenames to match the new official eTax Zug release. See the Flatpak manifest and launcher script for details. For development and contribution, see `CONTRIBUTING.md`. (Don’t worry, it’s less work than your tax return!)

## Support & Troubleshooting 🛟

If you encounter issues, please [open an issue on GitHub](https://github.com/alexanderadam/etax_flatpak/issues). For advanced troubleshooting, see `flatpak/README-flatpak-advanced.md`.

## Repository Structure

- [`flatpak/`](flatpak/) — Contains all Flatpak-specific files:
    - [`ch.zg.etax.yaml`](flatpak/ch.zg.etax.yaml) — Main Flatpak manifest (YAML format).
    - [`ch.zg.etax.post-install.sh`](flatpak/ch.zg.etax.post-install.sh) — Post-install script for extracting and patching the app after download.
    - [`etaxzug.sh`](flatpak/etaxzug.sh) — Launcher script for the eTax Zug app inside the Flatpak sandbox.
    - [`README.md`](flatpak/README.md) — Flatpak usage and packaging notes.

- [`build-dir/`](build-dir/) — Temporary build output directory created by `flatpak-builder`. Not tracked in git.
    - [`files/`](build-dir/files/) — Contains staged files for the Flatpak build.
    - [`export/`](build-dir/export/) — Used for exported files during build.
    - [`metadata`](build-dir/metadata) — Flatpak metadata for the build.

- [`repo/`](repo/) — OSTree Flatpak repository. This is what gets published to GitHub Pages for user installation.
    - [`config`](repo/config), [`summary`](repo/summary), [`objects/`](repo/objects/), etc. — Standard OSTree repo structure.

- [`.github/workflows/`](.github/workflows/) — GitHub Actions CI/CD workflows for building and publishing the Flatpak repo.
    - [`flatpak.yml`](.github/workflows/flatpak.yml) — Main workflow for build and deploy.

- [`.flatpakrepo`](.flatpakrepo) — Metadata file for users to add the repo to Flatpak.

- [`build.sh`](build.sh) — Local build and export script for maintainers.

- [`README.md`](README.md) — Main documentation and user instructions.
- [`CONTRIBUTING.md`](CONTRIBUTING.md) — Contribution guidelines for maintainers.
- [`.gitignore`](.gitignore) — Excludes build artifacts, temp files, and other unnecessary files from git.

Other files and directories may be present for specific releases, tests, or local development. See the README for user instructions and this file for advanced packaging details.

## License 📜

This repo only packages [the official eTax Zug app](https://zg.ch/de/steuern-finanzen/steuern/natuerliche-personen/steuererklaerung-ausfuellen). All rights to the app remain with the canton Zug.
