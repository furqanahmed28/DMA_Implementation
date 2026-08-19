
`timescale 1ns/1ps
module dma_engine_tb;
reg clk;
reg rst;
reg start;
reg [31:0] src_addr;
reg [31:0] dst_addr;
reg [31:0] length;
wire busy;
wire done;
wire error;
wire interrupt;
dma_engine dut (
    .clk(clk),
    .rst(rst),
    .start(start),
    .src_addr(src_addr),
    .dst_addr(dst_addr),
    .length(length),
    .busy(busy),
    .done(done),
    .error(error),
    .interrupt(interrupt)
);

always #5 clk = ~clk;
initial begin

    clk = 0;
    rst = 0;
    start = 0;

    src_addr = 32'h0000_0000;
    dst_addr = 32'h0000_0040;
    length   = 32'd4;

    #10;
    rst = 1;

    // Put test data into source memory
    dut.mem.mem[0] = 32'h1111_AAAA;
    dut.mem.mem[1] = 32'h2222_BBBB;
    dut.mem.mem[2] = 32'h3333_CCCC;
    dut.mem.mem[3] = 32'h4444_DDDD;

    #10;
    start = 1;

    #10;
    start = 0;
    wait(done);

    #10;
    $display("DMA DONE");
    $display("Interrupt = %b", interrupt);
    $display("Destination data:");
    $display("%h", dut.mem.mem[16]);
    $display("%h", dut.mem.mem[17]);
    $display("%h", dut.mem.mem[18]);
    $display("%h", dut.mem.mem[19]);

    #20;
    $finish;
end
initial begin
    $monitor("T=%0t | busy=%b done=%b interrupt=%b",
             $time, busy, done, interrupt);
end

endmodule
