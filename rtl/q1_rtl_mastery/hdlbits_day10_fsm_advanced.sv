// ============================
// HDLBits - Advanced FSMs
// Day 10 - 30 May 2026
// Q1 - RTL Mastery
// ============================

// 1. Lemmings 1 - walk left/right
module top_module(
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    output walk_left,
    output walk_right
);
    parameter LEFT=0, RIGHT=1;
    reg state, next_state;

    always @(*) begin
        case (state)
            LEFT:  next_state = bump_left  ? RIGHT : LEFT;
            RIGHT: next_state = bump_right ? LEFT  : RIGHT;
        endcase
    end

    always @(posedge clk or posedge areset) begin
        if (areset) state <= LEFT;
        else        state <= next_state;
    end

    assign walk_left  = (state == LEFT);
    assign walk_right = (state == RIGHT);
endmodule

// ============================
// 2. Lemmings 2 - walk + fall
module top_module(
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    input ground,
    output walk_left,
    output walk_right,
    output aaah
);
    parameter LEFT=2'd0, RIGHT=2'd1, FALL_L=2'd2, FALL_R=2'd3;
    reg [1:0] state, next_state;

    always @(*) begin
        case (state)
            LEFT:   next_state = ~ground   ? FALL_L :
                                 bump_left ? RIGHT  : LEFT;
            RIGHT:  next_state = ~ground    ? FALL_R :
                                 bump_right ? LEFT  : RIGHT;
            FALL_L: next_state = ground ? LEFT   : FALL_L;
            FALL_R: next_state = ground ? RIGHT  : FALL_R;
        endcase
    end

    always @(posedge clk or posedge areset) begin
        if (areset) state <= LEFT;
        else        state <= next_state;
    end

    assign walk_left  = (state == LEFT);
    assign walk_right = (state == RIGHT);
    assign aaah       = (state == FALL_L) | (state == FALL_R);
endmodule

// ============================
// 3. Lemmings 3 - walk + fall + dig
module top_module(
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    input ground,
    input dig,
    output walk_left,
    output walk_right,
    output aaah,
    output digging
);
    parameter LEFT=3'd0, RIGHT=3'd1,
              FALL_L=3'd2, FALL_R=3'd3,
              DIG_L=3'd4,  DIG_R=3'd5;
    reg [2:0] state, next_state;

    always @(*) begin
        case (state)
            LEFT:   next_state = ~ground   ? FALL_L :
                                  dig      ? DIG_L  :
                                  bump_left ? RIGHT  : LEFT;
            RIGHT:  next_state = ~ground    ? FALL_R :
                                  dig       ? DIG_R  :
                                  bump_right ? LEFT  : RIGHT;
            FALL_L: next_state = ground ? LEFT   : FALL_L;
            FALL_R: next_state = ground ? RIGHT  : FALL_R;
            DIG_L:  next_state = ~ground ? FALL_L : DIG_L;
            DIG_R:  next_state = ~ground ? FALL_R : DIG_R;
            default: next_state = LEFT;
        endcase
    end

    always @(posedge clk or posedge areset) begin
        if (areset) state <= LEFT;
        else        state <= next_state;
    end

    assign walk_left  = (state == LEFT);
    assign walk_right = (state == RIGHT);
    assign aaah       = (state == FALL_L) | (state == FALL_R);
    assign digging    = (state == DIG_L)  | (state == DIG_R);
endmodule

