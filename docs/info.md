<!---

This file is used to generate your project datasheet. Please fill in the information below and delete any unused
sections.

You can also include images in this folder and reference them in the markdown. Each image must be less than
512 kb in size, and the combined size of all images must be less than 1 MB.
-->

## How it works

This design is a 4-bit Synchronous Arithmetic Logic Unit. It takes two 4-bit numbers using sequential logic. Given an 8-bit input "ui_in", the bits are split in half as two 4-bit inputs known as operand A and operand B. "uino_in[1:0]" acts as the selector for the case statement. A clock is also used to store the output to "uo_out" on every positive clock edge. A reset is also inplemented to initialize the output to zero.

## How to test

A testbench is used to verify the design. Using the following commands allows you to run the testbench: 
iverilog -g2012 -o alu_sim src/project.v src/tb.v
vvp alu_sim
This testbench first tests the reset by setting rst_n to be low and check that the output is 0 using an assert. The functional tests cycle through each operation with provided inputs. All tests are verified using asserts and check the ouput on the posedge of the clock cycle.

## External hardware
None are required
List external hardware used in your project (e.g. PMOD, LED display, etc), if any
