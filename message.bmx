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

Rem
	bbdoc: A type that represents a ZMQ message
End Rem
Type TZMQ_Message

	Rem
		bbdoc: ZMQ Message
		about: Call @Close() to free message
	End Rem
	Field message:Byte Ptr

	Rem
		bbdoc: Create a ZMQ message
		returns: TZMQ_Message
		about: Throws a TZMQ_Exception on errors
	End Rem
	Method Create:TZMQ_Message(data:String)
		Self.message = bmx_zmq_message_t()
		Local rc:Int = zmq_msg_init_data(Self.message, data, data.Length, Null, Null)
		If rc = -1 Then Throw New TZMQ_Message_Exception
		Return Self
	End Method
	
	Rem
		bbdoc: Create a new TZMQ_Message based on a ZMQ message
		returns: TZMQ_Message
	End Rem
	Method CreateFromMessage:TZMQ_Message(message:Byte Ptr)
		Self.message = message
		Return Self
	End Method
	
	Rem
		bbdoc: ZMQ Message
		about: Will call @Close() when collected
	End Rem
	Method Delete()
		Self.Close()
	End Method

	Rem
		bbdoc: Close message
		about: Release ZMQ message
	End Rem
	Method Close()
		If Self.message = Null Then Return
		Local rc:Int = zmq_msg_close(Self.message)
		If rc = -1 Then Throw New TZMQ_Message_Exception
		bmx_zmq_free(Self.message)
		Self.message = Null
	End Method
	
	Rem
		bbdoc: Retrieve pointer to message data
	End Rem
	Method Data:Byte Ptr()
		Return zmq_msg_data(Self.message)
	End Method

	Rem
		bbdoc: Retrieve size of message data
	End Rem	
	Method Size:Int()
		Return zmq_msg_size(Self.message)
	End Method
	
	Rem
		bbdoc: Convert message data to a string
		returns: String
	End Rem
	Method ToString:String()
		Return String.FromBytes(Self.Data(), Self.Size())
	End Method
End Type