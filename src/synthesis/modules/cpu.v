module cpu #(
    parameter ADDR_WIDTH = 6,
    parameter DATA_WIDTH = 16
) (
    input clk,
    input rst_n,
    input [DATA_WIDTH-1:0] mem,
    input [DATA_WIDTH-1:0] in,
    input control,
    output reg status = 0,
    output reg we = 0,
    output [ADDR_WIDTH-1:0] addr,
    output [DATA_WIDTH-1:0] data,
    output reg [DATA_WIDTH-1:0] out = 0,
    output [ADDR_WIDTH-1:0] pc,
    output [ADDR_WIDTH-1:0] sp
);


// Program Counter (PC)

reg pc_cl = 0;
reg pc_ld = 0;
reg [ADDR_WIDTH-1:0] pc_in = 0;
reg pc_inc = 0;
reg pc_dec = 0;
reg pc_sr = 0;
reg pc_ir = 0;
reg pc_sl = 0;
reg pc_il = 0;
wire [ADDR_WIDTH-1:0] pc_out;

register #(
    .DATA_WIDTH(ADDR_WIDTH),
    .INIT_VALUE(8)
) pc_inst (
    .clk(clk),
    .rst_n(rst_n),
    .cl(pc_cl),
    .ld(pc_ld),
    .in(pc_in),
    .inc(pc_inc),
    .dec(pc_dec),
    .sr(pc_sr),
    .ir(pc_ir),
    .sl(pc_sl),
    .il(pc_il),
    .out(pc_out)
);

// Stack Pointer (SP)

reg sp_cl = 0;
reg sp_ld = 0;
reg [ADDR_WIDTH-1:0] sp_in = 0;
reg sp_inc = 0;
reg sp_dec = 0;
reg sp_sr = 0;
reg sp_ir = 0;
reg sp_sl = 0;
reg sp_il = 0;
wire [ADDR_WIDTH-1:0] sp_out;

register #(
    .DATA_WIDTH(ADDR_WIDTH)
) sp_inst (
    .clk(clk),
    .rst_n(rst_n),
    .cl(sp_cl),
    .ld(sp_ld),
    .in(sp_in),
    .inc(sp_inc),
    .dec(sp_dec),
    .sr(sp_sr),
    .ir(sp_ir),
    .sl(sp_sl),
    .il(sp_il),
    .out(sp_out)
);

// Instruction Register (IR) - split into two parts: upper and lower

reg ir_up_cl = 0;
reg ir_up_ld = 0;
reg [DATA_WIDTH-1:0] ir_up_in = 0;
reg ir_up_inc = 0;
reg ir_up_dec = 0;
reg ir_up_sr = 0;
reg ir_up_ir = 0;
reg ir_up_sl = 0;
reg ir_up_il = 0;
wire [DATA_WIDTH-1:0] ir_up_out;


register #(
    .DATA_WIDTH(DATA_WIDTH)
) ir_up_inst (
    .clk(clk),
    .rst_n(rst_n),
    .cl(ir_up_cl),
    .ld(ir_up_ld),
    .in(ir_up_in),
    .inc(ir_up_inc),
    .dec(ir_up_dec),
    .sr(ir_up_sr),
    .ir(ir_up_ir),
    .sl(ir_up_sl),
    .il(ir_up_il),
    .out(ir_up_out)
);


// Instruction Register (IR) - lower part

reg ir_down_cl = 0;
reg ir_down_ld = 0;
reg [DATA_WIDTH-1:0] ir_down_in = 0;
reg ir_down_inc = 0;
reg ir_down_dec = 0;
reg ir_down_sr = 0;
reg ir_down_ir = 0;
reg ir_down_sl = 0;
reg ir_down_il = 0;
wire [DATA_WIDTH-1:0] ir_down_out;


register #(
    .DATA_WIDTH(DATA_WIDTH)
) ir_down_inst (
    .clk(clk),
    .rst_n(rst_n),
    .cl(ir_down_cl),
    .ld(ir_down_ld),
    .in(ir_down_in),
    .inc(ir_down_inc),
    .dec(ir_down_dec),
    .sr(ir_down_sr),
    .ir(ir_down_ir),
    .sl(ir_down_sl),
    .il(ir_down_il),
    .out(ir_down_out)
);

// Memory Address Register (MAR)


