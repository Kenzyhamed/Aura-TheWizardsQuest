ALL	= 	TitleScreen1.prg 
DASM    = 	~aycock/599.82/bin/dasm

all:		$(ALL)

A2Folder = AuraTheWizardsQuest-A2

# if this is passed as 1 then the files will be copient into the A1Folder with the correct permissions
# ensure your www/ and $(A1Folder)/ directories have the correct permissions 
FOR_EMULATOR ?= 0

TitleScreen1.prg:      TitleScreen1.s stub.s
		$(DASM) $< -o$@ -l$(<:.s=.lst)


# Handle conditional copying for emulator
ifeq ($(FOR_EMULATOR), 1)
post-build:
	for prg in $(ALL); do \
		cp $$prg ~/www/$(A2Folder)/$$prg; \
		chmod 644 ~/www/$(A2Folder)/$$prg; \
	done
else
post-build:
	@echo "Skipping emulator copy"
endif

# Call the post-build step after all .prg files are built
.PHONY: post-build
all: post-build

clean:
	/bin/rm -f *~ *.lst $(ALL)
