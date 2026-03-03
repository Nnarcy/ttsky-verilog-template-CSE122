/*
 * Copyright (c) 2024 Your Name
 * SPDX-License-Identifier: Apache-2.0
 */

`default_nettype none

module tt_um_example (
    input  wire [7:0] ui_in,    // Dedicated inputs
    output wire [7:0] uo_out,   // Dedicated outputs
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

  // List all unused inputs to prevent warnings
  // wire _unused = &{ena, clk, rst_n, 1'b0};

  wire [2:0] a  = ui_in[2:0];
  wire [2:0] b  = ui_in[5:3];
  wire [1:0] op = ui_in[7:6];

  wire [7:0] add_output = {5'b00000, a} + {5'b00000, b};
  wire [7:0] sub_output = {5'b00000, a} - {5'b00000, b};
  wire [7:0] mul_output = a * b;
  wire [7:0] xor_output = {5'b00000, (a ^ b)};

  reg [7:0] y;
  always @(*) begin 
    case (op)
      2'b00: y = add_output;
      2'b01: y = sub_output;
      2'b10: y = mul_output;
      2'b11: y = xor_output;
      default: y = 8'h00;
    endcase
  end

  assign uo_out = y;

  assign uio_out = 8'h00;
  assign uio_oe  = 8'h00;

  wire _unused = &{ena, clk, rst_n, uio_in, 1'b0};

endmodule
