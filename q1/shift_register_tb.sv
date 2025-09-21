`timescale 1ns/1ps
module shift_register_tb;

    // complete here
    parameter N = 4;

    logic clk;
    logic rst_n;
    logic serial_parallel;
    logic load_enable;
    logic serial_in;
    logic [N-1:0] parallel_in;
    logic [N-1:0] parallel_out;
    logic serial_out;

    shift_register #(N) dut (
        .clk(clk),
        .rst_n(rst_n),
        .serial_parallel(serial_parallel),
        .load_enable(load_enable),
        .serial_in(serial_in),
        .parallel_in(parallel_in),
        .parallel_out(parallel_out),
        .serial_out(serial_out)
    );

    always #5 clk = ~clk;


    task reset_dut(); //To reset dut
        rst_n = 0;
        load_enable = 0;
        serial_in = 0;
        parallel_in = '0;
        serial_parallel = 0;

        #10;
        rst_n = 1;
    endtask

    task parallel_load(input [N-1:0] data); //To test parallel load
        load_enable = 1;
        serial_parallel = 1; 
        parallel_in = data;
        @(posedge clk);
        @(negedge clk);
        load_enable = 0;
        $display("Parallel load: %b, parallel_out=%b", data, parallel_out);
    endtask

    task serial_load(input [N-1:0] data); //To test serial load
        integer i;
        load_enable = 1;
        for (i = 0; i < N; i++) begin
            serial_parallel = 0; 
            serial_in = data[i]; 
            @(posedge clk);
            @(negedge clk); 
            $display("Shift %0d: serial_in=%b, shift_reg=%b, serial_out=%b",
                     i, serial_in, parallel_out, serial_out);
        end
        load_enable = 0;
    endtask

    // Test sequence
    initial begin
        clk = 0;
        rst_n = 1;

        reset_dut();

        parallel_load(4'b1010);
        serial_load(4'b1101);

        reset_dut();

        serial_load(4'b1011);
        parallel_load(4'b1110);
        

        $display("All tests completed.");
        //$finish;
    end
endmodule