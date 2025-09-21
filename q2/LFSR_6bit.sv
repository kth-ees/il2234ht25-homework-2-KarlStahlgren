module LFSR_6bit (
  input  logic clk, rst_n,
  input  logic sel,
  input  logic [5:0] parallel_in,
  output logic [5:0] parallel_out
);
  // …
  // Add your description here
  // …
  logic [5:0] register; //state of the flip flops

  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      register <= '0; 
    end else if (sel) begin //serial shift 
      register[0] <= register[5];
      register[1] <= register[0] ^ register[5];
      register[2] <= register[1];
      register[3] <= register[2] ^ register[5];
      register[4] <= register[3];
      register[5] <= register[4];
    end else begin //load parallell input
      register <= parallel_in; 
  end
  end
  assign parallel_out = register;
endmodule
