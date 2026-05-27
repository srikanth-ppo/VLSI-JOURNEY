// ============================
// HDLBits - Counters Section
// Day 7 - 27 May 2026
// Q1 - RTL Mastery
// ============================

// 1. 4-bit binary counter (0-15)
module top_module (
    input clk,
    input reset,
    output reg [3:0] q
);
    always @(posedge clk) begin
        if (reset) q <= 4'b0;
        else       q <= q + 1;
    end
endmodule

// ============================
// 2. Decade counter (0-9)
module top_module (
    input clk,
    input reset,
    output reg [3:0] q
);
    always @(posedge clk) begin
        if (reset || q == 4'd9) q <= 4'b0;
        else                    q <= q + 1;
    end
endmodule

// ============================
// 3. Decade counter (1-10)
module top_module (
    input clk,
    input reset,
    output reg [3:0] q
);
    always @(posedge clk) begin
        if (reset || q == 4'd10) q <= 4'd1;
        else                     q <= q + 1;
    end
endmodule

// ============================
// 4. Decade counter with enable (slowena)
module top_module (
    input clk,
    input slowena,
    input reset,
    output reg [3:0] q
);
    always @(posedge clk) begin
        if (reset) q <= 4'b0;
        else if (slowena) begin
            if (q == 4'd9) q <= 4'b0;
            else           q <= q + 1;
        end
    end
endmodule

// ============================
// 5. 1-12 counter using count4 module
module top_module (
    input clk,
    input reset,
    input enable,
    output [3:0] Q,
    output c_enable,
    output c_load,
    output [3:0] c_d
);
    assign c_enable = enable;
    assign c_load   = reset | (enable & (Q == 4'd12));
    assign c_d      = 4'd1;

    count4 the_counter (clk, c_enable, c_load, c_d, Q);
endmodule

// ============================
// 6. 1Hz from 1000Hz - cascaded BCD counters
module top_module (
    input clk,
    input reset,
    output OneHertz,
    output [2:0] c_enable
);
    wire [3:0] Q0, Q1, Q2;

    assign c_enable[0] = 1'b1;
    assign c_enable[1] = (Q0 == 4'd9);
    assign c_enable[2] = (Q0 == 4'd9) & (Q1 == 4'd9);
    assign OneHertz    = (Q0 == 4'd9) & (Q1 == 4'd9) & (Q2 == 4'd9);

    bcdcount counter0 (clk, reset, c_enable[0], Q0);
    bcdcount counter1 (clk, reset, c_enable[1], Q1);
    bcdcount counter2 (clk, reset, c_enable[2], Q2);
endmodule

// ============================
// 7. 4-digit BCD counter (0000-9999)
module top_module (
    input clk,
    input reset,
    output [3:1] ena,
    output reg [15:0] q
);
    assign ena[1] = (q[3:0] == 4'd9);
    assign ena[2] = (q[3:0] == 4'd9) & (q[7:4] == 4'd9);
    assign ena[3] = (q[3:0] == 4'd9) & (q[7:4] == 4'd9) & (q[11:8] == 4'd9);

    always @(posedge clk) begin
        if (reset) q[3:0] <= 4'd0;
        else if (q[3:0] == 4'd9) q[3:0] <= 4'd0;
        else q[3:0] <= q[3:0] + 1;
    end

    always @(posedge clk) begin
        if (reset) q[7:4] <= 4'd0;
        else if (ena[1]) begin
            if (q[7:4] == 4'd9) q[7:4] <= 4'd0;
            else q[7:4] <= q[7:4] + 1;
        end
    end

    always @(posedge clk) begin
        if (reset) q[11:8] <= 4'd0;
        else if (ena[2]) begin
            if (q[11:8] == 4'd9) q[11:8] <= 4'd0;
            else q[11:8] <= q[11:8] + 1;
        end
    end

    always @(posedge clk) begin
        if (reset) q[15:12] <= 4'd0;
        else if (ena[3]) begin
            if (q[15:12] == 4'd9) q[15:12] <= 4'd0;
            else q[15:12] <= q[15:12] + 1;
        end
    end
endmodule

// ============================
// 8. 12-hour clock with AM/PM
module top_module(
    input clk,
    input reset,
    input ena,
    output reg pm,
    output reg [7:0] hh,
    output reg [7:0] mm,
    output reg [7:0] ss
);
    wire ss_roll = (ss[3:0] == 4'd9) & (ss[7:4] == 4'd5);
    wire mm_roll = ss_roll & (mm[3:0] == 4'd9) & (mm[7:4] == 4'd5);
    wire pm_flip = mm_roll & (hh[3:0] == 4'd1) & (hh[7:4] == 4'd1);

    always @(posedge clk) begin
        if (reset) ss <= 8'h00;
        else if (ena) begin
            if (ss[3:0] == 4'd9 && ss[7:4] == 4'd5) ss <= 8'h00;
            else if (ss[3:0] == 4'd9) begin
                ss[3:0] <= 4'd0;
                ss[7:4] <= ss[7:4] + 1;
            end else ss[3:0] <= ss[3:0] + 1;
        end
    end

    always @(posedge clk) begin
        if (reset) mm <= 8'h00;
        else if (ena & ss_roll) begin
            if (mm[3:0] == 4'd9 && mm[7:4] == 4'd5) mm <= 8'h00;
            else if (mm[3:0] == 4'd9) begin
                mm[3:0] <= 4'd0;
                mm[7:4] <= mm[7:4] + 1;
            end else mm[3:0] <= mm[3:0] + 1;
        end
    end

    always @(posedge clk) begin
        if (reset) hh <= 8'h12;
        else if (ena & mm_roll) begin
            if (hh == 8'h12) hh <= 8'h01;
            else if (hh[3:0] == 4'd9) begin
                hh[3:0] <= 4'd0;
                hh[7:4] <= hh[7:4] + 1;
            end else hh[3:0] <= hh[3:0] + 1;
        end
    end

    always @(posedge clk) begin
        if (reset)       pm <= 1'b0;
        else if (ena & pm_flip) pm <= ~pm;
    end
endmodule
