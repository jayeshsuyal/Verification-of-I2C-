class generator;

 transaction tr;
 mailbox #(transaction) mbxgd; 
 event done; ///communicating using the done so that genration of rand number is completed; 
 event drvnext;  //event triggering the drv;
 event sconext; // event triggering the sco;
 int count  = 0;
    function new();
        this.mbxgd;
        this.tr = new();
    endfunction

    
        
    task run();
        repeat (count) begin 
            assert(tr.randomize) else $display("Randomization Failed..!!!");
            tr.display("GEN");
            mbxgd.put(tr.copy);
            @(drvnext); //waiting for drv to trigger an event
            @(sconext); //waiting for sco to trigger an event
        end
        -> done; 

    endtask


endclass