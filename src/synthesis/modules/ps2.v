module ps2(
input rst_n,
input ps2_clk,
input ps2_data,
input clk,
input clk_devided,
output reg control,
output reg [15:0] code
);

reg [9:0] input_data = 10'h3FF;
reg start = 1'b0;

reg code_detected = 1'b0;

wire w_db_ps2_clk;

debouncer db(.in(ps2_clk),.clk(clk),.out(w_db_ps2_clk),.rst_n(rst_n));

always @(posedge w_db_ps2_clk or negedge rst_n) begin
    if(rst_n == 1'b0) begin
        start <= 1'b0;
        code <= 16'b0;
        input_data <= 10'h3FF;
    end
    else begin
        input_data <= {ps2_data, input_data[9:1]};
        
        if(start == 1'b0 && ps2_data == 1'b0) begin
            start <= 1'b1;
        end
        else if (start == 1'b1 && input_data[0] == 1'b0) begin
            code <= {code[7:0], input_data[8:1]};
            input_data <= 10'h3FF;
            start <= 1'b0;
            code_detected <= 1'b1;
        end
        if(control == 1'b1) begin
            code_detected <= 1'b0;
        end
    end
end

always @(posedge clk_devided or negedge rst_n) begin

    if(rst_n == 1'b0) begin
        control <= 1'b0;
    end else begin
        if(code_detected == 1'b1) begin
            control <= 1'b1;
        end
        if (control == 1'b1) begin
            control <= 1'b0;
        end
    end

end

endmodule