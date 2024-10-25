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


