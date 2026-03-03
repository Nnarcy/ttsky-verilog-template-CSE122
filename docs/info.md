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

The testbench created for this file consists of a verilog file which iterates through every possible input to the device and compares it with a model output to verify its behavior is correct. It achieves this by using nested for loops that go through all the inputs and check matches to verify the output. The possible inputs are i * j inputs with:
* i being possible inputs for A
* j being possible inputs for B

Because A and B are both 3 bits wide each:

* A possible numbers = 8
* B possible numbers = 8

Therefore i * j = 64. Nested loops do 64 iterations for each op input as a result. Because there are 4 possible op inputs there are 64 * 4 = 256 amount of tests run. This allows for a exhaustive and complete test of all possible desired outcomes, allowing for a confident, correct test. 

## Generative AI Use

Generative AI was used in this project to mainly ask if ideas were viable for the Tiny Tapeout as well as for basic syntax updates and keeping ideas clear. It additionally was used for providing guidance with unclear errors and cleaning up code to be sure that the design was comphrehensive. 
