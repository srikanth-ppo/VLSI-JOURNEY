//=============================================================
// HDLBits Day 17 — Testbenches
// Tool: ModelSim | Language: SystemVerilog
//=============================================================

//-------------------------------------------------------------
// Problem 1: Clock Generation
// Instantiate dut, generate 10ps clock starting at 0
//-------------------------------------------------------------
module top_module ();

    reg clk;

    dut u_dut (
        .clk(clk)
    );

    initial clk = 0;
    always #5 clk = ~clk;

endmodule

//-------------------------------------------------------------
// Problem 2: Waveform Generation (A and B outputs)
// A: 0→1 at t=10, →0 at t=20
// B: 0→1 at t=15, →0 at t=40
//-------------------------------------------------------------
module top_module ( output reg A, output reg B );

    initial begin
        A = 0; B = 0;
        #10 A = 1;
        #5  B = 1;
        #5  A = 0;
        #20 B = 0;
    end

endmodule

//-------------------------------------------------------------
// Problem 3: AND Gate Testbench
// Tests all 4 input combinations: 00, 01, 10, 11
//-------------------------------------------------------------
module top_module ();

    reg  [1:0] in;
    wire       out;

    andgate dut (
        .in (in),
        .out(out)
    );

    initial begin
        in = 2'b00;
        #10 in = 2'b01;
        #10 in = 2'b10;
        #10 in = 2'b11;
    end

endmodule

//-------------------------------------------------------------
// Problem 4: q7 Module Testbench
// Drives clk, in, s[2:0] per waveform
//-------------------------------------------------------------
module top_module ();

    reg        clk, in;
    reg  [2:0] s;
    wire       out;

    q7 uut (
        .clk(clk),
        .in (in),
        .s  (s),
        .out(out)
    );

    initial begin
        clk = 1'b0;
        forever #5 clk = ~clk;
    end

    initial begin
        in = 1'b0; s = 3'd2;         // t=0
        #10        s = 3'd6;         // t=10
        #10 in = 1'b1; s = 3'd2;    // t=20
        #10 in = 1'b0; s = 3'd7;    // t=30
        #10 in = 1'b1; s = 3'd0;    // t=40
        #30 in = 1'b0;               // t=70
    end

endmodule

//-------------------------------------------------------------
// Problem 5: T Flip-Flop Testbench
// Reset TFF then toggle to q=1
//-------------------------------------------------------------
module top_module ();

    reg  clk, reset, t;
    wire q;

    tff dut (
        .clk  (clk),
        .reset(reset),
        .t    (t),
        .q    (q)
    );

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        reset = 1; t = 0;
        #10 reset = 0;
              t = 1;
    end

endmodule
