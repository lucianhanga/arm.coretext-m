objdir = obj
bindir = ../bin
libdir = ../lib

target	 = test-bubble-sort

sources  = $(target:=.s) # add here all the sources
#listings = $(sources:.s=.lst)
#objects  = $(sources:.s=.o)
objects  := $(patsubst %.s,$(objdir)/%.o,$(sources))
listings := $(patsubst %.s,$(objdir)/%.lst,$(sources))

all:	$(target)

# $@ - is the target
# $+ - is the dependencies list (or $^)
# $< - the first in the dependency list (source for target)

${target}:	$(objects)
		mkdir -p $(bindir)
		@echo "build the target: $@ ..."
		gcc -o $(bindir)/$@ $+ $(libdir)/lh-sorting.a $(libdir)/lh-io.a

$(objdir)/%.o:	%.s
		mkdir -p $(objdir)
		@echo "build the dependency: $< ..."
		as -a=$(@:.o=.lst) -o $@ $<

clean:
		@echo "cleaning up ..."
		rm -rf $(objdir) $(bindir)

