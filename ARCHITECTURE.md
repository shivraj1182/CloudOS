# CloudOS Architecture

This document describes the architecture and design of CloudOS.

## Overview

CloudOS is a minimal operating system kernel built from scratch for x86 architecture. The project follows a modular design approach to facilitate learning and development.

## System Components

### 1. Bootloader (boot/boot.asm)
- **Location**: First sector of boot disk (0x7C00)
- **Mode**: 16-bit real mode
- **Responsibilities**:
  - Initialize system hardware
  - Clear screen and display boot messages
  - Load kernel into memory
  - Transfer control to kernel

### 2. Kernel (boot/kernel.asm)
- **Load Address**: 0x7E00 (configurable)
- **Mode**: Initially 16-bit, planned transition to protected mode
- **Features**:
  - Basic print functionality
  - System information display
  - Halt and loop mechanism

### 3. VGA Driver (boot/vga.asm)
- **Purpose**: Text mode display management
- **Features**:
  - Screen clearing
  - Character output
  - Cursor management
  - 16 color support

## Memory Map

```
0x0000 - 0x03FF : Interrupt Vector Table (IVT)
0x0400 - 0x04FF : BIOS Data Area
0x0500 - 0x7BFF : Free conventional memory
0x7C00 - 0x7DFF : Bootloader (512 bytes)
0x7E00 - 0x7FFF : Kernel entry point
0x8000+         : Kernel code and data
0xB8000         : VGA text mode buffer
```

## Development Roadmap

### Phase 1: Boot and Basic I/O (Current)
- [x] Simple bootloader
- [x] Boot signature
- [x] Basic screen output
- [x] VGA text mode driver
- [ ] Protected mode transition

### Phase 2: Kernel Foundation
- [ ] GDT (Global Descriptor Table) setup
- [ ] IDT (Interrupt Descriptor Table) setup
- [ ] Basic interrupt handling
- [ ] Keyboard driver

### Phase 3: Memory Management
- [ ] Physical memory manager
- [ ] Virtual memory (paging)
- [ ] Heap allocator

### Phase 4: Process Management
- [ ] Task switching
- [ ] Basic scheduler
- [ ] System calls

## Build System

CloudOS uses `make` as its build system with the following targets:

- `make` or `make all`: Build the OS image
- `make run`: Build and run in QEMU
- `make clean`: Remove build artifacts

## Testing

Automated testing is performed through GitHub Actions CI/CD:
- Syntax validation with NASM
- Boot test in QEMU
- Linting and code quality checks

## Contributing

See CONTRIBUTING.md for guidelines on contributing to CloudOS.

## References

- [OSDev Wiki](https://wiki.osdev.org/)
- [Intel® 64 and IA-32 Architectures Software Developer Manuals](https://software.intel.com/content/www/us/en/develop/articles/intel-sdm.html)
- [NASM Documentation](https://www.nasm.us/xdoc/2.15.05/html/nasmdoc0.html)
