// ============================
// HDLBits - Combinational Logic
// Day 5 - 25 May 2026
// Q1 - RTL Mastery
// ============================

// ============================
// BASIC GATES
// ============================

// 1. Wire - constant output 0
module top_module (output out);
    assign out = 1'b0;
endmodule

// ============================
// 2. NOR gate
module top_module (input in1, input in2, output out);
    assign out = ~(in1 | in2);
endmodule

// ============================
// 3. Two gates - XNOR then XOR
module top_module (input in1, input in2, input in3, output out);
    assign out = ~(in1 ^ in2) ^ in3;
endmodule

// ============================
// 4. All 7 logic gates
module top_module(
    input a, b,
    output out_and, out_or, out_xor,
    output out_nand, out_nor, out_xnor, out_anotb
);
    assign out_and   = a & b;
    assign out_or    = a | b;
    assign out_xor   = a ^ b;
    assign out_nand  = ~(a & b);
    assign out_nor   = ~(a | b);
    assign out_xnor  = ~(a ^ b);
    assign out_anotb = a & ~b;
endmodule

// ============================
// 5. 7420 chip - two 4-input NAND gates
module top_module (
    input p1a, p1b, p1c, p1d, output p1y,
    input p2a, p2b, p2c, p2d, output p2y
);
    assign p1y = ~(p1a & p1b & p1c & p1d);
    assign p2y = ~(p2a & p2b & p2c & p2d);
endmodule

// ============================
// 6. Truth table - SOP form
module top_module(input x3, input x2, input x1, output f);
    assign f = (~x3 & x2 & ~x1) | (~x3 & x2 & x1) |
               (x3 & ~x2 & x1)  | (x3 & x2 & x1);
endmodule

// ============================
// 7. Two-bit equality
module top_module (input [1:0] A, input [1:0] B, output z);
    assign z = (A == B);
endmodule

// ============================
// 8. Combine circuits A and B
module top_module (input x, input y, output z);
    wire IA1, IB1, IA2, IB2;
    assign IA1 = x & y;
    assign IA2 = x & y;
    assign IB1 = x ^ y;
    assign IB2 = x ^ y;
    assign z = ~((IA1 | IB1) ^ (IA2 & IB2));
endmodule

// ============================
// 9. Ring or vibrate
module top_module (
    input ring, input vibrate_mode,
    output ringer, output motor
);
    assign motor  = ring & vibrate_mode;
    assign ringer = ring & ~vibrate_mode;
endmodule

// ============================
// 10. Thermostat
module top_module (
    input too_cold, input too_hot,
    input mode, input fan_on,
    output heater, output aircon, output fan
);
    assign heater = mode & too_cold;
    assign aircon = ~mode & too_hot;
    assign fan    = heater | aircon | fan_on;
endmodule

// ============================
// 11. 3-bit population count
module top_module(input [2:0] in, output [1:0] out);
    assign out = in[0] + in[1] + in[2];
endmodule

// ============================
// 12. Gates and vectors - 4bit
module top_module(
    input [3:0] in,
    output [2:0] out_both,
    output [3:1] out_any,
    output [3:0] out_different
);
    assign out_both      = in[2:0] & in[3:1];
    assign out_any       = in[3:1] | in[2:0];
    assign out_different = in[3:0] ^ {in[0], in[3:1]};
endmodule

// ============================
// 13. Gates and vectors - 100bit
module top_module(
    input [99:0] in,
    output [98:0] out_both,
    output [99:1] out_any,
    output [99:0] out_different
);
    assign out_both      = in[98:0] & in[99:1];
    assign out_any       = in[99:1] | in[98:0];
    assign out_different = in[99:0] ^ {in[0], in[99:1]};
endmodule

// ============================
// MULTIPLEXERS
// ============================

// 14. 2to1 mux 1-bit
module top_module(input a, b, sel, output out);
    assign out = sel ? b : a;
endmodule

// ============================
// 15. 2to1 mux 100-bit
module top_module(input [99:0] a, b, input sel, output [99:0] out);
    assign out = sel ? b : a;
endmodule

