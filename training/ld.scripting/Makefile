CROSS_AS=arm-none-eabi-as 
CROSS_LD=arm-none-eabi-ld
CROSS_CC=arm-none-eabi-gcc
CROSS_OC=arm-none-eabi-objcopy


all:	file1.bin file11.bin

file1.elf:	file1.o file1.ld
	$(CROSS_LD) -T file1.ld -Map=file1.map -o file1.elf file1.o 

file1.bin:	file1.elf
	$(CROSS_OC) -O binary file1.elf file1.bin 

file11.elf:	file1.o file11.ld
	$(CROSS_LD) -T file11.ld -Map=file11.map -o file11.elf file1.o 

file11.bin:	file11.elf
	$(CROSS_OC) -O binary file11.elf file11.bin 

%.o:	%.s
		@echo "build the dependency: $< ..."
		$(CROSS_AS) -a=$(@:.o=.lst) -o $@ $<

clean:
		@echo "cleaning up ..."
		rm -vf *.lst *.map *.bin *.o *.bin *.elf




