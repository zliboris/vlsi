module debouncer(
    input clk,
    input rst_n,
    input in,
    output reg out = 0
);

    reg [2:0] cnt;
    reg prev_in;

    always @(posedge clk or negedge rst_n) begin
        prev_in <= in;
        if (!rst_n) begin
            cnt <= 3'b000;
            out <= 1'b0;
        end
        else begin
            if (in == prev_in) begin
                cnt <= cnt + 1'b1;
            end
            else begin
                cnt <= 3'b000;
            end
            if (cnt == 3'b111) begin
                out <= prev_in;
            end
        end
    end 



endmodule