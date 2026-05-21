// ============================
// HDLBits - Vectors Section
// Day 1 - 21 May 2026
// Q1 - RTL Mastery
// ============================

// 1. Vector Splitting - split 3-bit vector into individual bits
module top_module(
    input [2:0] vec, 
    output [2:0] outv,
    output o2,
    output o1,
    output o0
);
    assign outv = vec;
    assign o0 = vec[0];
    assign o1 = vec[1];
    assign o2 = vec[2];
endmodule

// ============================
// 2. Vector Slicing - split 16-bit into two 8-bit halves
module top_module (
    input [15:0] in,
    output [7:0] out_hi,
    output [7:0] out_lo
);
    assign out_hi = in[15:8];
    assign out_lo = in[7:0];
endmodule

// ============================
// 3. Byte Reversal - reverse byte ordering of 32-bit word
module top_module (
    input [31:0] in,
    output [31:0] out
);
    assign out[31:24] = in[7:0];
    assign out[23:16] = in[15:8];
    assign out[15:8]  = in[23:16];
    assign out[7:0]   = in[31:24];
endmodule

// ============================
// 4. Bitwise vs Logical OR + NOT
module top_module(
    input [2:0] a, 
    input [2:0] b, 
    output [2:0] out_or_bitwise,
    output out_or_logical,
    output [5:0] out_not
);
    assign out_or_bitwise = a | b;    // bitwise - bit by bit
    assign out_or_logical = a || b;   // logical - true/false
    assign out_not[2:0]   = ~a;       // NOT a in lower half
    assign out_not[5:3]   = ~b;       // NOT b in upper half
endmodule

// ============================
// 5. Reduction Operators - 4-input AND, OR, XOR gates
module top_module( 
    input [3:0] in,
    output out_and,
    output out_or,
    output out_xor
);
    assign out_and = &in;    // reduction AND
    assign out_or  = |in;    // reduction OR
    assign out_xor = ^in;    // reduction XOR
endmodule

// ============================
// 6. Concatenation - combine 6x5-bit inputs into 4x8-bit outputs
module top_module (
    input [4:0] a, b, c, d, e, f,
    output [7:0] w, x, y, z
);
    assign {w, x, y, z} = {a, b, c, d, e, f, 2'b11};
endmodule

// ============================
// 7. Bit Reversal - reverse bit ordering of 8-bit vector
module top_module( 
    input [7:0] in,
    output [7:0] out
);
    assign out = {in[0], in[1], in[2], in[3], in[4], in[5], in[6], in[7]};
endmodule

// ============================
// 8. Sign Extension - extend 8-bit to 32-bit preserving sign
module top_module (
    input [7:0] in,
    output [31:0] out
);
    assign out = {{24{in[7]}}, in};
endmodule

// ============================
// 9. Pairwise Comparison - compare all 25 pairs of 5 inputs
module top_module (
    input a, b, c, d, e,
    output [24:0] out
);
    assign out = ~{{5{a}}, {5{b}}, {5{c}}, {5{d}}, {5{e}}} ^ 
                  {5{a, b, c, d, e}};
endmodule