reg mar_cl = 0;
reg mar_ld = 0;
reg [ADDR_WIDTH-1:0] mar_in = 0;
reg mar_inc = 0;
reg mar_dec = 0;
reg mar_sr = 0;
reg mar_ir = 0;
reg mar_sl = 0;
reg mar_il = 0;
wire [ADDR_WIDTH-1:0] mar_out;

register #(
    .DATA_WIDTH(ADDR_WIDTH)
) mar_inst (
    .clk(clk),
    .rst_n(rst_n),
    .cl(mar_cl),
    .ld(mar_ld),
    .in(mar_in),
    .inc(mar_inc),
    .dec(mar_dec),
    .sr(mar_sr),
    .ir(mar_ir),
    .sl(mar_sl),
    .il(mar_il),
    .out(mar_out)
);

// Memory Data Register (MDR)


reg mdr_cl = 0;
reg mdr_ld = 0;
reg [DATA_WIDTH-1:0] mdr_in = 0;
wire [DATA_WIDTH-1:0] mdr_in_wire;
reg mdr_inc = 0;
reg mdr_dec = 0;
reg mdr_sr = 0;
reg mdr_ir = 0;
reg mdr_sl = 0;
reg mdr_il = 0;
wire [DATA_WIDTH-1:0] mdr_out;

register #(
    .DATA_WIDTH(DATA_WIDTH)
) mdr_inst (
    .clk(clk),
    .rst_n(rst_n),
    .cl(mdr_cl),
    .ld(mdr_ld),
    .in(mdr_in_wire),
    .inc(mdr_inc),
    .dec(mdr_dec),
    .sr(mdr_sr),
    .ir(mdr_ir),
    .sl(mdr_sl),
    .il(mdr_il),
    .out(mdr_out)
);


// Accumulator (A)

reg a_cl = 0;
reg a_ld = 0;
reg [DATA_WIDTH-1:0] a_in = 0;
reg a_inc = 0;
reg a_dec = 0;
reg a_sr = 0;
reg a_ir = 0;
reg a_sl = 0;
reg a_il = 0;
wire [DATA_WIDTH-1:0] a_out;

register #(
    .DATA_WIDTH(DATA_WIDTH)
) a_inst (
    .clk(clk),
    .rst_n(rst_n),
    .cl(a_cl),
    .ld(a_ld),
    .in(a_in),
    .inc(a_inc),
    .dec(a_dec),
    .sr(a_sr),
    .ir(a_ir),
    .sl(a_sl),
    .il(a_il),
    .out(a_out)
);


// ALU

reg [DATA_WIDTH-1:0] alu_a = 0;
reg [DATA_WIDTH-1:0] alu_b = 0;
reg [2:0] alu_op = 0;
wire [DATA_WIDTH-1:0] alu_result;


alu #(
    .DATA_WIDTH(DATA_WIDTH)
) alu_inst (
    .a(alu_a),
    .b(alu_b),
    .oc(alu_op),
    .f(alu_result)
);

//---------------------------------------------------

// Extra registers and wires ------------------------

// Control signal for MDR write source

reg mdr_w_nr = 0; // 0: from memory, 1: from mdr_in reg


// registers for operands X, Y, Z

reg [ADDR_WIDTH-1:0] operand_X_addr = 0;
reg [ADDR_WIDTH-1:0] operand_Y_addr = 0;
reg [ADDR_WIDTH-1:0] operand_Z_addr = 0;
reg [DATA_WIDTH-1:0] operand_X_writeback = 0;
reg [DATA_WIDTH-1:0] operand_X = 0;
reg [DATA_WIDTH-1:0] operand_Y = 0;
reg [DATA_WIDTH-1:0] operand_Z = 0;


// Instruction decoding wires

wire [3:0] ir_op_code = ir_up_out[DATA_WIDTH-1:DATA_WIDTH-4];

// Operand X

wire ir_operand_X_D_I = ir_up_out[DATA_WIDTH-5];
wire [2:0] ir_operand_X_addr = ir_up_out[DATA_WIDTH-6:DATA_WIDTH-8];
wire [3:0] ir_operand_X = {ir_operand_X_D_I, ir_operand_X_addr};

// Operand Y

wire ir_operand_Y_D_I = ir_up_out[DATA_WIDTH-9];
wire [2:0] ir_operand_Y_addr = ir_up_out[DATA_WIDTH-10:DATA_WIDTH-12];
wire [3:0] ir_operand_Y = {ir_operand_Y_D_I, ir_operand_Y_addr};

