//=============================================================
// HDLBits Day 15 — Build a Circuit from a Simulation Waveform
// Combinational Circuits 1-5
// Tool: ModelSim | Language: SystemVerilog
//=============================================================

//-------------------------------------------------------------
// Problem 1: Combinational Circuit 1
// Circuit: 2-input AND gate
// q = a & b
//-------------------------------------------------------------
module comb_circuit1 (
    input  a,
    input  b,
    output q );

    assign q = a & b;

endmodule

//-------------------------------------------------------------
// Problem 2: Combinational Circuit 2
// Circuit: 4-input XNOR (even parity checker)
// q = ~(a ^ b ^ c ^ d)
//-------------------------------------------------------------
module comb_circuit2 (
    input  a,
    input  b,
    input  c,
    input  d,
    output q );

    assign q = ~(a ^ b ^ c ^ d);

endmodule

//-------------------------------------------------------------
// Problem 3: Combinational Circuit 3
// Circuit: (a|b) & (c|d)
// q = 1 when at least one of {a,b}=1 AND at least one of {c,d}=1
//-------------------------------------------------------------
module comb_circuit3 (
    input  a,
    input  b,
    input  c,
    input  d,
    output q );

    assign q = (a | b) & (c | d);

endmodule

//-------------------------------------------------------------
// Problem 4: Combinational Circuit 4
// Circuit: 2-input OR gate on b and c
// q = b | c
//-------------------------------------------------------------
module comb_circuit4 (
    input  a,
    input  b,
    input  c,
    input  d,
    output q );

    assign q = b | c;

endmodule

//-------------------------------------------------------------
// Problem 5: Combinational Circuit 5
// Circuit: 4-to-1 MUX using c as 4-bit select
// c=0→b, c=1→e, c=2→a, c=3→d, default→4'hf
//-------------------------------------------------------------
module top_module (
    input  [3:0] a,
    input  [3:0] b,
    input  [3:0] c,
    input  [3:0] d,
    input  [3:0] e,
    output reg [3:0] q );

    always @(*) begin
        case (c)
            4'd0: q = b;
            4'd1: q = e;
            4'd2: q = a;
            4'd3: q = d;
            default: q = 4'hf;
        endcase
    end

endmodule