// ============================
// 4. Lemmings 4 - walk + fall + dig + splat
module top_module(
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    input ground,
    input dig,
    output walk_left,
    output walk_right,
    output aaah,
    output digging
);
    parameter LEFT=3'd0, RIGHT=3'd1,
              FALL_L=3'd2, FALL_R=3'd3,
              DIG_L=3'd4,  DIG_R=3'd5,
              SPLAT=3'd6;
    reg [2:0] state, next_state;
    reg [4:0] fall_count;

    always @(posedge clk or posedge areset) begin
        if (areset) fall_count <= 0;
        else if (state == FALL_L || state == FALL_R)
            fall_count <= (fall_count < 5'd21) ? fall_count + 1 : fall_count;
        else fall_count <= 0;
    end

    always @(*) begin
        case (state)
            LEFT:   next_state = ~ground    ? FALL_L :
                                  dig       ? DIG_L  :
                                  bump_left ? RIGHT  : LEFT;
            RIGHT:  next_state = ~ground     ? FALL_R :
                                  dig        ? DIG_R  :
                                  bump_right ? LEFT   : RIGHT;
            FALL_L: next_state = ground ? (fall_count >= 5'd20 ? SPLAT : LEFT)  : FALL_L;
            FALL_R: next_state = ground ? (fall_count >= 5'd20 ? SPLAT : RIGHT) : FALL_R;
            DIG_L:  next_state = ~ground ? FALL_L : DIG_L;
            DIG_R:  next_state = ~ground ? FALL_R : DIG_R;
            SPLAT:  next_state = SPLAT;
            default: next_state = LEFT;
        endcase
    end

    always @(posedge clk or posedge areset) begin
        if (areset) state <= LEFT;
        else        state <= next_state;
    end

    assign walk_left  = (state == LEFT);
    assign walk_right = (state == RIGHT);
    assign aaah       = (state == FALL_L) | (state == FALL_R);
    assign digging    = (state == DIG_L)  | (state == DIG_R);
endmodule

// ============================
// 5. One-hot FSM - 10 states by inspection
module top_module(
    input in,
    input [9:0] state,
    output [9:0] next_state,
    output out1,
    output out2
);
    assign next_state[0] = (state[0] & ~in) | (state[1] & ~in) |
                           (state[2] & ~in) | (state[3] & ~in) |
                           (state[4] & ~in) | (state[7] & ~in) |
                           (state[8] & ~in) | (state[9] & ~in);
    assign next_state[1] = (state[0] & in) | (state[8] & in) | (state[9] & in);
    assign next_state[2] = state[1] & in;
    assign next_state[3] = state[2] & in;
    assign next_state[4] = state[3] & in;
    assign next_state[5] = state[4] & in;
    assign next_state[6] = state[5] & in;
    assign next_state[7] = (state[6] & in) | (state[7] & in);
    assign next_state[8] = state[5] & ~in;
    assign next_state[9] = state[6] & ~in;
    assign out1 = state[8] | state[9];
    assign out2 = state[7] | state[9];
endmodule

// ============================
// 6. PS/2 packet parser
module top_module(
    input clk,
    input [7:0] in,
    input reset,
    output done
);
    parameter BYTE1=2'd0, BYTE2=2'd1, BYTE3=2'd2, DONE=2'd3;
    reg [1:0] state, next_state;

    always @(*) begin
        case (state)
            BYTE1: next_state = in[3] ? BYTE2 : BYTE1;
            BYTE2: next_state = BYTE3;
            BYTE3: next_state = DONE;
            DONE:  next_state = in[3] ? BYTE2 : BYTE1;
        endcase
    end

    always @(posedge clk) begin
        if (reset) state <= BYTE1;
        else       state <= next_state;
    end

    assign done = (state == DONE);
endmodule

// ============================
// 7. PS/2 packet parser with datapath
module top_module(
    input clk,
    input [7:0] in,
    input reset,
    output reg [23:0] out_bytes,
    output done
);
    parameter BYTE1=2'd0, BYTE2=2'd1, BYTE3=2'd2, DONE=2'd3;
    reg [1:0] state, next_state;

    always @(*) begin
        case (state)
            BYTE1: next_state = in[3] ? BYTE2 : BYTE1;
            BYTE2: next_state = BYTE3;
            BYTE3: next_state = DONE;
            DONE:  next_state = in[3] ? BYTE2 : BYTE1;
        endcase
    end

    always @(posedge clk) begin
        if (reset) state <= BYTE1;
        else       state <= next_state;
    end

    always @(posedge clk) begin
        case (next_state)
            BYTE2: out_bytes[23:16] <= in;
            BYTE3: out_bytes[15:8]  <= in;
            DONE:  out_bytes[7:0]   <= in;
        endcase
    end

    assign done = (state == DONE);
endmodule

// ============================
// 8. UART serial receiver FSM
module top_module(
    input clk,
    input in,
    input reset,
    output done
);
    parameter IDLE=4'd0, START=4'd1,
              D0=4'd2, D1=4'd3, D2=4'd4, D3=4'd5,
              D4=4'd6, D5=4'd7, D6=4'd8, D7=4'd9,
              STOP=4'd10, ERR=4'd11;
    reg [3:0] state, next_state;

    always @(*) begin
        case (state)
            IDLE:  next_state = in ? IDLE  : START;
            START: next_state = D0;
            D0:    next_state = D1;
            D1:    next_state = D2;
            D2:    next_state = D3;
            D3:    next_state = D4;
            D4:    next_state = D5;
            D5:    next_state = D6;
            D6:    next_state = D7;
            D7:    next_state = in ? STOP  : ERR;
            STOP:  next_state = in ? IDLE  : START;
            ERR:   next_state = in ? IDLE  : ERR;
            default: next_state = IDLE;
        endcase
    end

    always @(posedge clk) begin
        if (reset) state <= IDLE;
        else       state <= next_state;
    end

    assign done = (state == STOP);
endmodule

// ============================
// 9. UART serial receiver with datapath
module top_module(
    input clk,
    input in,
    input reset,
    output [7:0] out_byte,
    output done
);
    parameter START=4'd0, BIT0=4'd1, BIT1=4'd2, BIT2=4'd3,
              BIT3=4'd4, BIT4=4'd5, BIT5=4'd6, BIT6=4'd7,
              BIT7=4'd8, STOP=4'd9, NOT_STOP=4'd10, DONE=4'd11;
    reg [3:0] state, next_state;

    always @(*) begin
        case (state)
            START:    next_state = (~in) ? BIT0 : START;
            BIT0:     next_state = BIT1;
            BIT1:     next_state = BIT2;
            BIT2:     next_state = BIT3;
            BIT3:     next_state = BIT4;
            BIT4:     next_state = BIT5;
            BIT5:     next_state = BIT6;
            BIT6:     next_state = BIT7;
            BIT7:     next_state = STOP;
            STOP:     next_state = in ? DONE : NOT_STOP;
            NOT_STOP: next_state = in ? START : NOT_STOP;
            DONE:     next_state = (~in) ? BIT0 : START;
            default:  next_state = START;
        endcase
    end

    always @(posedge clk) begin
        if (reset) state <= START;
        else       state <= next_state;
    end

    always @(posedge clk) begin
        case (state)
            BIT0: out_byte[0] <= in;
            BIT1: out_byte[1] <= in;
            BIT2: out_byte[2] <= in;
            BIT3: out_byte[3] <= in;
            BIT4: out_byte[4] <= in;
            BIT5: out_byte[5] <= in;
            BIT6: out_byte[6] <= in;
            BIT7: out_byte[7] <= in;
        endcase
    end

    assign done = (state == DONE);
endmodule

// ============================
// 10. UART with parity checking
module top_module(
    input clk,
    input in,
    input reset,
    output [7:0] out_byte,
    output done
);
    parameter IDLE=4'd0, START=4'd1,
              D0=4'd2, D1=4'd3, D2=4'd4, D3=4'd5,
              D4=4'd6, D5=4'd7, D6=4'd8, D7=4'd9,
              PAR=4'd10, STOP=4'd11, ERR=4'd12;
    reg [3:0] state, next_state;
    wire odd;
    reg par_reset;

    always @(*) begin
        case (state)
            IDLE:  next_state = in ? IDLE  : START;
            START: next_state = D0;
            D0:    next_state = D1;
            D1:    next_state = D2;
            D2:    next_state = D3;
            D3:    next_state = D4;
            D4:    next_state = D5;
            D5:    next_state = D6;
            D6:    next_state = D7;
            D7:    next_state = PAR;
            PAR:   next_state = in ? STOP  : ERR;
            STOP:  next_state = in ? IDLE  : START;
            ERR:   next_state = in ? IDLE  : ERR;
            default: next_state = IDLE;
        endcase
    end

    always @(posedge clk) begin
        if (reset) state <= IDLE;
        else       state <= next_state;
    end

    always @(*) par_reset = (state == START);

    parity par_check (.clk(clk), .reset(reset | par_reset), .in(in), .odd(odd));

    reg [7:0] shreg;
    always @(posedge clk) begin
        if (state >= D0 && state <= D7)
            shreg <= {in, shreg[7:1]};
    end

    assign done     = (state == STOP) & odd;
    assign out_byte = shreg;
endmodule

// ============================
// 11. HDLC bit stuffing detector
module top_module(
    input clk,
    input reset,
    input in,
    output disc,
    output flag,
    output err
);
    parameter NONE=4'd0, ONE=4'd1, TWO=4'd2,
              THREE=4'd3, FOUR=4'd4, FIVE=4'd5,
              SIX=4'd6, ERROR=4'd7,
              DISCARD=4'd8, FLAG=4'd9;
    reg [3:0] state, next_state;

    always @(*) begin
        case (state)
            NONE:    next_state = in ? ONE     : NONE;
            ONE:     next_state = in ? TWO     : NONE;
            TWO:     next_state = in ? THREE   : NONE;
            THREE:   next_state = in ? FOUR    : NONE;
            FOUR:    next_state = in ? FIVE    : NONE;
            FIVE:    next_state = in ? SIX     : DISCARD;
            SIX:     next_state = in ? ERROR   : FLAG;
            ERROR:   next_state = in ? ERROR   : NONE;
            DISCARD: next_state = in ? ONE     : NONE;
            FLAG:    next_state = in ? ONE     : NONE;
            default: next_state = NONE;
        endcase
    end

    always @(posedge clk) begin
        if (reset) state <= NONE;
        else       state <= next_state;
    end

    assign disc = (state == DISCARD);
    assign flag = (state == FLAG);
    assign err  = (state == ERROR);
endmodule
