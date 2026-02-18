# Raylib Assembly 3D Camera Demo

## Overview

This project is a minimal 64-bit ELF assembly application demonstrating integration with the **raylib** graphics library. It renders a 3D scene containing a cube, grid, and UI overlay while supporting free camera movement and keyboard interaction.

## Features

* Native x86-64 assembly implementation
* Direct calls to raylib C API
* Free camera controls
* Real-time rendering loop
* Keyboard input handling (Z resets camera target)
* Custom struct memory layout for `Camera3D`

## Video


https://github.com/user-attachments/assets/fd8334a0-ae44-475f-9d56-c95d4667eb6d




## Requirements

* Linux x86-64 system
* FASM (Flat Assembler)
* raylib installed and linkable
* GCC or LD for linking

## Build

Build with Makefile
Run the command: 

```bash
make
```

## Run

```bash
./game
```

## Controls

* Mouse wheel — zoom
* Mouse wheel press — pan
* Z — reset camera target

## Implementation Notes

* The program manually constructs the `Camera3D` struct in memory.
* Large structs are passed via stack copies to match C ABI expectations.
* Floating-point arguments are passed using XMM registers.
* Color values are stored as packed RGBA bytes.

## Purpose

This project demonstrates low-level graphics programming, ABI interoperability, and struct handling in assembly when calling high-level C libraries.

## License

MIT

