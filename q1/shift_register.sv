module shift_register #(parameter N=4)
                      (input logic clk,
                       input logic rst_n,
                       input logic serial_parallel,
                       input logic load_enable,
                       input logic serial_in,
                       input logic [N-1:0] parallel_in,
                       output logic [N-1:0] parallel_out,
                       output logic serial_out);

    //complete here
    logic [N-1:0] shift_reg; //internal storage

    always_ff @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            shift_reg <= '0; 
        end else if(load_enable) begin
            if(serial_parallel) begin //if 1 load parallel
                shift_reg <= parallel_in;
            end else begin //if 0 load serial
            shift_reg <= {shift_reg[N-2:0], serial_in};
            end
        end
    end

    assign parallel_out = shift_reg;
    assign serial_out = shift_reg[N-1];

endmodule
