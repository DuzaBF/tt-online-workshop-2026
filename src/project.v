/*
 * Copyright (c) 2024 Your Name
 * SPDX-License-Identifier: Apache-2.0
 */

`default_nettype none

module tt_um_duzabf_2026_ow (
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
  assign uio_out = 0;
  assign uio_oe  = 0;

  // List all unused inputs to prevent warnings
  wire _unused = &{found, ena, clk, rst_n, 1'b0};

  wire [7:0] count;
  wire [7:0] ascii;
  wire [6:0] segments;
  wire found;

  counter #(
      .WIDTH(8)
  ) i_counter (
      .clk(clk),
      .rst_n(rst_n),
      .en(1'b1),
      .reset_value(ui_in[7:0]),
      .count(count)
  );

  num2ascii i_num2ascii (
      .number(count[3:0]),
      .ascii (ascii)
  );

  ascii7seg i_ascii7seg (
      .ascii(ascii),
      .segments(segments),
      .found(found)
  );

  assign uo_out[6:0] = rst_n ? segments : {7'b0};
  assign uo_out[7]   = clk;

endmodule
