`include "uvm_delegate_factory_pkg.sv"

module test;
	import uvm_pkg::*;  
	import uvm_delegate_factory_pkg::*;
    `include "uvm_macros.svh"

	class a extends uvm_component;
		`uvm_component_utils(a)
		function new(string name,uvm_component parent );
			super.new(name,parent);
		endfunction
	endclass

	class b extends a;
		`uvm_component_utils(b)
		function new(string name,uvm_component parent );
			super.new(name,parent);
		endfunction
	endclass

	class c extends a;
		`uvm_component_utils(c)
		function new(string name,uvm_component parent );
			super.new(name,parent);
		endfunction
	endclass

	class uvm_trace_override_factory extends uvm_delegate_factory;
		virtual function void set_inst_override_by_type (uvm_object_wrapper original_type,
				uvm_object_wrapper override_type,
				string full_inst_path);
			`uvm_info("FACTORY",
				$sformatf("set_inst_override_by_type %s by %s path %s",
					original_type.get_type_name(),
					override_type.get_type_name(),
					full_inst_path)
				,UVM_NONE)
			delegate.set_inst_override_by_type(original_type,override_type,full_inst_path);
		endfunction 

		virtual function void set_inst_override_by_name (string original_type_name,
				string override_type_name,
				string full_inst_path);
			`uvm_info("FACTORY",
				$sformatf("set_inst_override_by_name %s by %s path %s",
					original_type_name,
					override_type_name,
					full_inst_path)
				,UVM_NONE)
			delegate.set_type_override_by_name(original_type_name,override_type_name,full_inst_path);
		endfunction

		virtual function void set_type_override_by_type (uvm_object_wrapper original_type,
				uvm_object_wrapper override_type,
				bit replace=1);
			`uvm_info("FACTORY",
				$sformatf("set_type_override_by_type %s by %s replace %0d",
					original_type.get_type_name(),
					override_type.get_type_name(),
					replace)
				,UVM_NONE)
			delegate.set_type_override_by_type(original_type, override_type, replace);
		endfunction


		virtual function void set_type_override_by_name (string original_type_name,
				string override_type_name,
				bit replace=1);
			`uvm_info("FACTORY",
				$sformatf("set_type_override_by_name %s by %s replace %0d",
					original_type_name,
					override_type_name,
					replace)
				,UVM_NONE)
			delegate.set_type_override_by_name(original_type_name, override_type_name, replace);
		endfunction 
	endclass    

	initial begin
		uvm_trace_override_factory f;

		// create new factory
		f = new();
		// set the delegate
		f.delegate=uvm_coreservice.getFactory();
		// enable new factory
		uvm_coreservice.setFactory(f);

		// now see the trace
		a::type_id::set_type_override(b::get_type());

		// switch the factory proxy off
		uvm_coreservice.setFactory(f.delegate);

		// no message
		a::type_id::set_type_override(c::get_type(),1);

		begin
			uvm_report_server svr;
			svr = uvm_report_server::get_server();

			if (svr.get_id_count("FACTORY")==1)
				$write("** UVM TEST PASSED **\n");
			else
				$write("!! UVM TEST FAILED !!\n");
				
			svr.summarize();

		end 
	end 

endmodule