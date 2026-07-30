module counter #(
    parameter WIDTH = 8
) (
    input reg clk,
    input reg rst_n,
    input reg en,
    input reg [WIDTH-1:0] reset_value,
    output reg [WIDTH-1:0] count
);

  always @(posedge clk) begin
    if (!rst_n) begin
      count <= reset_value;
    end else if (en) begin
      count <= count + 1'b1;
    end else begin
      count <= count;
    end
  end

endmodule
