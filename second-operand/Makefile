target	 = second-operand

sources  = $(target:=.s) # add here all the sources
listings = $(sources:.s=.lst)
objects  = $(sources:.s=.o)

all:	$(target)

# $@ - is the target
# $+ - is the dependencies list (or $^)
# $< - the first in the dependency list (source for target)

${target}:	$(objects)
		@echo "build the target: $@ ..."
		gcc -o $@ $+

%.o:	%.s
		@echo "build the dependency: $< ..."
		as -a=$(@:.o=.lst) -o $@ $<

clean:
		@echo "cleaning up ..."
		rm -vf $(listings) ${objects} ${target}

