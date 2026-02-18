module top;

reg [2:0] r_oc;
reg [3:0] r_a;
reg [3:0] r_b;
wire [3:0] w_f;


alu u_alu (
    .oc(r_oc),
    .a(r_a),
    .b(r_b),
    .f(w_f)
);

reg r_clk = 0;
reg r_rst_n;
reg r_cl;
reg r_ld;
reg [3:0] r_in;
reg r_inc;
reg r_dec;
reg r_sr;
reg r_ir;
reg r_sl;
reg r_il;
wire [3:0] w_out;

register u_register (
    .clk(r_clk),
    .rst_n(r_rst_n),
    .cl(r_cl),
    .ld(r_ld),
    .in(r_in),
    .inc(r_inc),
    .dec(r_dec),
    .sr(r_sr),
    .ir(r_ir),
    .sl(r_sl),
    .il(r_il),
    .out(w_out)
);

integer i,j,k;

always begin
    #5 r_clk = ~r_clk;
end

initial begin

    $monitor("Time = %t, oc = %b, a = %d, b = %d => f=%d", $time, r_oc, r_a, r_b, w_f);

    for(i = 0; i < 8; i = i + 1) begin
        for(j = 0; j < 16; j = j + 1) begin
            for(k = 0; k < 16; k = k + 1) begin
                r_oc = i;
                r_a = j;
                r_b = k;
                #10;
            end
        end
    end

    $stop;

    $monitor("Time = %t, out = %d", $time, w_out);

    repeat (1000) begin
        r_rst_n = $random % 2;
        r_cl = $random % 2;
        r_ld = $random % 2;
        r_in = $random % 16;
        r_inc = $random % 2;
        r_dec = $random % 2;
        r_sr = $random % 2;
        r_ir = $random % 2;
        r_sl = $random % 2;
        r_il = $random % 2;
        #10;
    end

    $finish;
end

endmodule