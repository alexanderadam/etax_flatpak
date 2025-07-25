#!/bin/sh
# Post-install script for eTax Zug Flatpak (extracts and installs the app from the downloaded zip)
set -e
cd "$FLATPAK_DEST"

# Unzip the downloaded archive (extra-data puts it in /var/run/flatpak/extra-data)
EXTRA_DATA_ZIP="/var/run/flatpak/extra-data/etax_installer.zip"
unzip -qo "$EXTRA_DATA_ZIP"
INSTALLER_SH=$(find . -maxdepth 1 -type f -name 'eTaxZGnP*_64bit.sh' | sort -Vr | head -n1)
chmod +x "$INSTALLER_SH"
"$INSTALLER_SH" --target ./etaxzug_inst --noexec
cp -r ./etaxzug_inst/* .
DESKTOP_FILE=$(find . -maxdepth 1 -type f -name '*.desktop' | sort -Vr | head -n1)
cp "$DESKTOP_FILE" ch.zg.etax.desktop
sed -i 's|Exec=.*|Exec=etaxzug|' ch.zg.etax.desktop
sed -i 's|Icon=.*|Icon=ch.zg.etax|' ch.zg.etax.desktop
# Ensure required desktop fields
if ! grep -q '^Type=' ch.zg.etax.desktop; then echo 'Type=Application' >> ch.zg.etax.desktop; fi
if ! grep -q '^Categories=' ch.zg.etax.desktop; then echo 'Categories=Office;' >> ch.zg.etax.desktop; fi
# Install desktop file to /app/share/applications
install -Dm644 ch.zg.etax.desktop /app/share/applications/ch.zg.etax.desktop
cp /app/flatpak/ch.zg.etax.png ch.zg.etax.png
install -Dm755 etaxzug.sh etaxzug
rm -rf etaxzug_inst "$INSTALLER_SH"
