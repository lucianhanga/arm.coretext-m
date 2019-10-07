target	 = comparations
target2  = branches

sources  = $(target:=.s) # add here all the sources
listings = $(sources:.s=.lst)
objects  = $(sources:.s=.o)

sources2  = $(target2:=.s) # add here all the sources
listings2 = $(sources2:.s=.lst)
objects2  = $(sources2:.s=.o)

all:	$(target) $(target2)

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

clean:
		@echo "cleaning up ..."
		rm -vf $(listings) ${objects} ${target} ${target2}

