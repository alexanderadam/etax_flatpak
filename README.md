# 🧾 eTax Zug Flatpak 🚀

This Flatpak package downloads and runs the official eTax Zug app in a sandboxed environment — no more tax-ing installations!

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
   flatpak remote-modify --no-gpg-verify etaxzug
   ```

2. **(Optional — also I still have to do this first 🤣) Import the GPG key:**

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
- **GPG Key:** See above or [`.flatpakrepo` file](.flatpakrepo).


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

If you encounter issues, please [open an issue on GitHub](https://github.com/alexanderadam/etax_flatpak/issues/new). For advanced troubleshooting, [see `flatpak/README.md`](flatpak/README.md).

## Repository Structure

- [`flatpak/`](flatpak/) — Contains all Flatpak-specific files:
    - [`ch.zg.etax.yaml`](flatpak/ch.zg.etax.yaml) — Main Flatpak manifest
    - [`ch.zg.etax.post-install.sh`](flatpak/ch.zg.etax.post-install.sh) — Post-install script for extracting the app after download.
    - [`etaxzug.sh`](flatpak/etaxzug.sh) — Launcher script for the eTax Zug app inside the Flatpak sandbox.
    - [`README.md`](flatpak/README.md) — Flatpak usage and packaging notes.
- [`repo/`](repo/) — Flatpak repository. This is what gets published to GitHub Pages for user installation.
    - [`config`](repo/config), [`summary`](repo/summary), [`objects/`](repo/objects/), etc. — Standard OSTree repo structure.
- [`.github/workflows/`](.github/workflows/) — GitHub Actions CI/CD workflows for building and publishing the Flatpak repo.
    - [`flatpak.yml`](.github/workflows/flatpak.yml) — Main workflow for build and deploy.
- [`.flatpakrepo`](.flatpakrepo) — Metadata file for users to add the repo to Flatpak.
- [`build.sh`](build.sh) — Local build and export script
- [`CONTRIBUTING.md`](CONTRIBUTING.md) — Contribution guidelines

Other files and directories may be present for specific releases, tests, or local development. See the README for user instructions and this file for advanced packaging details.

## License 📜

This repo only packages [the official eTax Zug app](https://zg.ch/de/steuern-finanzen/steuern/natuerliche-personen/steuererklaerung-ausfuellen). All rights to the app remain with the canton Zug.
