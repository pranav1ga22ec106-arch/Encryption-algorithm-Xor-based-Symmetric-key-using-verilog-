module tb_crypto_system;
parameter WIDTH = 8;
reg clk;
reg reset;
reg load_key;
reg [WIDTH-1:0] master_key;

reg tx_process_data;
reg [WIDTH-1:0] tx_plaintext_in;
wire [WIDTH-1:0] tx_ciphertext_out;
wire tx_data_ready;
// Receiver (Decryption) signals
wire [WIDTH-1:0] rx_plaintext_out;
wire rx_data_ready;
// Instantiate Module 1: The Encryptor
xor_crypto #(.WIDTH(WIDTH)) Encryptor (
        .clk(clk),
        .reset(reset),
        .load_key(load_key),
        .key_in(master_key),
        .process_data(tx_process_data),
        .data_in(tx_plaintext_in),
        .data_out(tx_ciphertext_out),
        .data_ready(tx_data_ready)
    );

    xor_crypto #(.WIDTH(WIDTH)) Decryptor (
        .clk(clk),
        .reset(reset),
        .load_key(load_key),
        .key_in(master_key),
        .process_data(tx_data_ready), // Triggers when ciphertext is ready
        .data_in(tx_ciphertext_out),
        .data_out(rx_plaintext_out),
        .data_ready(rx_data_ready)
    );

initial begin
clk = 0;
forever #5 clk = ~clk;
end

initial begin
$display("========================================");
$display("   VLSI XOR Cryptography Simulation     ");
$display("========================================");
$monitor("Time=%0t | Plain IN: %h | Ciphertext: %h | Plain OUT: %h", 
$time, tx_plaintext_in, tx_ciphertext_out, rx_plaintext_out);


reset = 1;
load_key = 0;
tx_process_data = 0;
master_key = 8'h00;
tx_plaintext_in = 8'h00;
#15;
reset = 0;

#10;
load_key = 1;
master_key = 8'hA5; 
#10;
load_key = 0; 

#10;
tx_process_data = 1;
tx_plaintext_in = 8'hC3; 
        #10;
        tx_process_data = 0;
        #20;
        tx_process_data = 1;
        tx_plaintext_in = 8'h7F; 
        #10;
        tx_process_data = 0;
        
        #30;

        $display("========================================");
        $display(" Simulation Finished!                   ");
        $display("========================================");
        $stop;
    end

endmodule
