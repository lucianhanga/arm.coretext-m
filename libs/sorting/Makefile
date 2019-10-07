sources	 = selection-sort.s bubble-sort.s
listings = $(sources:.s=.lst)
objects  = $(sources:.s=.o)

all:	$(objects)

%.o:	%.s
		@echo "build the dependency: $< ..."
		as -a=../obj/$(@:.o=.lst) -o ../obj/$@ $<

clean:
		@echo "cleaning up ..."
		rm -vf	../obj/*.o../obj/*.lst
		