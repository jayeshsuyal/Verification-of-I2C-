class driver

    virtual i2c_if iif;
    transaction tr;
    mailbox #(transaction) mbxgd;
    event drvnext;


    function new();
        this.mbxgd = mbxgd;
    endfunction

    //resetting system, the system is active high reset
   task reset();
        iif.reset <= 1'b1;
        iif.newd  <= 1'b0;
        iif.wr    <= 1'b0;
        iif.addr  <= 1'b0;
        iif.w_data <= 1'b0;
        iif.r_data <= 1'b0;

        repeat(10) @(posedge iif.clk)
        iif.rese <= 0;
        repeat(5) @(posedge iif.clk)
        $display("[DRV]: RESET DONE.!!");
   endtask

    //applying values to the DUT using interface
   task run();
        mbxgd.get(tr);

        @(posedge iif.sclk_ref)
        iif.reset <= 1'b0;
        iif.newd <= 1'b1;
        iif.wr  <= tr.wr;
        iif.w_data <= tr.w_data;
        iif.r_data <= tr.r_data;
        iif.addr  <= tr.addr;
        
        @(posedge iif.sclk_ref)
        iif.newd <= 1'b0;

        $display("[DRV]- WR: %0df, W_DATA: %0d, R_DATA: %0d, ADDR: %0d", iif.wr, iif.w_data,iif.r_data,iif.addr);
        -> drvnext;
   endtask

endclass