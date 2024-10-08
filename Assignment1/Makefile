ALL	= 	PressKeyToStartGame.prg SoundEffects.prg TitleScreenMusic.prg TitleScreen.prg GemCollection.prg BackgroundColor.prg Border.prg LeftJandRightL.prg
DASM    = 	~aycock/599.82/bin/dasm

all:		$(ALL)

A1Folder = AuraTheWizardsQuest-A1

PressKeyToStartGame.prg:	PressKeyToStartGame.s stub.s
		$(DASM) $< -o$@ -l$(<:.s=.lst)
		cp $@ ~/www/$(A1Folder)/PressKeyToStartGame.prg
		chmod 644 ~/www/$(A1Folder)/PressKeyToStartGame.prg 

SoundEffects.prg:      SoundEffects.s stub.s
		$(DASM) $< -o$@ -l$(<:.s=.lst)
		cp $@ ~/www/$(A1Folder)/SoundEffects.prg
		chmod 644 ~/www/$(A1Folder)/SoundEffects.prg

TitleScreenMusic.prg:      TitleScreenMusic.s stub.s
		$(DASM) $< -o$@ -l$(<:.s=.lst)
		cp $@ ~/www/$(A1Folder)/TitleScreenMusic.prg
		chmod 644 ~/www/$(A1Folder)/TitleScreenMusic.prg

TitleScreen.prg:      TitleScreen.s stub.s
		$(DASM) $< -o$@ -l$(<:.s=.lst)
		cp $@ ~/www/$(A1Folder)/TitleScreen.prg
		chmod 644 ~/www/$(A1Folder)/TitleScreen.prg

GemCollection.prg:      GemCollection.s stub.s
		$(DASM) $< -o$@ -l$(<:.s=.lst)
		cp $@ ~/www/$(A1Folder)/GemCollection.prg
		chmod 644 ~/www/$(A1Folder)/GemCollection.prg

BackgroundColor.prg:      BackgroundColor.s stub.s
		$(DASM) $< -o$@ -l$(<:.s=.lst)
		cp $@ ~/www/$(A1Folder)/BackgroundColor.prg
		chmod 644 ~/www/$(A1Folder)/BackgroundColor.prg

Border.prg:     Border.s stub.s
		$(DASM) $< -o$@ -l$(<:.s=.lst)
		cp $@ ~/www/$(A1Folder)/Border.prg
		chmod 644 ~/www/$(A1Folder)/Border.prg

LeftJandRightL.prg:      GemCollection.s stub.s
		$(DASM) $< -o$@ -l$(<:.s=.lst)
		cp $@ ~/www/$(A1Folder)/LeftJandRightL.prg
		chmod 644 ~/www/$(A1Folder)/LeftJandRightL.prg
