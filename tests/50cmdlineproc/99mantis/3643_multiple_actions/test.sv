module test;
  import uvm_pkg::*;
  uvm_action a;

  initial begin 
     automatic uvm_coreservice_t cs_ = uvm_coreservice_t::get();

    if(!uvm_string_to_action("UVM_LOG|UVM_STOP",a))
      $display("UVM TEST FAILED");
    else
      $display("UVM TEST PASSED");

    begin
       automatic uvm_report_server svr = cs_.get_report_server();
       svr.report_summarize();
    end
  end
endmodule
