//----------------------------------------------------------------------
//   Copyright 2007-2009 Mentor Graphics Corporation
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
// class: uvm_resource_proxy
//
// The uvm_resource_proxy#(T) class provides a convenience interface for
// the resources facility.  In many cases basic operations such as
// creating and publishing a resource or acquiring a resource could take
// multiple lines of code using the interfaces in uvm_resource_base or
// uvm_resource#(T).  The convenience layer in uvm_resource_proxy#(T)
// reduce many of those operations to a single line of code.
//
// All of the functions in uvm_resource_proxy#(T) are static, so they
// must be called using the :: operator.  For example:
//
//|  uvm_resource_proxy#(int)::write_and_publish("A", "*", 17, this);
//
// The parameter value "int" identifies the resource type as
// uvm_resource#(int).  Thus, the type of the object in the resource
// container is int. This maintains the type-safety characteristics of
// resource operations.
//----------------------------------------------------------------------
class uvm_resource_proxy #(type T=int);

  typedef uvm_resource #(T) rsrc_t;

  // All of the functions in this class are static, so there is no need
  // to instantiate this class ever.  To make sure that the constructor
  // is never called it's good practice to make it local or at leat
  // protected. However, IUS doesn't support protected constructors so
  // we'll just the default constructor instead.  If support for
  // protected constructors ever becomes available then this comment can
  // be deleted and the protected constructor uncommented.

  //  protected function new();
  //  endfunction

  // function: acquire_by_type
  //
  // Import a resource by type.  The type is specified in the proxy
  // class parameter so the only argument to this funciton is the
  // current scope.

  static function rsrc_t acquire_by_type(string scope);
    return rsrc_t::acquire_by_type(rsrc_t::get_type(), scope);
  endfunction

  // function: acquire_by_name

  // Imports a resource by name.  The first argument is the name of the
  // resource to be acquired and the second argument is the current
  // scope.

  static function rsrc_t acquire_by_name(string name, string scope);
    return rsrc_t::acquire_by_name(name, scope);
  endfunction

  // function: publish 
  //
  // add a new item into the resources database.  The item will not be
  // written to so it will have its default value
  static function rsrc_t publish(string name, string scope);

    rsrc_t r;
    
    r = new(name, scope);
    uvm_resources.publish(r);
    return r;
  endfunction

  // function: write_and_publish
  //
  // Create a new resource, write a value to it, and publish it into the
  // database.
  static function void write_and_publish(input string name, input string scope,
                                        T val, input uvm_object accessor = null);

    rsrc_t rsrc = new(name, scope);
    rsrc.write(val, accessor);
    rsrc.publish();

  endfunction

  // function: write_and_publish_anonymous
  //
  // Create a new resource, write a value to it, and publish it into the
  // database.  The resource has no name and therefore will not be
  // entered into the name map
  static function void write_and_publish_anonymous(input string scope,
                                                  T val, input uvm_object accessor = null);

    rsrc_t rsrc = new("", scope);
    rsrc.write(val, accessor);
    rsrc.publish();

  endfunction


  // function read_by_name
  //
  // locate a resource by name and read its value. The value is returned
  // through the ref argument.  The return value is a bit that indicates
  // whether or not the read was successful.
  static function bit read_by_name(input string name, input string scope,
                                   ref T val, input uvm_object accessor = null);

    rsrc_t rsrc = acquire_by_name(name, scope);

    if(rsrc == null)
      return 0;

    val = rsrc.read(accessor);
    return 1;
  
  endfunction

  // function read_by_type
  //
  // Read a value by type.  The value is returned through the ref
  // argument.  The return value is a bit that indicates whether or not
  // the read is successful.
  static function bit read_by_type(input string scope,
                                   ref T val, input uvm_object accessor = null);
    
    rsrc_t rsrc = acquire_by_type(scope);

    if(rsrc == null)
      return 0;

    val = rsrc.read(accessor);
    return 1;

  endfunction

  // function: write_by_name
  //
  // write a value into the resources database.  First, look up the
  // resource by name.  If it is not located then add a new resource to
  // the database and then write its value.
  static function bit write_by_name(input string name, input string scope,
                                     T val, input uvm_object accessor = null);

    rsrc_t rsrc = acquire_by_name(name, scope);

    if(rsrc == null)
      return 0;

    rsrc.write(val, accessor);
    return 1;

  endfunction

  // function: write_by_type
  //
  // write a value into the resources database.  First, look up the
  // resource by type.  If it is not located then add a new resource to
  // the database and then write its value.
  static function bit write_by_type(input string scope,
                                    input T val, input uvm_object accessor = null);

    rsrc_t rsrc = acquire_by_type(scope);

    // resrouce was not found in the database, so let's add one
    if(rsrc == null)
      return 0;

    rsrc.write(val, accessor);
    return 1;
  endfunction

endclass
