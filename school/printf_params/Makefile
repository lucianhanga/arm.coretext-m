target	 = printf_params

sources  = $(target:=.s) # add here all the sources
listings = $(sources:.s=.lst)
objects  = $(sources:.s=.o)

target2	 = printf_params2

sources2  = $(target2:=.s) # add here all the sources
listings2 = $(sources2:.s=.lst)
objects2  = $(sources2:.s=.o)

all:	$(target) ${target2}

#------------------------------------
# eXtra stuff for this project only
#
extra:  printf_params.c.elf printf_params2.c.elf

printf_params.c.elf: printf_params.c
		gcc -S -fverbose-asm -O0 -o $(<:=.assembly) $<
		gcc -o $@ $<

printf_params2.c.elf: printf_params2.c
		gcc -S -fverbose-asm -O0 -o $(<:=.assembly) $<
		gcc -o $@ $<

xclean:
		@echo "eXtra clean ..."
		rm -vf *.elf *.assembly
#------------------------------------

# $@ - is the target
# $+ - is the dependencies list (or $^)
# $< - the first in the dependency list (source for target)

${target}:	$(objects)
		@echo "build the target: $@ ..."
		gcc -o $@ $+

${target2}:	$(objects2)
		@echo "build the target: $@ ..."
		gcc -o $@ $+

%.o:	%.s
		@echo "build the dependency: $< ..."
		as -a=$(@:.o=.lst) -o $@ $<

clean:  xclean
		@echo "cleaning up ..."
		rm -vf	$(listings) ${objects} ${target} \
				$(listings2) ${objects2} ${target2}

