//=============================================================
// HDLBits Day 16 — Build a Circuit from a Simulation Waveform
// Combinational Circuit 6 + Sequential Circuits 7–10
// Tool: ModelSim | Language: SystemVerilog
//=============================================================

//-------------------------------------------------------------
// Problem 1: Combinational Circuit 6
// Circuit: 8x16 ROM / Lookup Table
//-------------------------------------------------------------
module comb_circuit6 (
    input  [2:0]      a,
    output reg [15:0] q );

    always @(*) begin
        case (a)
            3'd0: q = 16'h1232;
            3'd1: q = 16'haee0;
            3'd2: q = 16'h27d4;
            3'd3: q = 16'h5a0e;
            3'd4: q = 16'h2066;
            3'd5: q = 16'h64ce;
            3'd6: q = 16'hc526;
            3'd7: q = 16'h2f19;
            default: q = 16'hxxxx;
        endcase
    end

endmodule

//-------------------------------------------------------------
// Problem 2: Sequential Circuit 7
// Circuit: D flip-flop with inverted input
//-------------------------------------------------------------
module seq_circuit7 (
    input      clk,
    input      a,
    output reg q );

    always @(posedge clk) begin
        q <= ~a;
    end

endmodule

//-------------------------------------------------------------
// Problem 3: Sequential Circuit 8
// Circuit: Master-Slave D Flip-Flop
//-------------------------------------------------------------
module seq_circuit8 (
    input      clock,
    input      a,
    output reg p,
    output reg q );

    always @(*) begin
        if (clock)
            p = a;
    end

    always @(negedge clock) begin
        q <= p;
    end

endmodule

//-------------------------------------------------------------
// Problem 4: Sequential Circuit 9
// Circuit: Mod-7 counter with synchronous load to 4
//-------------------------------------------------------------
module seq_circuit9 (
    input            clk,
    input            a,
    output reg [3:0] q );

    always @(posedge clk) begin
        if (a)
            q <= 4'd4;
        else if (q == 4'd6)
            q <= 4'd0;
        else
            q <= q + 1'b1;
    end

endmodule

//-------------------------------------------------------------
// Problem 5: Sequential Circuit 10
// Circuit: Mealy machine — last agreement register
//-------------------------------------------------------------
module top_module (
    input      clk,
    input      a,
    input      b,
    output     q,
    output reg state );

    always @(posedge clk) begin
        if (a == b)
            state <= a;
    end

    assign q = state ? (a ~^ b) : (a ^ b);

endmodule
