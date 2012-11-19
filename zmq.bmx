Rem
	Copyright (c) 2012 Christiaan Kras
	
	Permission is hereby granted, free of charge, to any person obtaining a copy
	of this software and associated documentation files (the "Software"), to deal
	in the Software without restriction, including without limitation the rights
	to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
	copies of the Software, and to permit persons to whom the Software is
	furnished to do so, subject to the following conditions:
	
	The above copyright notice and this permission notice shall be included in
	all copies or substantial portions of the Software.
	
	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
	OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
	THE SOFTWARE.
End Rem

SuperStrict

Rem
	bbdoc: htbaapub.zmq
	about: This module is still an early work in progress. If you run into any
	bugs please report them at <a href='https://github.com/Htbaa/zmq.mod/issues'>https://github.com/Htbaa/zmq.mod/issues</a>.
EndRem
Module htbaapub.zmq
ModuleInfo "Name: htbaapub.zmq"
ModuleInfo "Description: A wrapper for ZeroMQ"
ModuleInfo "Version: 0.04"
ModuleInfo "License: MIT"
ModuleInfo "Author: Christiaan Kras"
ModuleInfo "ZeroMQ: <a href='http://www.zeromq.org'>http://www.zeromq.org</a>"
ModuleInfo "ZeroMQ License: LGPL (see contents of ./zeromq)"
ModuleInfo "Git repository: <a href='https://github.com/Htbaa/zmq.mod/'>https://github.com/Htbaa/zmq.mod/</a>"
ModuleInfo "Issues: <a href='https://github.com/Htbaa/zmq.mod/issues'>https://github.com/Htbaa/zmq.mod/issues</a>"
ModuleInfo "History: Added msreader example"
ModuleInfo "ZeroMQ Windows binaries: <a href='http://www.zeromq.org/distro:microsoft-windows'>http://www.zeromq.org/distro:microsoft-windows</a>"
ModuleInfo "History: Added new constants ZMQ_RCVTIMEO and ZMQ_SNDTIMEO"
ModuleInfo "History: 0.04"
ModuleInfo "History: Updated to ZMQ 2.2.0"
ModuleInfo "History: Updated example1 to reflect API changes"
ModuleInfo "History: Improved test coverage"
ModuleInfo "History: 0.03"
ModuleInfo "History: Fixed message data corruption for first sent message (gh-3)"
ModuleInfo "History: Added TZMQ_Message.CreateFromString to create messages from a String. The TZMQ_Message.Create signature has also changed to accept a Byte Ptr and a length"
ModuleInfo "History: Fixed potential memory leak in TZMQ_Socket.Send when an exception would be raised"
ModuleInfo "History: Added TZMQ_Socket_Exception and TZMQ_Message_Exception"
ModuleInfo "History: Added a couple of unit tests (bah.maxunit required)"
ModuleInfo "History: 0.02"
ModuleInfo "History: Added more examples; Hello World server and client"
ModuleInfo "History: Added more examples; Weather Update server and client"
ModuleInfo "History: TZMQ_Socket.SetSockOpt() now properly sets options"
ModuleInfo "History: TZMQ_Message.Close() now properly frees up memory"
ModuleInfo "History: 0.01"
ModuleInfo "History: First release of htbaapub.zmq using ZMQ 2.1.11. No support yet for input/output multiplexing with zmq_poll()"

?Linux
	Import "-lzmq"
?Win32
	Import "zeromq/lib/libzmq-v100-mt.lib"
?

Import "glue.c"
Include "exception.bmx"
Include "constants.bmx"
Include "context.bmx"
Include "socket.bmx"
Include "message.bmx"
Include "poller.bmx"

'Glue/Helper functions
Extern "C"

	Rem
		bbdoc: Create an empty zmq_message_t struct
		returns: Returns a pointer to a new zmq_message_t struct
	End Rem
	Function bmx_zmq_message_t:Byte Ptr()

	Rem
		bbdoc: Create a zmq_message_t struct with preset data
		returns: Returns a pointer to a new zmq_message_t struct with given data
	End Rem
	Function bmx_zmq_new_message:Byte Ptr(str$z)
	
	Rem
		bbdoc: Alias for free(), for cleaning up data structures
	End Rem
	Function bmx_zmq_free(msg:Byte Ptr)
	
	Function bmx_zmq_pollitem_t:Byte Ptr(socket:Byte Ptr, events:Byte)
	
	Function bmx_zmq_pollitem_t_get_events:Short(item:Byte Ptr)
	Function bmx_zmq_pollitem_t_get_revents:Short(item:Byte Ptr)
End Extern

'ZeroMQ functions
Extern
	Function zmq_version(major:Int Var, minor:Int Var, patch:Int Var)

	Function zmq_init:Byte Ptr(io_threads:Int)
	Function zmq_term:Int(context:Byte Ptr)
	
	Function zmq_errno:Int()
	Function zmq_strerror$z(errnum:Int)
	
	Function zmq_socket:Byte Ptr(context:Byte Ptr, socket_type:Int)
	Function zmq_close:Int(s:Byte Ptr)
	Function zmq_setsockopt:Int(s:Byte Ptr, option:Int, optval$z, length:Int)
	Function zmq_getsockopt:Int(s:Byte Ptr, option:Int, optval:Byte Ptr, length:Int Var)
	'ZMQ_EXPORT Int zmq_getsockopt (void *s, Int option, void *optval, size_t *optvallen);
	Function zmq_bind(s:Byte Ptr, addr$z)
	Function zmq_connect:Int(s:Byte Ptr, addr$z)
	Function zmq_send:Int(s:Byte Ptr, msg:Byte Ptr, flags:Int)
	Function zmq_recv:Int(s:Byte Ptr, msg:Byte Ptr, flags:Int)

	Function zmq_msg_init:Int(msg:Byte Ptr)
	Function zmq_msg_init_size:Int(msg:Byte Ptr, size:Long)
	Function zmq_msg_init_data:Int(msg:Byte Ptr, data:Byte Ptr, size:Long, ffn:Byte Ptr, hint:Byte Ptr)
	Function zmq_msg_close:Int(msg:Byte Ptr)
	Function zmq_msg_move:Int(dest:Byte Ptr, src:Byte Ptr)
	Function zmq_msg_copy:Int(dest:Byte Ptr, src:Byte Ptr)
	Function zmq_msg_data:Byte Ptr(msg:Byte Ptr)
	Function zmq_msg_size:Int(msg:Byte Ptr)
	
	Function zmq_poll:Int(items:Byte Ptr, nitems:Int, timeout:Long)
	
	Function zmq_device:Int(device:Int, insocket:Byte Ptr, outsocket:Byte Ptr)
End Extern

Rem
	bbdoc: General ZMQ functions
End Rem
Type TZMQ

	Rem
		bbdoc: Get ZMQ Version
		returns: String
	End Rem
	Function Version:String()
		Local major:Int, minor:Int, patch:Int
		zmq_version(major, minor, patch)
		Return major + "." + minor + "." + patch
	End Function

	Rem
		bbdoc: Get current ZMQ error descriptions
		returns: String
	End Rem
	Function Error:String()
		Return zmq_strerror( TZMQ.ErrorNumber() )
	End Function

	Rem
		bbdoc: Get current ZMQ error number
		returns: Int
	End Rem
	Function ErrorNumber:Int()
		Return zmq_errno()
	End Function
End Type