// Operand Z

wire ir_operand_Z_D_I = ir_up_out[DATA_WIDTH-13];
wire [2:0] ir_operand_Z_addr = ir_up_out[DATA_WIDTH-14:DATA_WIDTH-16];
wire [3:0] ir_operand_Z = {ir_operand_Z_D_I, ir_operand_Z_addr};

// Constant/Address

wire [DATA_WIDTH-1:0] ir_const_addr = ir_down_out;

//---------------------------------------------------

// Parameters ---------------------------------------

localparam OP_MOV = 4'b0000;
localparam OP_ADD = 4'b0001;
localparam OP_SUB = 4'b0010;
localparam OP_MUL = 4'b0011;
localparam OP_DIV = 4'b0100;
localparam OP_IN = 4'b0111;
localparam OP_OUT = 4'b1000;
localparam OP_STOP = 4'b1111;

//---------------------------------------------------

// Assignments --------------------------------------   


assign addr = mar_out;
assign data = mdr_out;
assign mdr_in_wire = mdr_w_nr ? mdr_in : mem;

assign pc = pc_out;
assign sp = sp_out;

//---------------------------------------------------

// Control Unit (CU) --------------------------------

localparam FETCH = 0;
localparam DECODE = 1;
localparam EXECUTE = 2;
localparam WRITEBACK = 3;
localparam STOP = 4;

localparam DECODE_X_ADDR = 16;
localparam DECODE_X_ADDR_INDIRECT = 32;
localparam DECODE_X_DATA = 48;
localparam DECODE_X_DATA_INDIRECT = 64;
localparam DECODE_Y_DATA = 80;
localparam DECODE_Y_DATA_INDIRECT = 96;
localparam DECODE_Z_DATA = 112;
localparam DECODE_Z_DATA_INDIRECT = 128;

localparam EXECUTE_MOV = 16;
localparam EXECUTE_ALU_OP = 32;
localparam EXECUTE_IN = 48;
localparam EXECUTE_OUT = 64;
localparam EXECUTE_STOP = 80;

integer STATE = 0;
integer FETCH_STATE = 0;
integer DECODE_STATE = 0;
integer EXECUTE_STATE = 0;
integer WRITEBACK_STATE = 0;

