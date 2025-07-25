# Contributing to eTax Zug Flatpak

Thank you for your interest in contributing!

## How to Contribute

- **Bug Reports:** Please open an issue with detailed steps to reproduce.
- **Feature Requests:** Open an issue describing your idea.
- **Pull Requests:**
  1. Fork the repository
  2. Create a new branch for your change
  3. Make your changes (see below for guidelines)
  4. Test your changes locally with `flatpak-builder`
  5. Open a pull request

## Guidelines

- Keep the Flatpak manifest (`flatpak/ch.zg.etax.yaml`) up to date and well-commented.
- Test the build and app launch before submitting. I'm using `flatpak-builder --repo=repo --force-clean build-dir flatpak/ch.zg.etax.yaml && flatpak uninstall --user ch.zg.etax -y && flatpak install --user etax-local ch.zg.etax -y && flatpak run ch.zg.etax` to ensure everything works.
- If updating for a new year, update all relevant URLs and file names.

## Resources

- [Flatpak Documentation](https://docs.flatpak.org/en/latest/)
- [Flatpak Manifest Guide](https://docs.flatpak.org/en/latest/first-build.html)

## License

This repository only packages the official eTax Zug app. All rights to the app remain with the canton Zug.
