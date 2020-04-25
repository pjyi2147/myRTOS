ARCH = armv7-a
MCPU = cortex-a8

CC = arm-none-eabi-gcc
AS = arm-none-eabi-as
LD = arm-none-eabi-ld
OC = arm-none-eabi-objcopy

LINKER_SCRIPT = ./myRTOS.ld
MAP_FILE = build/myRTOS.map

ASM_SRCS = $(wildcard boot/*.S)
ASM_OBJS = $(patsubst boot/%.S, build/%.os, $(ASM_SRCS))

C_SRCS = $(wildcard boot/*.c)
C_OBJS = $(patsubst boot/%.c, build/%.o, $(C_SRCS))

INC_DIRS = include

myRTOS = build/myRTOS.axf
myRTOS_bin = build/myRTOS.bin

.PHONY: all clean run debug gdb

all: $(myRTOS)

clean:
	@rm -fr build

run: $(myRTOS)
	qemu-system-arm -M realview-pb-a8 -kernel $(myRTOS)

debug: $(myRTOS)
	qemu-system-arm -M realview-pb-a8 -kernel $(myRTOS) -S -gdb tcp::3333,ipv4

gdb:
	arm-none-eabi-gdb

$(myRTOS) : $(ASM_OBJS) $(C_OBJS) $(LINKER_SCRIPT)
	$(LD) -n -T $(LINKER_SCRIPT) -o $(myRTOS) $(ASM_OBJS) $(C_OBJS) -Map=$(MAP_FILE)
	$(OC) -O binary $(myRTOS) $(myRTOS_bin)

build/%.os: $(ASM_SRCS)
	mkdir -p $(shell dirname $@)
	$(CC) -march=$(ARCH) -mcpu=$(MCPU) -I $(INC_DIRS) -c -g -o $@ $<

build/%.o: $(C_SRCS)
	mkdir -p $(shell dirname $@)
	$(CC) -march=$(ARCH) -mcpu=$(MCPU) -I $(INC_DIRS) -c -g -o $@ $<