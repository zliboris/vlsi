module scan_codes(
    input clk,
    input rst_n,
    input [15:0] code,
    input status,
    input ps2_control,
    output reg control,
    output [3:0] num
);

    reg [3:0] num_value = 4'b0;

    assign num = (code[15:8] == 8'hF0) ? num_value : 4'b0;

    always @(*) begin
        case(code[7:0])
            8'h45: begin  // 0
                num_value = 4'h0;
            end
            8'h16: begin  // 1
                num_value = 4'h1;
            end
            8'h1E: begin  // 2
                num_value = 4'h2;
            end
            8'h26: begin  // 3
                num_value = 4'h3;
            end
            8'h25: begin  // 4
                num_value = 4'h4;
            end
            8'h2E: begin  // 5
                num_value = 4'h5;
            end
            8'h36: begin  // 6
                num_value = 4'h6;
            end
            8'h3D: begin  // 7
                num_value = 4'h7;
            end
            8'h3E: begin  // 8
                num_value = 4'h8;
            end
            8'h46: begin  // 9
                num_value = 4'h9;
            end
            default: begin
                num_value = 4'h0;
            end
        endcase 
    end

    always @(posedge clk or negedge rst_n) begin

        if(rst_n == 1'b0) begin
            control <= 1'b0;
        end else begin
            if(status == 1'b1 && ps2_control == 1'b1 && code[15:8] == 8'hF0) begin
                control <= 1'b1;
            end
            if (control == 1'b1) begin
                control <= 1'b0;
            end

        end
    end



endmodule