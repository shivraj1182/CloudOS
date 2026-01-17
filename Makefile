# CloudOS Makefile
# Build system for the minimal OS

ASM = nasm
ASM_FLAGS = -f bin

BOOT_DIR = boot
BUILD_DIR = build

BOOT_BIN = $(BUILD_DIR)/boot.bin
OS_IMG = $(BUILD_DIR)/cloudos.img

.PHONY: all clean run

all: $(OS_IMG)

$(BUILD_DIR):
	mkdir -p $(BUILD_DIR)

$(BOOT_BIN): $(BOOT_DIR)/boot.asm | $(BUILD_DIR)
	$(ASM) $(ASM_FLAGS) $< -o $@

$(OS_IMG): $(BOOT_BIN)
	cp $(BOOT_BIN) $(OS_IMG)

run: $(OS_IMG)
	@echo "Starting CloudOS in QEMU..."
	qemu-system-x86_64 -drive format=raw,file=$(OS_IMG)

clean:
	rm -rf $(BUILD_DIR)
	@echo "Build directory cleaned."
