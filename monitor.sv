class montior;

    mailbox #(transaction) mbxms; //monitor to sco 
    virtual i2c_if iif;
    transaction tr;
    
    //custom constructor for the mailbox
    function new();
        this.mbxms = mbxms;
    endfunction

    //Capturing response from the DUT
    task run();
        tr = new();  //creating handler

        forever begin
            
            @(posedge vif.sclk_ref)

            if(newd == 1'b1) begin
                if(wr == 1'b0)begin //wr = 0 means reading 
                    tr.wr = iif.wr;
                    tr.w_data = iif.w_data;
                    tr.addr = iif.addr;

                    @(posedge iif.sclk_ref);
                    wait(iif.done == 1'b1);
                    tr.r_data = iif.r_data;
                    repeat (2) @(posedge iif.sclk_ref) // 2clocks added to MATCH THE PHASING.
                    $display("[MON]: RDATA: %0d, ADDR: %0d, WDATA: %0d",tr.r_data, tr.addr);
                end
                else begin   //write begin
                    tr.wr = iif.wr;
                    tr.w_data = iif.w_data;
                    tr.addr = iif.addr;
                    @(posedge iif.sclk_ref)
                    wait (iif.done== 1'b1)
                    repeat (2) @(posedge iif.sclk_ref)
                    $display("[MON] - W_DATA: %0d, WR:%0d, ADDR: %0d", tr.w_data, tr.wr, tr.addr);
                end
            end
        end 

    endtask
endclass