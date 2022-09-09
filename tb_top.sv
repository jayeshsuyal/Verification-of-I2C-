module tb;

    transaction tr;
    generator gen;
    monitor mon;
    scoreboard sco;
    driver drv;

    virtual i2c_if iif;

    mailbox #(transaction) mbxms; ///monitor to sco
    mailbox #(transaction) mbxgd; /// gen to drv

    event nextgd; //gen to drv
    event nextgs; // gen to sco

    initial begin
         iif.clk <= 0;
    end
    
    always #5 iif.clk <= ~iif.clk;

    intial begin
        mbxms = new();
        mbxgd = new();

        gen = new(mbxgd);
        drv = new(mbxgd);

        mon = new(mbxms);
        sco = new(mbxms);

        gen.count = 20;

        gen.drvnext = nextgd;
        drv.drvnext = nextgd;

        gen.sconext = nextgs;
        sco.sconext = nextgs;
    end

    task pre_test();
        drv.reset();
    endtask

    task test();
        fork
            gen.run();
            drv.run();
            mon.run();
            sco.run();
        join_any
    endtask
    
    task post_test();
        wait(gen.done.triggered);
        $finish();
    endtask

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars;
    end
    
    assign iif.sclk_ref = dut.e1.sclk_ref;
endmodule