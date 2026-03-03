/*
 * Copyright (c) 2024 Your Name
 * SPDX-License-Identifier: Apache-2.0
 */

`default_nettype none

module tt_um_example (
    input  wire [7:0] ui_in,    // Dedicated inputs
    output reg [7:0] uo_out,   // Dedicated outputs
    input  wire [7:0] uio_in,   // IOs: Input path
    output wire [7:0] uio_out,  // IOs: Output path
    output wire [7:0] uio_oe,   // IOs: Enable path (active high: 0=input, 1=output)
    input  wire       ena,      // always 1 when the design is powered, so you can ignore it
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);

  // All output pins must be assigned. If not used, assign to 0.
  // assign uo_out  = ui_in + uio_in;  // Example: ou_out is the sum of ui_in and uio_in
  // assign uio_out = 0;
  // assign uio_oe  = 0;
  wire [3:0] a   = ui_in[3:0];     
  wire [3:0] b   = ui_in[7:4];     
  wire [1:0] sel = uio_in[1:0];

  always @(posedge clk) begin
    if (!rst_n) begin
        // Reset state: Clear the output when rst_n is 0
        uo_out <= 8'b0;
    end else begin
        // Perform calculation on the clock edge
        case (sel)
            2'b00: uo_out <= a + b;       // Addition
            2'b01: uo_out <= a - b;       // Subtraction
            2'b10: uo_out <= a & b;       // Bitwise AND
            2'b11: uo_out <= a | b;       // Bitwise OR
            default: uo_out <= 8'b0;
        endcase
    end
  end

  assign uio_out = 0;
  assign uio_oe  = 0;
  // List all unused inputs to prevent warnings
  wire _unused = &{ena, uio_in, 1'b0};

endmodule
