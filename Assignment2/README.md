## Manual compressing

For our manual compression process, we began by analyzing the code structure to identify recurring patterns that could be optimized for space. We specifically focused on sections with repeated elements, like the "hat" graphic, which initially took up a significant portion of memory. Instead of storing the entire hat shape, we condensed the data by storing each unique character, accompanied by a count of its repetitions. This allowed us to reproduce the pattern dynamically while eliminating redundant storage, thus conserving space.

Next, we applied a similar compression technique to color data. By storing color values with their respective counts, we avoided duplicating color sequences and simplified the code logic for rendering. Both of these adjustments led to a significant reduction in the overall size, bringing it down from 908 bytes to just 384 bytes.

## Our Attempt With Chat GPT

We tried using ChatGPT as our AI model to compress the code. Our first prompt was generic:

“Compress this code (pasted the code).”

ChatGPT replied with a compressed version of the code, but it removed our comments and left the core logic unchanged. While this reduced the size slightly, it was almost insignificant, going from 908 bytes to 900 bytes.

Next, we asked ChatGPT to "Compress it more."

It responded by claiming to have removed redundant code and streamlined the `if` loops to make the code more efficient. However, when we ran the code, we found that the three colors we were using in 
our title screen were incorrect, and five characters were not what we expected, causing the hat in our design to look odd and incomplete.

We described this problem to ChatGPT and asked it to fix the colors:

“The colors are missing from the color2 and color3 arrays. Please fix these colors.”

It replied with a modified code that supposedly fixed the colors. However, upon running the code, we encountered an error. After investigating, we discovered that ChatGPT hadn’t properly indented three lines, which caused the code to fail to compile:

```
processor 6502
org $1001
include "stub.s"
```

After fixing the indentation ourselves, we compiled and ran the code again. The results were even worse: some of our letters were missing, and half of the hat was gone. It became clear that this code was beyond fixing, 
and further attempts to have ChatGPT repair it would likely make things worse. So, we decided to start from scratch in hopes of getting better results.

We asked ChatGPT to analyze the code and identify patterns to improve efficiency:

“Analyze this code and identify patterns to make it more efficient.”

Right away, it combined the three color strings to streamline the code and restructured it to accommodate the new color hex values. 
However, when we ran the new code, it was a complete mess. Only about 30% of the original characters were displayed, and the colors were incorrect. Some characters had a black background, making them invisible. 
We checked the size of the code to see if it was worth fixing—it was 526 bytes, significantly larger than what we had achieved manually. So, we decided not to pursue fixing it.

Still not ready to give up, we started over once again and broke the code down step by step. This time, we asked ChatGPT to just print out the characters in a 
compressed form, intending to handle the colors later. This would allow us to see if it was capable of simply printing the characters correctly.

This time, it forgot to include our stub file, which caused an error that we quickly fixed. After compiling, the screen was still a mess. While it correctly printed the game name and our names, the hat was again all over the place.

In another attempt, ChatGPT shrank down our message, resulting in our names getting messed up, and the hat—already problematic—became worse.

After spending about 7-8 hours over the span of 3 days, we ultimately decided to give up on ChatGPT for this task. It was clear that it 
would not be able to compress the code enough to surpass our manual efforts, and even if it did, the output would not match the original result, which was the goal of this assignment.

## Our Attempt With Exomizer

I downloaded Exomizer on my Windows laptop and used the WSL (Windows Subsystem for Linux) extension with Ubuntu to run the make command. After compiling, I created a .prg file for the title screen and ran various compression types on it, including level, raw, and mem. However, none of these worked as expected; they either returned syntax errors or produced no output. I then tried the sfx command, specifying the Vic-20 as the target, which successfully reduced the file size from 908 bytes to 603 bytes. I used the command:
./exomizer sfx sys -t 20 TitleScreen.prg -o TitleScreenExomizer.prg

I tried adding more arguments as well and to try to compress it more but the end result was the same
./exomizer sfx sys -t 20 -p 100 -c -m 4096 -M 256 TitleScreen.prg -0 TitleScreenExomizer2.prg


## Our Attempt With zx0-6502 Compressor/Decompressor -Kenzy

In the beginning I had some trouble with the linker, when running the MakerFile, my computer did not find a main function anywhere. However, after running it on a different computer it found the main file but for some reason it wanted an input file. So i went into the src file where all the compressor and desompressor C files were and ran "gcc -ozx0 compress.c memory.c optimize.c zx0.c" this compiled all the files. Next, I needed to make the bsave file. Another issue that arised was that on my computer it said that the TitleScreen.s file had a segmentation fault. But it worked fine on the ssh so i had go onto the ssh and change it into a prg file then download it on to my local drive. Now, I was able to run the file on the VIC-20 emulator and save it as a bsave. I first understood that i was meant to save where the data was stored, but after talking the professor I learned that i had to save the screen data. Now i was able to use 
that to run it on the C code to compress and decompress. This worked with no issues. But it should be noted that uploading the original bsave into the VIC-20 didnt give the title screen.


Next I had to make an assembler file that combined the decomcompressor instruction, the compressed code and stub.s. This took a lot of time because i had to read the decompressor instrution and find out what i had to jump to, to perform the decompress, also i had to understand how to run and display the file after. This took a long time since I neded to read  the manual and serach online, because i was beyond confused. Next i realized that I needed to edit the decompressor instruction because it wasnt compatible with dasm. There was no explanation of what the original instructions were compatible with but i did search up certain commands like equ and found that they were compatible with C64. So i translated it over to dasm. I remade  the final prg by running main.s (the assembler of the org) and below is what i got. In between all of these steps i did have issues with the memory saved in the bsave and had to experiment with the memory addresses to get it to work. I also had issues with the final prg file not displaying so i had to make it loop endlessely while still displaying the titlescreen-ish that i have below. Another issue i had with translating the decompressor instruction file wrong, and the main.s program was not working properly-so i had to change the addresses that it was saving the decompressed code to and how it was handling the stub file (i thought the stub file had to be loaded in like compressed data, instead of simply including it at the top). 

This was the result:

<img width="755" alt="Screenshot 2024-10-30 at 9 44 43 PM" src="https://github.com/user-attachments/assets/0cb5966b-1358-417a-897b-2dc7d3ef10ae">


