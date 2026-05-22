// ============================
// HDLBits - Modules Section
// Day 2 - 22 May 2026
// Q1 - RTL Mastery
// ============================

// 1. Basic Module Instantiation - connect mod_a by name
module top_module ( input a, input b, output out );

    mod_a instance1 (
        .in1(a),
        .in2(b),
        .out(out)
    );

endmodule

// ============================
// 2. Module by Position - connect mod_a by port position
module top_module ( 
    input a, 
    input b, 
    input c,
    input d,
    output out1,
    output out2
);
    mod_a instance1 (out1, out2, a, b, c, d);

endmodule

// ============================
// 3. Module by Name - connect mod_a ports by name
module top_module ( 
    input a, 
    input b, 
    input c,
    input d,
    output out1,
    output out2
);
    mod_a instance1 (
        .out1(out1),
        .out2(out2),
        .in1(a),
        .in2(b),
        .in3(c),
        .in4(d)
    );

endmodule

// ============================
// 4. Shift Register - chain 3 DFFs together
module top_module ( input clk, input d, output q );

    wire w1, w2;

    my_dff dff1 (.clk(clk), .d(d),  .q(w1));
    my_dff dff2 (.clk(clk), .d(w1), .q(w2));
    my_dff dff3 (.clk(clk), .d(w2), .q(q));

endmodule

// ============================
// 5. 8-bit Shift Register with Mux - chain 3 x 8-bit DFFs + 4to1 mux
module top_module ( 
    input clk, 
    input [7:0] d, 
    input [1:0] sel, 
    output [7:0] q 
);
    wire [7:0] w1, w2, w3;

    my_dff8 dff1 (.clk(clk), .d(d),  .q(w1));
    my_dff8 dff2 (.clk(clk), .d(w1), .q(w2));
    my_dff8 dff3 (.clk(clk), .d(w2), .q(w3));

    always @(*) begin
        case(sel)
            2'b00: q = d;
            2'b01: q = w1;
            2'b10: q = w2;
            2'b11: q = w3;
        endcase
    end

endmodule

// ============================
// 6. 32-bit Adder - two 16-bit adders chained with carry
module top_module(
    input [31:0] a,
    input [31:0] b,
    output [31:0] sum
);
    wire carry;

    add16 lower (
        .a(a[15:0]),
        .b(b[15:0]),
        .cin(1'b0),
        .sum(sum[15:0]),
        .cout(carry)
    );

    add16 upper (
        .a(a[31:16]),
        .b(b[31:16]),
        .cin(carry),
        .sum(sum[31:16]),
        .cout()
    );

endmodule

// ============================
// 7. 32-bit Adder with Full Adder - 3 level hierarchy
module top_module (
    input [31:0] a,
    input [31:0] b,
    output [31:0] sum
);
    wire carry;

    add16 lower (
        .a(a[15:0]),
        .b(b[15:0]),
        .cin(1'b0),
        .sum(sum[15:0]),
        .cout(carry)
    );

    add16 upper (
        .a(a[31:16]),
        .b(b[31:16]),
        .cin(carry),
        .sum(sum[31:16]),
        .cout()
    );

endmodule

module add1 ( input a, input b, input cin, output sum, output cout );

    assign sum  = a ^ b ^ cin;
    assign cout = (a & b) | (cin & (a ^ b));

endmodule

// ============================
// 8. Carry Select Adder - two parallel upper adders + mux
module top_module(
    input [31:0] a,
    input [31:0] b,
    output [31:0] sum
);
    wire carry;
    wire [15:0] sum0, sum1;

    add16 lower (
        .a(a[15:0]),
        .b(b[15:0]),
        .cin(1'b0),
        .sum(sum[15:0]),
        .cout(carry)
    );

    add16 upper0 (
        .a(a[31:16]),
        .b(b[31:16]),
        .cin(1'b0),
        .sum(sum0),
        .cout()
    );

    add16 upper1 (
        .a(a[31:16]),
        .b(b[31:16]),
        .cin(1'b1),
        .sum(sum1),
        .cout()
    );

    assign sum[31:16] = carry ? sum1 : sum0;

endmodule

// ============================
// 9. Adder-Subtractor - add or subtract based on sub signal
module top_module(
    input [31:0] a,
    input [31:0] b,
    input sub,
    output [31:0] sum
);
    wire carry;
    wire [31:0] b_modified;

    assign b_modified = b ^ {32{sub}};

    add16 lower (
        .a(a[15:0]),
        .b(b_modified[15:0]),
        .cin(sub),
        .sum(sum[15:0]),
        .cout(carry)
    );

    add16 upper (
        .a(a[31:16]),
        .b(b_modified[31:16]),
        .cin(carry),
        .sum(sum[31:16]),
        .cout()
    );

endmodule
