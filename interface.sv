interface i2c_if
    
    logic newd;
    logic wr;
    logic ack;
    logic [7:0]r_data;
    logic [7:0] w_data;
    logic [6:0]addr;
    logic  sclk_ref; 
    logic sda;
    logic done;
endinterface