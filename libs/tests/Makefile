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

target4 = test-vector-compare
sources4 = $(target4:=.s) # add here all the sources
objects4 := $(patsubst %.s,$(objdir)/%.o,$(sources4))
listings4 := $(patsubst %.s,$(objdir)/%.lst,$(sources4))

target5 = test-insertion-sort
sources5 = $(target5:=.s) # add here all the sources
objects5 := $(patsubst %.s,$(objdir)/%.o,$(sources5))
listings5 := $(patsubst %.s,$(objdir)/%.lst,$(sources5))

target6 = test-vector-lsl
sources6 = $(target6:=.s) # add here all the sources
objects6 := $(patsubst %.s,$(objdir)/%.o,$(sources6))
listings6 := $(patsubst %.s,$(objdir)/%.lst,$(sources6))

target7 = test-vector-lsr
sources7 = $(target7:=.s) # add here all the sources
objects7 := $(patsubst %.s,$(objdir)/%.o,$(sources7))
listings7 := $(patsubst %.s,$(objdir)/%.lst,$(sources7))

target8 = test-vector-search
sources8 = $(target8:=.s) # add here all the sources
objects8 := $(patsubst %.s,$(objdir)/%.o,$(sources8))
listings8 := $(patsubst %.s,$(objdir)/%.lst,$(sources8))

target9 = test-vector-replace
sources9 = $(target9:=.s) # add here all the sources
objects9 := $(patsubst %.s,$(objdir)/%.o,$(sources9))
listings9 := $(patsubst %.s,$(objdir)/%.lst,$(sources9))

target10 = test-vector-average
sources10 = $(target10:=.s) # add here all the sources
objects10 := $(patsubst %.s,$(objdir)/%.o,$(sources10))
listings10 := $(patsubst %.s,$(objdir)/%.lst,$(sources10))

all:	$(target1) $(target2) $(target3) $(target4) $(target5) \
		$(target6) $(target7) $(target8) $(target9) $(target10)

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

$(target4):	$(objects4)
		mkdir -p $(bindir)
		@echo "build the target: $@ ..."
		gcc -o $(bindir)/$@ $+ $(libdir)/lh-io.a $(libdir)/lh-vector.a

$(target5):	$(objects5)
		mkdir -p $(bindir)
		@echo "build the target: $@ ..."
		gcc -o $(bindir)/$@ $+ $(libdir)/lh-sorting.a $(libdir)/lh-io.a

$(target6):	$(objects6)
		mkdir -p $(bindir)
		@echo "build the target: $@ ..."
		gcc -o $(bindir)/$@ $+ $(libdir)/lh-vector.a $(libdir)/lh-io.a

$(target7):	$(objects7)
		mkdir -p $(bindir)
		@echo "build the target: $@ ..."
		gcc -o $(bindir)/$@ $+ $(libdir)/lh-vector.a $(libdir)/lh-io.a

$(target8):	$(objects8)
		mkdir -p $(bindir)
		@echo "build the target: $@ ..."
		gcc -o $(bindir)/$@ $+ $(libdir)/lh-vector.a $(libdir)/lh-io.a

$(target9):	$(objects9)
		mkdir -p $(bindir)
		@echo "build the target: $@ ..."
		gcc -o $(bindir)/$@ $+ $(libdir)/lh-vector.a $(libdir)/lh-io.a

$(target10): $(objects10)
		mkdir -p $(bindir)
		@echo "build the target: $@ ..."
		gcc -o $(bindir)/$@ $+ $(libdir)/lh-vector.a $(libdir)/lh-io.a

$(objdir)/%.o:	%.s
		mkdir -p $(objdir)
		@echo "build the dependency: $< ..."
		as -a=$(@:.o=.lst) -o $@ $<

clean:
		@echo "cleaning up ..."
		rm -rf $(objdir) $(bindir)

