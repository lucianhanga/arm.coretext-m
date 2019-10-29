target	 = add-vars
target2  = add-loop
target3  = add-vector
target4  = mul-simm

sources  = $(target:=.s) # add here all the sources
listings = $(sources:.s=.lst)
objects  = $(sources:.s=.o)

sources2  = $(target2:=.s) # add here all the sources
listings2 = $(sources2:.s=.lst)
objects2  = $(sources2:.s=.o)

sources3  = $(target3:=.s) # add here all the sources
listings3 = $(sources3:.s=.lst)
objects3  = $(sources3:.s=.o)

sources4  = $(target4:=.s) # add here all the sources
listings4 = $(sources4:.s=.lst)
objects4  = $(sources4:.s=.o)

all:	$(target) $(target2) $(target3) $(target4)

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

${target4}:	$(objects4)
		@echo "build the target: $@ ..."
		gcc -o $@ $+

%.o:	%.s
		@echo "build the dependency: $< ..."
		as -a=$(@:.o=.lst) -o $@ $<

clean:
		@echo "cleaning up ..."
		rm -vf $(listings) ${objects} ${target} \
			$(listings2) ${objects2} ${target2} \
			$(listing3) ${object3} $(target3) \
			$(listing4) ${object4} $(target4)


