module top;
  import uvm_pkg::*;
  `include "uvm_macros.svh"

  class comp extends uvm_component;
    `uvm_new_func
    `uvm_component_utils(comp)
    int rcount=0, dcount=0;

    task run;
      uvm_test_done.set_drain_time(this, 5);

      repeat(3) begin
        for(int i=0;i<3; ++i) begin
          int v = i;
          fork begin
            doit(v);
          end join_none
        end
        #3;
      end
    endtask

    task doit(int v);
      uvm_report_info("DOIT", $sformatf("Calling doit with v = %0d", v));
      uvm_test_done.raise_objection(this);
      ++rcount;
      #(v*10 + 1);
      ++dcount;
      uvm_test_done.drop_objection(this);
      disable fork; 
    endtask

    function void report();
      if(rcount == 9 && dcount == 9)
        $display("*** UVM TEST PASSED ***");
      else
        $display("*** UVM TEST FAILED: rcount=%0d  dcount=%0d ***", rcount, dcount);
    endfunction
  endclass

  class test extends uvm_test;
    comp c;
    function new(string name, uvm_component parent);
      super.new(name,parent);
      c = new("c", this);
    endfunction
    `uvm_component_utils(test)
  endclass

  initial run_test;

endmodule
