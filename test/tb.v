`default_nettype none
`timescale 1ns / 1ps

`define RED   "\033[31m"
`define GREEN "\033[32m"
`define RESET "\033[0m "

/* This testbench just instantiates the module and makes some convenient wires
   that can be driven / tested by the cocotb test.py.
*/
module tb ();

  // Dump the signals to a FST file. You can view it with gtkwave or surfer.
  initial begin
    $dumpfile("tb.fst");
    $dumpvars(0, tb);
    #1;
  end

  // Wire up the inputs and outputs:
  reg clk;
  reg rst_n;
  reg ena;
  reg [7:0] ui_in;
  reg [7:0] uio_in;
  wire [7:0] uo_out;
  wire [7:0] uio_out;
  wire [7:0] uio_oe;
`ifdef GL_TEST
  wire VPWR = 1'b1;
  wire VGND = 1'b0;
`endif

  // Replace tt_um_example with your module name:
  AddSubMultXOR user_project (

      // Include power ports for the Gate Level test:
`ifdef GL_TEST
      .VPWR(VPWR),
      .VGND(VGND),
`endif

      .ui_in  (ui_in),    // Dedicated inputs
      .uo_out (uo_out),   // Dedicated outputs
      .uio_in (uio_in),   // IOs: Input path
      .uio_out(uio_out),  // IOs: Output path
      .uio_oe (uio_oe),   // IOs: Enable path (active high: 0=input, 1=output)
      .ena    (ena),      // enable - goes high when design is selected
      .clk    (clk),      // clock
      .rst_n  (rst_n)     // not reset
  );

  initial clk = 1'b0;
  always #5 clk = ~clk; // 100 MHz

  reg [7:0] expected_output;
  reg [2:0] a, b;
  reg error_seen, tb_done, tb_fail;

  integer i;
  integer j;
 
  // task automatic apply_and_check;
  //   input [1:0] op;
  //   input [2:0] a;
  //   input [2:0] b;
  //   input [7:0] expected;
  //   begin
  //     ui_in = {op, b, a};   // [7:6]=op, [5:3]=b, [2:0]=a
  //     #1;                   // allow combinational settle
  //     if (uo_out !== expected) begin
  //       $display("FAIL t=%0t op=%b a=%0d b=%0d ui_in=%b got=%h expected=%h",
  //                $time, op, a, b, ui_in, uo_out, expected);
  //       $fatal;
  //     end else begin
  //       $display("PASS t=%0t op=%b a=%0d b=%0d result=%h",
  //                $time, op, a, b, uo_out);
  //     end
  //   end
  // endtask

  initial begin
    // Defaults
    ena    = 1'b1;
    rst_n  = 1'b0;
    ui_in  = 8'h00;
    uio_in = 8'h00;
    error_seen = 1'b0;
    tb_done = 1'b0;
    tb_fail = 1'b0;

    //reset test
    #20;
    rst_n = 1'b1;
    #10;

    // bidirectional pins unused test
    if (uio_out !== 8'h00 || uio_oe !== 8'h00) begin
      $display("\033[31mFAIL:\033[0mFAIL: uio_out/uio_oe not zero. uio_out=%h uio_oe=%h", uio_out, uio_oe);
    end

    // Add test: op=00, sweep a,b
    $display("\nADD TEST: op=00, sweep a,b");
    for (i = 0; i < 8; i = i + 1) begin
      for (j = 0; j < 8; j = j + 1) begin
        a = i[2:0];
        b = j[2:0];

        ui_in = {2'b00, b, a};       // op=00 add
        // $display("Testing a=%0d b=%0d ui_in=%b", a, b, ui_in);
        expected_output = {5'b00000, a} + {5'b00000, b};

        #1;
        if (uo_out !== expected_output) begin
          $display("\033[31mFAIL:\033[0mFAIL: a=%0d b=%0d ui_in=%b got=%h expected=%h t=%0t",
                   a, b, ui_in, uo_out, expected_output, $time);
          error_seen = 1'b1;
        end
        // $display("a=%0d + b=%0d; RESULT: %0d", a, b, uo_out);
      end
    end
    // $display("\033[32mPASS: \033[0m ALL ADD TESTS PASSED");


    // Sub test: op=00, sweep a,b
    $display("\nSUBTRACT TEST: op=01, sweep a,b");
    for (i = 0; i < 8; i = i + 1) begin
      for (j = 0; j < 8; j = j + 1) begin
        a = i[2:0];
        b = j[2:0];

        // $display("Testing a=%0d b=%0d ui_in=%b", a, b, ui_in);

        ui_in = {2'b01, b, a};       // op=00 add
        expected_output = {5'b00000, a} - {5'b00000, b};

        #1;
        if (uo_out !== expected_output) begin
          $display("\033[31mFAIL:\033[0mFAIL: a=%0d b=%0d ui_in=%b got=%h expected=%h t=%0t",
                   a, b, ui_in, uo_out, expected_output, $time);
          error_seen = 1'b1;
        end
        // $display("RESULT: %0d", uo_out);
      end
    end
    // $display("\033[32mPASS: \033[0m ALL SUB TESTS PASSED");

    // MULTIPLY test: op=10, sweep a,b
    $display("\nMULTIPLY TEST: op=10, sweep a,b");
    for (i = 0; i < 8; i = i + 1) begin
      for (j = 0; j < 8; j = j + 1) begin
        a = i[2:0];
        b = j[2:0];

        // $display("Testing a=%0d b=%0d ui_in=%b", a, b, ui_in);

        ui_in = {2'b10, b, a};       // op=00 add
        expected_output = {5'b00000, a} * {5'b00000, b};

        #1;
        if (uo_out !== expected_output) begin
          $display("\033[31mFAIL:\033[0mFAIL: a=%0d b=%0d ui_in=%b got=%h expected=%h t=%0t",
                   a, b, ui_in, uo_out, expected_output, $time);
          error_seen = 1'b1;
        end
        // $display("RESULT: %0d", uo_out);
      end
    end
    // $display("\033[32mPASS: \033[0m ALL MULTIPLY TESTS PASSED");

    // XOR test: op=11, sweep a,b
    $display("\nXOR TEST: op=11, sweep a,b");
    for (i = 0; i < 8; i = i + 1) begin
      for (j = 0; j < 8; j = j + 1) begin
        a = i[2:0];
        b = j[2:0];

        // $display("Testing a=%0d b=%0d ui_in=%b", a, b, ui_in);

        ui_in = {2'b11, b, a};       // op=00 add
        expected_output = {5'b00000, a} ^ {5'b00000, b};

        #1;
        if (uo_out !== expected_output) begin
          $display("\033[31mFAIL:\033[0mFAIL: a=%0d b=%0d ui_in=%b got=%h expected=%h t=%0t",
                   a, b, ui_in, uo_out, expected_output, $time);
          error_seen = 1'b1;
        end
        // $display("RESULT: %0d", uo_out);
      end
    end
    // $display("\033[32mPASS: \033[0m ALL XOR TESTS PASSED");

    #20;

    if (error_seen) begin
          $display("\n\033[31m---------ERRORS FOUND!---------\033[0m");
          tb_fail = 1'b1;
        end else begin
          $display("\n\033[32m---------ALL TESTS PASSED---------\033[0m");
          #20;
          tb_fail = 1'b0;
        end
        tb_done = 1'b1;

  end

endmodule
