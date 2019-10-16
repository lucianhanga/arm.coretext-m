CROSS_AS=arm-none-eabi-as 
CROSS_LD=arm-none-eabi-ld
CROSS_CC=arm-none-eabi-gcc

target	 = file1

sources  = $(target:=.s) # add here all the sources
listings = $(sources:.s=.lst)
objects  = $(sources:.s=.o)

all:	$(target)

# $@ - is the target
# $+ - is the dependencies list (or $^)
# $< - the first in the dependency list (source for target)

${target}:	$(objects)
		@echo "build the target: $@ ..."
		$(CROSS_LD) -T$(@:=.ld) -Map=$(@:=.map) -o $@ $+

%.o:	%.s
		@echo "build the dependency: $< ..."
		$(CROSS_AS) -a=$(@:.o=.lst) -o $@ $<

clean:
		@echo "cleaning up ..."
		rm -vf $(listings) ${objects} ${target} *.map


