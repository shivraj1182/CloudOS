# CloudOS 🚧

![Under Development](https://img.shields.io/badge/status-under%20development-orange)
![Assembly](https://img.shields.io/badge/language-Assembly-blue)
![License](https://img.shields.io/badge/license-MIT-green)

A minimal operating system kernel built from scratch - Under Active Development 🚧

## Overview

CloudOS is a basic x86 operating system written in Assembly. This project is designed for learning OS development fundamentals including bootloaders, kernel design, and low-level programming.

## Features (Current)

- ✅ Custom bootloader (16-bit real mode)
- ✅ Boot message display
- ✅ BIOS interrupt handling
- 🚧 Kernel initialization (in progress)
- 🚧 VGA text mode driver (planned)
- 🚧 Keyboard driver (planned)

## Project Structure

```
CloudOS/
├── boot/
│   └── boot.asm      # Bootloader code
├── build/            # Build output (generated)
├── Makefile          # Build system
├── README.md
└── LICENSE
```

## Prerequisites

To build and test CloudOS locally, you need:

- **NASM** (Netwide Assembler)
- **QEMU** (x86_64 emulator)
- **Make**

### Installation

**On Ubuntu/Debian:**
```bash
sudo apt-get update
sudo apt-get install nasm qemu-system-x86 make
```

**On macOS:**
```bash
brew install nasm qemu make
```

**On Windows:**
- Install [NASM](https://www.nasm.us/)
- Install [QEMU](https://www.qemu.org/download/)
- Use WSL or MinGW for make

## Building CloudOS

Clone the repository and build:

```bash
git clone https://github.com/shivraj1182/CloudOS.git
cd CloudOS
make
```

This will:
1. Assemble the bootloader (`boot/boot.asm`)
2. Create a bootable disk image (`build/cloudos.img`)

## Running CloudOS

To test the OS in QEMU:

```bash
make run
```

You should see the CloudOS bootloader message appear in the QEMU window.

## Cleaning Build Files

```bash
make clean
```

## Development Status

This project is in **early development**. Current focus:

- [x] Basic bootloader
- [ ] Protected mode transition
- [ ] Basic kernel entry point
- [ ] VGA text output
- [ ] Interrupt descriptor table (IDT)
- [ ] Keyboard input

## Learning Resources

If you're interested in OS development, check out:

- [OSDev Wiki](https://wiki.osdev.org/)
- [The Little Book About OS Development](https://littleosbook.github.io/)
- [Writing a Simple Operating System from Scratch](https://www.cs.bham.ac.uk/~exr/lectures/opsys/10_11/lectures/os-dev.pdf)

## Contributing

This is a learning project, but contributions and suggestions are welcome! Feel free to open issues or pull requests.

## License

MIT License - see [LICENSE](LICENSE) file for details.

## Author

**Shivraj Suman** - [GitHub](https://github.com/shivraj1182)

---

⚠️ **Note**: This OS is for educational purposes only and is not intended for production use.
