`default_nettype none
`timescale 1ns / 1ps

module tb ();

    // 1. Declare signals
    reg [7:0] ui_in;
    reg [7:0] uio_in;
    wire [7:0] uo_out;
    wire [7:0] uio_out;
    wire [7:0] uio_oe;
    reg clk;
    reg rst_n;
    reg ena;

    // 2. Instantiate your ALU design
    tt_um_example dut (
        .ui_in  (ui_in),
        .uo_out (uo_out),
        .uio_in (uio_in),
        .uio_out(uio_out),
        .uio_oe (uio_oe),
        .ena    (ena),
        .clk    (clk),
        .rst_n  (rst_n)
    );

    // 3. Clock Generation (100MHz / 10ns period)
    always #5 clk = ~clk;

    // 4. Test Procedure
    initial begin
        // Initialize signals
        clk = 0;
        rst_n = 0; // Start in reset
        ena = 1;
        ui_in = 0;
        uio_in = 0;

        $display("Starting ALU Testbench with Assertions...");

        // --- Step A: Reset Test ---
        #20 rst_n = 1; // Release reset after 2 cycles
        #1; 
        assert (uo_out === 8'b0) else $error("FAIL: Reset did not clear output");

        // --- Step B: Test Addition (5 + 3) ---
        ui_in = 8'h35; uio_in = 8'b00;
        @(posedge clk); #1; 
        assert (uo_out == 8'd8) 
            $display("PASS: 5 + 3 = 8");
            else $error("FAIL: 5 + 3 expected 8, got %d", uo_out);

        // --- Step C: Test Subtraction (10 - 4) ---
        ui_in = 8'h4A; uio_in = 8'b01;
        @(posedge clk); #1;
        assert (uo_out == 8'd6) 
            $display("PASS: 10 - 4 = 6");
            else $error("FAIL: 10 - 4 expected 6, got %d", uo_out);

        // --- Step D: Test AND (12 & 10) ---
        ui_in = 8'hAC; uio_in = 8'b10;
        @(posedge clk); #1;
        assert (uo_out == 8'd8) 
            $display("PASS: 12 AND 10 = 8");
            else $error("FAIL: AND failed. Got %d", uo_out);

        // --- Step E: Test OR (12 | 1) ---
        ui_in = 8'h1C; uio_in = 8'b11;
        @(posedge clk); #1;
        assert (uo_out == 8'd13) 
            $display("PASS: 12 OR 1 = 13");
            else $error("FAIL: OR failed. Got %d", uo_out);

        // --- Step F: Test XOR (5 ^ 3) ---
        // 5 (0101) XOR 3 (0011) = 6 (0110)
        ui_in = 8'h35; uio_in = 8'b100; // sel = 4
        @(posedge clk); #1;
        assert (uo_out == 8'd6) $display("PASS: 5 XOR 3 = 6");
        else $error("FAIL: XOR failed");

        // --- Step G: Test Left Shift (5 << 1) ---
        // 5 (0101) << 1 = 10 (1010)
        ui_in = 8'h05; uio_in = 8'b101; // sel = 5
        @(posedge clk); #1;
        assert (uo_out == 8'd10) $display("PASS: 5 << 1 = 10");
        else $error("FAIL: Left Shift failed");

        $display("All tests finished successfully!");
        $finish; 
    end

endmodule
