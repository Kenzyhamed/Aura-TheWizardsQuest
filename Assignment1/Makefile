ALL	= 	PressKeyToStartGame.prg SoundEffects.prg TitleScreenMusic.prg TitleScreen.prg GemCollection.prg BackgroundColor.prg Border.prg LeftJandRightL.prg MovingPlatform.prg Platform.prg Jump.prg
DASM    = 	~aycock/599.82/bin/dasm

all:		$(ALL)

A1Folder = AuraTheWizardsQuest-A1

# if this is passed as 1 then the files will be copient into the A1Folder with the correct permissions
# ensure your www/ and $(A1Folder)/ directories have the correct permissions 
FOR_EMULATOR ?= 0

PressKeyToStartGame.prg:	PressKeyToStartGame.s stub.s
		$(DASM) $< -o$@ -l$(<:.s=.lst)

SoundEffects.prg:      SoundEffects.s stub.s
		$(DASM) $< -o$@ -l$(<:.s=.lst)
		
TitleScreenMusic.prg:      TitleScreenMusic.s stub.s
		$(DASM) $< -o$@ -l$(<:.s=.lst)

TitleScreen.prg:      TitleScreen.s stub.s
		$(DASM) $< -o$@ -l$(<:.s=.lst)

GemCollection.prg:      GemCollection.s stub.s
		$(DASM) $< -o$@ -l$(<:.s=.lst)

BackgroundColor.prg:      BackgroundColor.s stub.s
		$(DASM) $< -o$@ -l$(<:.s=.lst)

Border.prg:     Border.s stub.s
		$(DASM) $< -o$@ -l$(<:.s=.lst)

LeftJandRightL.prg:      GemCollection.s stub.s
		$(DASM) $< -o$@ -l$(<:.s=.lst)

MovingPlatform.prg:      MovingPlatform.s stub.s
		$(DASM) $< -o$@ -l$(<:.s=.lst)

Platform.prg:      Platform.s stub.s
		$(DASM) $< -o$@ -l$(<:.s=.lst)

Jump.prg:      Jump.s stub.s
		$(DASM) $< -o$@ -l$(<:.s=.lst)

# Handle conditional copying for emulator
ifeq ($(FOR_EMULATOR), 1)
post-build:
	for prg in $(ALL); do \
		cp $$prg ~/www/$(A1Folder)/$$prg; \
		chmod 644 ~/www/$(A1Folder)/$$prg; \
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