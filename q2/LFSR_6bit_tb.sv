module LFSR_6bit_tb;

// complete here
    logic clk;
    logic rst_n;
    logic sel;
    logic [5:0] parallel_in;
    logic [5:0] parallel_out;

    LFSR_6bit dut (
        .clk(clk),
        .rst_n(rst_n),
        .sel(sel),
        .parallel_in(parallel_in),
        .parallel_out(parallel_out)
    );
    always #5 clk = ~clk;

    task reset_dut(); //To reset dut
        rst_n = 0;
        sel = 0;
        parallel_in = '0;

        #10;
        rst_n = 1;
    endtask

    task parallel_load(input [5:0] data); //To test parallel load
        sel = 0; 
        parallel_in = data;
        @(posedge clk);
        @(negedge clk);
        $display("Parallel load: %b, parallel_out=%b", data, parallel_out);
    endtask

    task serial_shift(input integer shift_amount); //To test serial shift
        integer i;
        sel = 1; 
        for (i = 0; i < shift_amount; i++) begin
            @(posedge clk);
            @(negedge clk); 
            $display("Shift %0d: shift_reg=%b", i, parallel_out);
        end
    endtask

    initial begin
        clk = 0;
        rst_n = 1;

        reset_dut();

        parallel_load('0);
        serial_shift(5);

        reset_dut();

        parallel_load('1);
        serial_shift(20);

        $display("All tests completed.");
        //$finish;
    end
endmodule