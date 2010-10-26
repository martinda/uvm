//----------------------------------------------------------------------
//   Copyright 2010 Mentor Graphics Corporation
//   Copyright 2010 Synopsys, Inc.
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

//----------------------------------------------------------------------
// Title: tlm ports
//
// class definitions of port classes that connect tlm interfaces
//
// blocking transport backward port : <tlm_b_transport_port>
//
// non-blocking transport forward port : <tlm_nb_transport_fw_port>
//
// non-blocking transport backward port : <tlm_nb_transport_bw_port>
//
//----------------------------------------------------------------------

// class: tlm_b_transport_port
//
// Class providing the blocking transport port,
// The port can be bound to one export.
// There is no backward path for the blocking transport.

class tlm_b_transport_port #(type T=tlm_generic_payload)
  extends uvm_port_base #(tlm_if #(T));
  `UVM_PORT_COMMON(`TLM_B_MASK, "tlm_b_transport_port")
  `TLM_B_TRANSPORT_IMP(this.m_if, T, t, delay)
endclass


// class: tlm_nb_transport_fw_port
//
// Class providing the non-blocking backward transport port.
// Transactions received from the producer, on the forward path, are
// sent back to the producer on the backward path using this
// non-blocking transport port.
// The port can be bound to one export.
//
  
class tlm_nb_transport_fw_port #(type T=tlm_generic_payload,
                                 type P=tlm_phase_e)
  extends uvm_port_base #(tlm_if #(T,P));
  `UVM_PORT_COMMON(`TLM_NB_FW_MASK, "tlm_nb_transport_fw_port")
  `TLM_NB_TRANSPORT_FW_IMP(this.m_if, T, P, t, p, delay)
endclass

// class: tlm_nb_transport_bw_port
//
// Class providing the non-blocking backward transport port.
// Transactions received from the producer, on the forward path, are
// sent back to the producer on the backward path using this
// non-blocking transport port
// The port can be bound to one export.
//
  
class tlm_nb_transport_bw_port #(type T=tlm_generic_payload,
                                 type P=tlm_phase_e)
  extends uvm_port_base #(tlm_if #(T,P));
  `UVM_PORT_COMMON(`TLM_NB_BW_MASK, "tlm_nb_transport_bw_port")
  `TLM_NB_TRANSPORT_BW_IMP(this.m_if, T, P, t, p, delay)
endclass

