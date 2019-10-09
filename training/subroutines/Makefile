target	 = stack-parameters
target2	 = automatic-parameters
target3	 = recursive

sources  = $(target:=.s) # add here all the sources
listings = $(sources:.s=.lst)
objects  = $(sources:.s=.o)

sources2  = $(target2:=.s) # add here all the sources
listings2 = $(sources2:.s=.lst)
objects2  = $(sources2:.s=.o)

sources3  = $(target3:=.s) # add here all the sources
listings3 = $(sources3:.s=.lst)
objects3  = $(sources3:.s=.o)

all:	$(target) $(target2) $(target3)

# $@ - is the target
# $+ - is the dependencies list (or $^)
# $< - the first in the dependency list (source for target)

${target}:	$(objects)
		@echo "build the target: $@ ..."
		gcc -o $@ $+

${target2}:	$(objects2)
		@echo "build the target: $@ ..."
		gcc -o $@ $+

${target3}:	$(objects3)
		@echo "build the target: $@ ..."
		gcc -o $@ $+

%.o:	%.s
		@echo "build the dependency: $< ..."
		as -a=$(@:.o=.lst) -o $@ $<

clean:  
		@echo "cleaning up ..."
		rm -vf	$(listings) ${objects} ${target} \
				$(listings2) ${objects2} ${target2} \ 
				$(listings3) ${objects3} ${target3}
