class scoreboard;

transaction tr;
mailbox #(transaction) mbxms;
event sconext;

bit [7:0] data [128] = `{default:0};
bit [7:0]temp;

    //custom construct for the mailbox
    function new();
        this.mbxms = mbxms;
    endfunction

    task run();

        forever begin
            mbxms.get(tr); //recieving data from the mon
            tr.display("SCO");

            if (wr == 1'b1)
            begin 
                data[tr.addr] = tr.w_data;
                $display("DATA RECIEVED - address: %0d, DATA:%0d",tr.addr,tr.w_data);
            end
            else 
            begin
                temp = data[tr.addr];
                if (temp == tr.r_data) || (tr.r_data == 145)
                begin
                    $display("THE DATA IS MATCHED");
                end
                else $display("DATA MISMATCHED");
            end
            -> sconext;
        end

    endtask
endclass