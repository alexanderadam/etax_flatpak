# Flatpak Manifest for eTax Zug

This directory contains the Flatpak manifest for packaging the official eTax Zug Java desktop application.

## Manifest: `ch.zg.etax.yaml`

- Downloads the official installer zip from canton Zug website
- Extracts and runs the shell installer in a sandboxed build
- Installs the Java app and desktop entry into the Flatpak

## How to Build Locally

1. **Install Flatpak and flatpak-builder**
   ```sh
   sudo apt install flatpak flatpak-builder   # Debian/Ubuntu
   # or
   sudo dnf install flatpak flatpak-builder   # Fedora
   ```

2. **Build and install the Flatpak**
   ```sh
   flatpak-builder --user --install --force-clean build-dir ch.zg.etax.yaml
   ```

3. **Run the app**
   ```sh
   flatpak run ch.zg.etax
   ```

## Manifest Details

- **App ID:** `ch.zg.etax`
- **Runtime:** `org.freedesktop.Platform` (23.08)
- **SDK:** `org.freedesktop.Sdk`
- **Command:** `etaxzug` (the Java launcher script)
- **Desktop file:** `ch.zg.etax.desktop`
- **Icon:** `ch.zg.etax.png`


## Updating for a New Year

- Change the year and URLs in `ch.zg.etax.yaml`.
- Update the desktop file and icon names if needed.

## Troubleshooting

- If the installer fails, check the build logs for errors.

## Advanced Flatpak Packaging Notes

### How the Installer is Handled

- The official eTax Zug installer is a shell script inside a zip archive.
- The Flatpak manifest downloads the zip, extracts the shell script, and runs it with `--target ./etaxzug_inst --noexec` to extract files without running the full installer interactively.
- All files are copied into `/app` inside the Flatpak.

### Desktop Integration

- The `.desktop` file is renamed to `ch.zg.etax.desktop` and updated so the `Exec` line uses the Flatpak launcher script.
- The icon is renamed to `ch.zg.etax.png` for Flatpak.

### Java Runtime

- The app uses the system Java runtime provided by the Flatpak runtime (`org.freedesktop.Platform`).
- If the app requires a specific Java version, update the manifest to add a Java extension.

### Customizations

- The launcher script (`etaxzug.sh`) ensures the app is started with the correct working directory and arguments.
- You can patch the desktop file or icon as needed in the build commands.

### Updating for a New Year

- Change the year in the manifest, URLs, and file names.
- Test the installer extraction and app launch.

### Debugging

- Use `flatpak run --command=sh ch.zg.etax` to get a shell inside the sandbox for troubleshooting.
- Check `/app` for installed files and logs.

## License

This manifest only packages the official eTax Zug app. All rights to the app remain with the canton Zug.
