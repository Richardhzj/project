CC = arm-none-eabi-gcc
SFLAGS = -g -O1 -mcpu=cortex-m0 -mthumb
AS = arm-none-eabi-as
AFLAGS = -g -mcpu=cortex-m0 -mthumb
LINK =   -g -mcpu=cortex-m0 -mthumb --specs=rdimon.specs -lc -lrdimon

export QEMU_AUDIO_DRV=wav
all: test.o t1.o HW1.elf
HW1.elf: test.o t1.o
	$(CC) $(LINK) -o HW1.elf test.o t1.o
test.o: test.c
	$(CC) $(SFLAGS) -c test.c
t1.o: t1.s
	$(CC) $(AFLAGS) -c t1.s
main.s: test.c
	$(CC) -c -s -g -Wa,-a,-ad -mcpu=cortex-m0 -mthumb test.c -o main.s
test : HW1.elf
	qemu-system-arm  -machine versatilepb -cpu cortex-m3 -nographic \
		-monitor null -serial null \
		-semihosting -kernel HW1.elf

clean:
	rm t1.o HW1.elf test.o
