# Font Installer (macOS + Debian/MX/Ubuntu)

These are open source font that I like to use in my documents and that are used in the [TimothyElder/pandoc-teamplates](https://github.com/TimothyElder/pandoc-templates) and [latex-custom-te](https://github.com/TimothyElder/latex-custom-te) repos. A shell script is included to install them on macOS and you can run it with:

Install `.ttf`, `.otf`, `.ttc`, `.otc`, `.dfont` from a folder (recursively) to the correct system location.

## Usage

```bash
chmod +x install_fonts.sh
# Install fonts located alongside the script:
./install_fonts.sh

# Install from a specific folder:
./install_fonts.sh /path/to/my-fonts

# Overwrite existing:
./install_fonts.sh /path/to/my-fonts --force

# macOS system-wide (requires sudo):
./install_fonts.sh /path/to/my-fonts --system
```

## Windows

If you are using Windows, you are on your own regarding the installation, but [this page](https://support.microsoft.com/en-us/office/add-a-font-b7c5f17c-4426-4b53-967f-455339c564c1) should be helpful.

## What's Included?

The fonts available here are free to use and include: 

**Serif**
- [Cardo](https://fonts.google.com/specimen/Cardo)
- [Alegreya](https://fonts.google.com/specimen/Alegreya)
- [Joanna](https://en.wikipedia.org/wiki/Joanna_(typeface))
- [Latin Modern Roman](https://tug.org/FontCatalogue/latinmodernroman/)

**Sans Serif**
- [Noto Sans](https://fonts.google.com/noto/specimen/Noto+Sans)
- [Futura](https://en.wikipedia.org/wiki/Futura_(typeface))
- [FiraSans](https://fonts.google.com/specimen/Fira+Sans)

**Fixed Width**
- [Iosevka](https://en.wikipedia.org/wiki/Iosevka)