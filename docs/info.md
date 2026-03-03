<!---

This file is used to generate your project datasheet. Please fill in the information below and delete any unused
sections.

You can also include images in this folder and reference them in the markdown. Each image must be less than
512 kb in size, and the combined size of all images must be less than 1 MB.
-->

## How it works

This is a simple ALU device that has Addition, Subtraction, Multiplication and XOR comparison capability. Using the dedicated main inputs, the user can input two separate numbers that can be affected by the operation input. The dedicated input: ui_in, has 8 bits, with the first input, A using bits [0-2], B using bits [3-5], and op using bits [6-7]. A and B can be any number that is able to be represented within 3 bits, or digits 0-7, and op can be a combination of three patterns:
    * 00 activates ADDITION functionality
    * 01 activates SUBTRACTION functionality
    * 10 activates MULTIPLICATION functionality
    * 11 activates XOR functionality


## How to test

Filler

## Generative AI Use

List external hardware used in your project (e.g. PMOD, LED display, etc), if any
