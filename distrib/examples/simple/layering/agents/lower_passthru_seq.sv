//----------------------------------------------------------------------
//   Copyright 2013 Synopsys, Inc.
//   All Rights Reserved Worldwide
//
//   Licensed under the Apache License, Version 2.0 (the
//   "License"); you may not use this file except in
//   compliance with the License.  You may obtain a copy of
//   the License at
//
//       http://www.apache.org/licenses/LICENSE-2.0
//
//   Unless required by applicable law or agreed to in
//   writing, software distributed under the License is
//   distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
//   CONDITIONS OF ANY KIND, either express or implied.  See
//   the License for the specific language governing
//   permissions and limitations under the License.
//----------------------------------------------------------------------


class lower_passthru_seq extends uvm_sequence#(lower_item);

  lower_item req;
  
  `uvm_object_utils(lower_passthru_seq)

  function new(string name = "lower_passthru_seq");
    super.new(name);
  endfunction

  virtual task body();
    lower_item m_item;
    
    forever begin
      `uvm_create(m_item);
      start_item(m_item);
      req = m_item;
      wait (req == null);
      finish_item(m_item);
    end
  endtask
endclass
