ARCH = armv7-a
MCPU = cortex-a8

CC = arm-none-eabi-gcc
AS = arm-none-eabi-as
LD = arm-none-eabi-ld
OC = arm-none-eabi-objcopy

LINKER_SCRIPT = ./myRTOS.ld

ASM_SRCS = $(wildcard boot/*.S)
ASM_OBJS = $(patsubst boot/%.S, build/%.o, $(ASM_SRCS))

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

$(myRTOS) : $(ASM_OBJS) $(LINKER_SCRIPT)
	$(LD) -n -T $(LINKER_SCRIPT) -o $(myRTOS) $(ASM_OBJS)
	$(OC) -O binary $(myRTOS) $(myRTOS_bin)

build/%.o: boot/%.S 
	mkdir -p $(shell dirname $@)
	$(AS) -march=$(ARCH) -mcpu=$(MCPU) -g -o $@ $<