// ============================
// 16. 9to1 mux 16-bit
module top_module(
    input [15:0] a, b, c, d, e, f, g, h, i,
    input [3:0] sel, output reg [15:0] out
);
    always @(*) begin
        case(sel)
            4'd0: out = a;  4'd1: out = b;
            4'd2: out = c;  4'd3: out = d;
            4'd4: out = e;  4'd5: out = f;
            4'd6: out = g;  4'd7: out = h;
            4'd8: out = i;
            default: out = 16'hFFFF;
        endcase
    end
endmodule

// ============================
// 17. 256to1 mux 1-bit
module top_module(input [255:0] in, input [7:0] sel, output out);
    assign out = in[sel];
endmodule

// ============================
// 18. 256to1 mux 4-bit
module top_module(input [1023:0] in, input [7:0] sel, output [3:0] out);
    assign out = in[sel*4 +: 4];
endmodule

// ============================
// ARITHMETIC CIRCUITS
// ============================

// 19. Half adder
module top_module(input a, b, output cout, sum);
    assign sum  = a ^ b;
    assign cout = a & b;
endmodule

// ============================
// 20. Full adder
module top_module(input a, b, cin, output cout, sum);
    assign {cout, sum} = a + b + cin;
endmodule

// ============================
// 21. 3-bit ripple carry adder
module top_module(
    input [2:0] a, b, input cin,
    output [2:0] cout, output [2:0] sum
);
    assign {cout[0], sum[0]} = a[0] + b[0] + cin;
    assign {cout[1], sum[1]} = a[1] + b[1] + cout[0];
    assign {cout[2], sum[2]} = a[2] + b[2] + cout[1];
endmodule

// ============================
// 22. 4-bit adder
module top_module(input [3:0] x, input [3:0] y, output [4:0] sum);
    assign sum = x + y;
endmodule

// ============================
// 23. Signed overflow detection
module top_module(input [7:0] a, b, output [7:0] s, output overflow);
    assign s        = a + b;
    assign overflow = (a[7] == b[7]) && (s[7] != a[7]);
endmodule

// ============================
// 24. 100-bit adder
module top_module(
    input [99:0] a, b, input cin,
    output cout, output [99:0] sum
);
    assign {cout, sum} = a + b + cin;
endmodule

// ============================
// 25. 4-digit BCD adder
module top_module(
    input [15:0] a, b, input cin,
    output cout, output [15:0] sum
);
    wire c1, c2, c3;
    bcd_fadd d0(.a(a[3:0]),   .b(b[3:0]),   .cin(cin), .cout(c1),   .sum(sum[3:0]));
    bcd_fadd d1(.a(a[7:4]),   .b(b[7:4]),   .cin(c1),  .cout(c2),   .sum(sum[7:4]));
    bcd_fadd d2(.a(a[11:8]),  .b(b[11:8]),  .cin(c2),  .cout(c3),   .sum(sum[11:8]));
    bcd_fadd d3(.a(a[15:12]), .b(b[15:12]), .cin(c3),  .cout(cout), .sum(sum[15:12]));
endmodule

// ============================
// KARNAUGH MAPS
// ============================

// 26. 3-variable kmap
module top_module(input a, b, c, output out);
    assign out = a | b | c;
endmodule

// ============================
// 27. 4-variable kmap - XOR pattern
module top_module(input a, b, c, d, output out);
    assign out = a ^ b ^ c ^ d;
endmodule

// ============================
// 28. Kmap with don't cares
module top_module(input a, b, c, d, output out);
    assign out = a | (~b & c);
endmodule

// ============================
// 29. SOP and POS
module top_module(input a, b, c, d, output out_sop, output out_pos);
    assign out_sop = (c & d) | (~a & ~b & c);
    assign out_pos = (c & d) | (~a & ~b & c);
endmodule

// ============================
// 30. Kmap with don't cares - 4 input
module top_module(input [4:1] x, output f);
    assign f = (x[3] & ~x[1]) | (x[1] & x[2] & x[4]);
endmodule

// ============================
// 31. Mux-implemented kmap
module top_module(input c, d, output [3:0] mux_in);
    assign mux_in[0] = c | d;
    assign mux_in[1] = 1'b0;
    assign mux_in[2] = ~d;
    assign mux_in[3] = c & d;
endmodule
