
module xor_crypto #(parameter WIDTH = 8) (
    input wire clk,
    input wire reset,
    input wire load_key,
    input wire [WIDTH-1:0] key_in,
    input wire process_data,
    input wire [WIDTH-1:0] data_in,
    output reg [WIDTH-1:0] data_out,
    output reg data_ready
);

// Secure internal register to hold the cryptographic key
reg [WIDTH-1:0] stored_key;

always @(posedge clk or posedge reset) begin
if (reset) begin
stored_key <= {WIDTH{1'b0}}; // Clear key on reset for security
end else if (load_key) begin
stored_key <= key_in;        // Latch the new key
end
end

always @(posedge clk or posedge reset) begin
if (reset) begin
data_out <= {WIDTH{1'b0}};
data_ready <= 1'b0;
end else if (process_data) begin
  
data_out <= data_in ^ stored_key; 
data_ready <= 1'b1; 
end else begin
data_ready <= 1'b0; 
end
end

endmodule
