ALL	= 	TitleScreen1.prg ChatGPT1.prg ChatGPT2.prg ChatGPT3.prg ChatGPT4.prg   
DASM    = 	~aycock/599.82/bin/dasm

all:		$(ALL)

A2Folder = AuraTheWizardsQuest-A2

# if this is passed as 1 then the files will be copient into the A1Folder with the correct permissions
# ensure your www/ and $(A1Folder)/ directories have the correct permissions 
FOR_EMULATOR ?= 0

TitleScreen1.prg:      TitleScreen1.s stub.s
		$(DASM) $< -o$@ -l$(<:.s=.lst)

ChatGPT1.prg:      ChatGPT1.s stub.s
		$(DASM) $< -o$@ -l$(<:.s=.lst)

ChatGPT2.prg:      ChatGPT2.s stub.s
		$(DASM) $< -o$@ -l$(<:.s=.lst)

ChatGPT3.prg:      ChatGPT3.s stub.s
		$(DASM) $< -o$@ -l$(<:.s=.lst)

ChatGPT4.prg:      ChatGPT4.s stub.s
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
