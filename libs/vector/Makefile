objdir = obj
bindir = ../bin
libdir = ../lib

library	 = lh-vector.a
sources	 = vector-revert.s

objects  := $(patsubst %.s,$(objdir)/%.o,$(sources))
listings := $(patsubst %.s,$(objdir)/%.lst,$(sources))

all:	$(library)
		@echo "build the library $<"

$(library):	$(objects)
		mkdir -p $(libdir)
		@echo "building the library $@ from $(objects)"
		ar rcs $(libdir)/$@ $(objects)

$(objdir)/%.o:	%.s
		mkdir -p $(objdir)
		@echo "build the dependency: $@ ..."
		as -a=$(@:.o=.lst) -o $@ $<

clean:
		@echo "cleaning up ..."
		rm -rf $(objdir) $(libdir)/$(library)

