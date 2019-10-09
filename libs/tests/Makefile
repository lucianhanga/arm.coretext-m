objdir = obj
bindir = ../bin
libdir = ../lib

target1	= test-bubble-sort
sources1 = $(target1:=.s) # add here all the sources
objects1 := $(patsubst %.s,$(objdir)/%.o,$(sources1))
listings1 := $(patsubst %.s,$(objdir)/%.lst,$(sources1))

target2 = test-selection-sort
sources2 = $(target2:=.s) # add here all the sources
objects2 := $(patsubst %.s,$(objdir)/%.o,$(sources2))
listings2 := $(patsubst %.s,$(objdir)/%.lst,$(sources2))

target3 = test-vector-reverse
sources3 = $(target3:=.s) # add here all the sources
objects3 := $(patsubst %.s,$(objdir)/%.o,$(sources3))
listings3 := $(patsubst %.s,$(objdir)/%.lst,$(sources3))

all:	$(target1) $(target2) $(target3)

# $@ - is the target
# $+ - is the dependencies list (or $^)
# $< - the first in the dependency list (source for target)

$(target1):	$(objects1)
		@echo "objects: $(objects1) $(sources)" 
		mkdir -p $(bindir)
		@echo "build the target: $@ ..."
		gcc -o $(bindir)/$@ $+ $(libdir)/lh-sorting.a $(libdir)/lh-io.a

$(target2):	$(objects2)
		mkdir -p $(bindir)
		@echo "build the target: $@ ..."
		gcc -o $(bindir)/$@ $+ $(libdir)/lh-sorting.a $(libdir)/lh-io.a

$(target3):	$(objects3)
		mkdir -p $(bindir)
		@echo "build the target: $@ ..."
		gcc -o $(bindir)/$@ $+ $(libdir)/lh-io.a $(libdir)/lh-vector.a

$(objdir)/%.o:	%.s
		mkdir -p $(objdir)
		@echo "build the dependency: $< ..."
		as -a=$(@:.o=.lst) -o $@ $<

clean:
		@echo "cleaning up ..."
		rm -rf $(objdir) $(bindir)

