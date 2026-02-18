module red(
    input clk,
    input rst_n,
    input in,
    output reg out = 0
);

reg prev_in;

always @(posedge clk or negedge rst_n) begin
    prev_in <= in;
    if (!rst_n) begin
        out <= 1'b0;
    end
    else if(in & ~prev_in) begin
        out <= 1'b1;
    end
    else begin
        out <= 1'b0;
    end

end

endmodule