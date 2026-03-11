`default_nettype none
`timescale 1ns/1ps

module tb ();

    // DUT signals
    reg  [7:0] ui_in;
    reg  [7:0] uio_in;
    wire [7:0] uo_out;
    wire [7:0] uio_out;
    wire [7:0] uio_oe;

    reg clk;
    reg rst_n;
    reg ena;

    // Instantiate DUT
    tt_um_example dut (
        .ui_in(ui_in),
        .uo_out(uo_out),
        .uio_in(uio_in),
        .uio_out(uio_out),
        .uio_oe(uio_oe),
        .ena(ena),
        .clk(clk),
        .rst_n(rst_n)
    );

    // Clock generation (10ns period)
    always #5 clk = ~clk;

    initial begin
        $dumpfile("tb.fst");
        $dumpvars(0, tb);

        // Initial values
        clk = 0;
        rst_n = 0;
        ena = 1;
        ui_in = 0;
        uio_in = 0;

        $display("Starting ALU tests");

        // Release reset
        #20 rst_n = 1;

        // -------------------------
        // ADD 5 + 3 = 8
        // a = 5, b = 3
        // ui_in = {b,a}
        // -------------------------
        ui_in = {4'd3,4'd5};
        uio_in = 8'b00000000;
        @(posedge clk);
        #1;
        if (uo_out == 8'd8)
            $display("PASS: ADD");
        else
            $display("FAIL: ADD got %d", uo_out);

        // -------------------------
        // SUB 10 - 4 = 6
        // -------------------------
        ui_in = {4'd4,4'd10};
        uio_in = 8'b00000001;
        @(posedge clk);
        #1;
        if (uo_out == 8'd6)
            $display("PASS: SUB");
        else
            $display("FAIL: SUB got %d", uo_out);

        // -------------------------
        // AND 12 & 10 = 8
        // -------------------------
        ui_in = {4'd10,4'd12};
        uio_in = 8'b00000010;
        @(posedge clk);
        #1;
        if (uo_out == 8'd8)
            $display("PASS: AND");
        else
            $display("FAIL: AND got %d", uo_out);

        // -------------------------
        // OR 12 | 1 = 13
        // -------------------------
        ui_in = {4'd1,4'd12};
        uio_in = 8'b00000011;
        @(posedge clk);
        #1;
        if (uo_out == 8'd13)
            $display("PASS: OR");
        else
            $display("FAIL: OR got %d", uo_out);

        // -------------------------
        // XOR 5 ^ 3 = 6
        // -------------------------
        ui_in = {4'd3,4'd5};
        uio_in = 8'b00000100;
        @(posedge clk);
        #1;
        if (uo_out == 8'd6)
            $display("PASS: XOR");
        else
            $display("FAIL: XOR got %d", uo_out);

        // -------------------------
        // SHIFT 5 << 1 = 10
        // -------------------------
        ui_in = {4'd0,4'd5};
        uio_in = 8'b00000101;
        @(posedge clk);
        #1;
        if (uo_out == 8'd10)
            $display("PASS: SHIFT");
        else
            $display("FAIL: SHIFT got %d", uo_out);

        $display("All tests complete");
        #20;
        $finish;
    end

endmodule
