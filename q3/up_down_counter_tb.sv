module up_down_counter_tb;

// complete here
    localparam N = 4;

    logic              clk;
    logic              rst_n;
    logic              load;
    logic              up_down;
    logic [N-1:0]      input_load;
    logic [N-1:0]      count_out;
    logic              carry_out;

    up_down_counter #(.N(N)) dut (
        .clk(clk),
        .rst_n(rst_n),
        .up_down(up_down),
        .load(load),
        .input_load(input_load),
        .count_out(count_out),
        .carry_out(carry_out)
    );

    always #5 clk = ~clk;

    task reset_dut();
        rst_n = 0;
        load = 0;
        up_down = 1;
        input_load = '0;
        #10;
        rst_n = 1;
        $display("Reset done: count_out=%0d, carry_out=%b", count_out, carry_out);
    endtask

    task parallel_load(input [N-1:0] data);
        load = 1;
        input_load = data;
        @(posedge clk);
        @(negedge clk);
        load = 0;
        $display("Parallel load: %0d -> count_out=%0d", data, count_out);
    endtask

    task count_up(input integer steps);
        integer i;
        up_down = 1;
        for (i = 0; i < steps; i++) begin
            @(posedge clk);
            @(negedge clk);
            $display("Count up step %0d: count_out=%0d, carry_out=%b", i, count_out, carry_out);
        end
    endtask

    task count_down(input integer steps);
        integer i;
        up_down = 0;
        for (i = 0; i < steps; i++) begin
            @(posedge clk);
            @(negedge clk);
            $display("Count down step %0d: count_out=%0d, carry_out=%b", i, count_out, carry_out);
        end
    endtask

    initial begin
        clk = 0;
        rst_n = 1;

        reset_dut();
        parallel_load(4'd5);
        count_up(11); // should wrap and end up at 0 with carry_out=1

        reset_dut();
        parallel_load(4'd2);
        count_down(3); // should wrap and end up at 15 with carry_out=1

        $display("All tests completed.");
    end

endmodule