// State Machine

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        STATE <= FETCH;
        FETCH_STATE <= 0;
        DECODE_STATE <= 0;
        EXECUTE_STATE <= 0;
        WRITEBACK_STATE <= 0;
    end else begin
        case(STATE)
            FETCH: begin
                case(FETCH_STATE)
                    0, 1, 2, 3, 5, 6, 7, 8: begin
                        FETCH_STATE <= FETCH_STATE + 1;
                    end
                    4: begin

                        case(ir_op_code)

                            OP_MOV,
                            OP_ADD,
                            OP_SUB,
                            OP_MUL,
                            OP_DIV,
                            OP_IN,
                            OP_OUT,
                            OP_STOP : begin
                                STATE <= DECODE;
                                FETCH_STATE <= 0;
                            end
                            
                            default: begin // indirect addressing fetch
                                STATE <= STOP;
                                FETCH_STATE <= FETCH_STATE + 1;
                            end

                        endcase
                    end
                    9: begin
                        STATE <= DECODE;
                        FETCH_STATE <= 0;
                    end
                    default: begin
                        FETCH_STATE <= 0;
                    end
                endcase
            end
            DECODE: begin
                case(DECODE_STATE)
                    0: begin
                        operand_X_addr <= ir_operand_X_addr;
                        operand_Y_addr <= ir_operand_Y_addr;
                        operand_Z_addr <= ir_operand_Z_addr;
                        case(ir_op_code)

                            OP_MOV,
                            OP_ADD,
                            OP_SUB,
                            OP_MUL,
                            OP_DIV,
                            OP_IN : begin
                                if(ir_operand_X_D_I) begin
                                    DECODE_STATE <= DECODE_X_ADDR_INDIRECT;
                                end else begin
                                    DECODE_STATE <= DECODE_X_ADDR;
                                end
                            end

                            OP_OUT : begin
                                if(ir_operand_X_D_I) begin
                                    DECODE_STATE <= DECODE_X_DATA_INDIRECT;
                                end else begin
                                    DECODE_STATE <= DECODE_X_DATA;
                                end
                            end

                            OP_STOP : begin
                                if (ir_operand_X != 4'b0000) begin
                                    if(ir_operand_X_D_I) begin
                                        DECODE_STATE <= DECODE_X_DATA_INDIRECT;
                                    end else begin
                                        DECODE_STATE <= DECODE_X_DATA;
                                    end
                                end
                                else begin
                                    DECODE_STATE <= DECODE_STATE + 1;
                                end
                            end
                            
                            default: begin
                                DECODE_STATE <= DECODE_STATE + 1;
                            end

                        endcase
                    end
                    
                    1: begin
                       case(ir_op_code)

                            OP_MOV,
                            OP_ADD,
                            OP_SUB,
                            OP_MUL,
                            OP_DIV : begin
                                if(ir_operand_Y_D_I) begin
                                    DECODE_STATE <= DECODE_Y_DATA_INDIRECT;
                                end else begin
                                    DECODE_STATE <= DECODE_Y_DATA;
                                end
                            end

                            OP_STOP : begin
                                if (ir_operand_Y != 4'b0000) begin
                                    if(ir_operand_Y_D_I) begin
                                        DECODE_STATE <= DECODE_Y_DATA_INDIRECT;
                                    end else begin
                                        DECODE_STATE <= DECODE_Y_DATA;
                                    end
                                end
                                else begin
                                    DECODE_STATE <= DECODE_STATE + 1;
                                end
                            end

                            default: begin
                                DECODE_STATE <= DECODE_STATE + 1;
                            end

                        endcase
                        
                    end

                    2: begin
                        
                        case(ir_op_code)

                            OP_ADD,
                            OP_SUB,
                            OP_MUL,
                            OP_DIV : begin
                                if(ir_operand_Z_D_I) begin
                                    DECODE_STATE <= DECODE_Z_DATA_INDIRECT;
                                end else begin
                                    DECODE_STATE <= DECODE_Z_DATA;
                                end
                            end

                            OP_STOP : begin
                                if (ir_operand_Z != 4'b0000) begin
                                    if(ir_operand_Z_D_I) begin
                                        DECODE_STATE <= DECODE_Z_DATA_INDIRECT;
                                    end else begin
                                        DECODE_STATE <= DECODE_Z_DATA;
                                    end
                                end
                                else begin
                                    DECODE_STATE <= DECODE_STATE + 1;
                                end
                            end

                            default: begin
                                DECODE_STATE <= DECODE_STATE + 1;
                            end
                        endcase
                        
                    end

                    3: begin
                       STATE <= EXECUTE;
                       DECODE_STATE <= 0; 
                    end

                    DECODE_X_ADDR: begin
                        operand_X_addr <= ir_operand_X_addr;
                        DECODE_STATE <= 1;
                    end
                    
                    DECODE_X_DATA,
                    DECODE_Y_DATA,
                    DECODE_Z_DATA,
                    DECODE_X_ADDR_INDIRECT,
                    DECODE_X_DATA_INDIRECT,
                    DECODE_Y_DATA_INDIRECT,
                    DECODE_Z_DATA_INDIRECT,
                    DECODE_X_DATA + 1,
                    DECODE_Y_DATA + 1,
                    DECODE_Z_DATA + 1,
                    DECODE_X_ADDR_INDIRECT + 1,
                    DECODE_X_DATA_INDIRECT + 1,
                    DECODE_Y_DATA_INDIRECT + 1,
                    DECODE_Z_DATA_INDIRECT + 1,
                    DECODE_X_DATA + 2,
                    DECODE_Y_DATA + 2,
                    DECODE_Z_DATA + 2,
                    DECODE_X_ADDR_INDIRECT + 2,
                    DECODE_X_DATA_INDIRECT + 2,
                    DECODE_Y_DATA_INDIRECT + 2,
                    DECODE_Z_DATA_INDIRECT + 2 : begin
                        DECODE_STATE <= DECODE_STATE + 1;
                    end

                    DECODE_X_DATA + 3: begin
                        operand_X <= mdr_out;
                        DECODE_STATE <= 1;
                    end

                    DECODE_Y_DATA + 3: begin
                        operand_Y <= mdr_out;
                        DECODE_STATE <= 2;
                    end

                    DECODE_Z_DATA + 3: begin
                        operand_Z <= mdr_out;
                        DECODE_STATE <= 3;
                    end

                    DECODE_X_ADDR_INDIRECT + 3: begin
                        operand_X_addr <= mdr_out[ADDR_WIDTH-1:0];
                        DECODE_STATE <= 1;
                    end

                    DECODE_X_DATA_INDIRECT + 3: begin
                        operand_X_addr <= mdr_out;
                        DECODE_STATE <= DECODE_X_DATA;
                    end

                    DECODE_Y_DATA_INDIRECT + 3: begin
                        operand_Y_addr <= mdr_out;
                        DECODE_STATE <= DECODE_Y_DATA;
                    end

                    DECODE_Z_DATA_INDIRECT + 3: begin
                        operand_Z_addr <= mdr_out;
                        DECODE_STATE <= DECODE_Z_DATA;
                    end

                    default: begin
                        DECODE_STATE <= 0;
                    end
                endcase

            end
            EXECUTE: begin
                case(EXECUTE_STATE)
                    0: begin
                        
                        case(ir_op_code)

                            OP_MOV: begin
                                EXECUTE_STATE <= EXECUTE_MOV;
                            end

                            OP_ADD,
                            OP_SUB,
                            OP_MUL,
                            OP_DIV: begin
                                EXECUTE_STATE <= EXECUTE_ALU_OP;
                            end

                            OP_IN: begin
                                EXECUTE_STATE <= EXECUTE_IN;
                            end

                            OP_OUT: begin
                                EXECUTE_STATE <= EXECUTE_OUT;
                            end

                            OP_STOP: begin
                                EXECUTE_STATE <= EXECUTE_STOP;
                            end

                            default: begin
                                STATE <= STOP;
                            end

                        endcase
                        
                    end
                    EXECUTE_MOV: begin
                        operand_X_writeback <= operand_Y;
                        if(ir_operand_Z == 4'b0000) begin
                            EXECUTE_STATE <= 0;
                            STATE <= WRITEBACK;
                        end else begin
                            EXECUTE_STATE <= 0;
                            STATE <= FETCH;
                        end
                    end
                    EXECUTE_ALU_OP: begin
                        operand_X_writeback <= alu_result;
                        EXECUTE_STATE <= 0;
                        STATE <= WRITEBACK;
                    end
                    EXECUTE_IN: begin
                        if (control == 1'b1) begin
                            operand_X_writeback <= in;
                            EXECUTE_STATE <= 0;
                            STATE <= WRITEBACK;
                        end
                    end
                    EXECUTE_OUT: begin
                        out <= operand_X;
                        EXECUTE_STATE <= 0;
                        STATE <= FETCH;
                    end
                    EXECUTE_STOP: begin
                        if(ir_operand_X != 4'b0000) begin
                            out <= operand_X;
                        end else if(ir_operand_Y != 4'b0000) begin
                            out <= operand_Y;
                        end else if(ir_operand_Z != 4'b0000) begin
                            out <= operand_Z;
                        end
                        EXECUTE_STATE <= 0;
                        STATE <= STOP;
                    end
                    default: begin
                        EXECUTE_STATE <= 0;
                    end
                endcase
            end
            WRITEBACK: begin
                case(WRITEBACK_STATE)
                    0: begin
                        case(ir_op_code)

                            OP_MOV,
                            OP_ADD,
                            OP_SUB,
                            OP_MUL,
                            OP_DIV,
                            OP_IN : begin
                                WRITEBACK_STATE <= WRITEBACK_STATE + 1;
                            end

                            default: begin
                                STATE <= STOP;
                            end

                        endcase
                    end
                    1: begin
                        WRITEBACK_STATE <= WRITEBACK_STATE + 1;
                    end
                    2: begin
                        WRITEBACK_STATE <= 0;
                        STATE <= FETCH;
                    end
                    default: begin
                        WRITEBACK_STATE <= 0;
                    end
                endcase
            end
            STOP: begin
                STATE <= STOP;
            end
            default: begin
                STATE <= STOP;
            end
        endcase
    end
end

// Combinational Logic

always @(*) begin
    
    pc_cl = 0;
    pc_ld = 0;
    pc_in = 0;
    pc_inc = 0;
    pc_dec = 0;
    pc_sr = 0;
    pc_ir = 0;
    pc_sl = 0;
    pc_il = 0;
    
    sp_cl = 0;
    sp_ld = 0;
    sp_in = 0;
    sp_inc = 0;
    sp_dec = 0;
    sp_sr = 0;
    sp_ir = 0;
    sp_sl = 0;
    sp_il = 0;
    
    ir_up_cl = 0;
    ir_up_ld = 0;
    ir_up_in = 0;
    ir_up_inc = 0;
    ir_up_dec = 0;
    ir_up_sr = 0;
    ir_up_ir = 0;
    ir_up_sl = 0;
    ir_up_il = 0;
    
    ir_down_cl = 0;
    ir_down_ld = 0;
    ir_down_in = 0;
    ir_down_inc = 0;
    ir_down_dec = 0;
    ir_down_sr = 0;
    ir_down_ir = 0;
    ir_down_sl = 0;
    ir_down_il = 0;
    
    mar_cl = 0;
    mar_ld = 0;
    mar_in = 0;
    mar_inc = 0;
    mar_dec = 0;
    mar_sr = 0;
    mar_ir = 0;
    mar_sl = 0;
    mar_il = 0;
    
    mdr_cl = 0;
    mdr_ld = 0;
    mdr_in = 0;
    mdr_inc = 0;
    mdr_dec = 0;
    mdr_sr = 0;
    mdr_ir = 0;
    mdr_sl = 0;
    mdr_il = 0;
    mdr_w_nr = 0;
    
    we = 0;
    
    alu_a = 0;
    alu_b = 0;
    alu_op = 0;

    status = 0;
    
    case(STATE)
        FETCH: begin
            case(FETCH_STATE)
                0, 5: begin
                    mar_in = pc_out;
                    mar_ld = 1;
                end

                1, 6: begin
                    pc_inc = 1;
                end

                2, 7: begin
                    mdr_ld = 1;
                end

                3: begin
                    ir_up_in = mdr_out;
                    ir_up_ld = 1;
                end

                8: begin
                    ir_down_in = mdr_out;
                    ir_down_ld = 1;
                end

                default: begin
                end
            endcase
        end
        DECODE: begin
            case(DECODE_STATE)

                DECODE_X_ADDR_INDIRECT: begin
                    mar_in = operand_X_addr;
                    mar_ld = 1;
                end

                DECODE_X_DATA: begin
                    mar_in = operand_X_addr;
                    mar_ld = 1;
                end

                DECODE_Y_DATA: begin
                    mar_in = operand_Y_addr;
                    mar_ld = 1;
                end

                DECODE_Z_DATA: begin
                    mar_in = operand_Z_addr;
                    mar_ld = 1;
                end

                DECODE_X_DATA_INDIRECT: begin
                    mar_in = operand_X_addr;
                    mar_ld = 1;
                end

                DECODE_Y_DATA_INDIRECT: begin
                    mar_in = operand_Y_addr;
                    mar_ld = 1;
                end

                DECODE_Z_DATA_INDIRECT: begin
                    mar_in = operand_Z_addr;
                    mar_ld = 1;
                end

                DECODE_X_DATA + 2,
                DECODE_Y_DATA + 2,
                DECODE_Z_DATA + 2,
                DECODE_X_ADDR_INDIRECT + 2,
                DECODE_X_DATA_INDIRECT + 2,
                DECODE_Y_DATA_INDIRECT + 2,
                DECODE_Z_DATA_INDIRECT + 2: begin
                    mdr_ld = 1;
                end

                default: begin
                end
            endcase
        end
        EXECUTE: begin
            case(EXECUTE_STATE)
                EXECUTE_ALU_OP: begin
                    alu_a = operand_Y;
                    alu_b = operand_Z;
                    case(ir_op_code)
                        OP_ADD: alu_op = 3'b000;
                        OP_SUB: alu_op = 3'b001;
                        OP_MUL: alu_op = 3'b010;
                        OP_DIV: alu_op = 3'b011;
                        default: alu_op = 3'b000;
                    endcase
                end
                EXECUTE_IN: begin
                    status = 1'b1;
                end
                default: begin
                end
            endcase
        end
        WRITEBACK: begin
            case(WRITEBACK_STATE)
                0: begin
                    mar_in = operand_X_addr;
                    mar_ld = 1;
                    mdr_w_nr = 1;
                    mdr_in = operand_X_writeback;
                    mdr_ld = 1;
                end

                1: begin
                    we = 1;
                end

                default: begin
                end
            endcase
        end
        default: begin
        end

    endcase
    
end
endmodule