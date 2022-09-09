class transaction;
    bit [7:0] r_data;
    rand bit [6:0] addr;
    bit newd;
    bit rand [7:0] w_data;
    bit done; 
    bit wr;

    constraint addr_c {addr > 0;  addr <5;} ///constraning the value of address b/w 0 to 5
    constraint wr_c {wr dist{1:/50, 0:/50}} /// distributing 0 and 1 50% each for write

    //deep copying all the variables
    function tranasactio copy();
        copy = new();
        copy.r_data = this.r_data;
        copy.addr = this.addr;
        copy.newd = this.newd;
        copy.w_data = this.w_data;
        copy.done = this.done;
        copy.wr = this.wr;
    endfunction

    //to display all the vairlable in the tran class;
    function void display(input string tag);

        $display("[%0s]- rdata:%0d, addr: %0d, newd: %0d, wdata:%0d, done:%0d, wr: %0d", tag, xr_data,addr,newd,w_data,done,wr);

    endfunction  

endclass





