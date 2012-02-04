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
	bbdoc: Type that represents a ZMQ Context
End Rem
Type TZMQ_Context
	
	Rem
		bbdoc: ZMQ Context
		about: Use @Term() to free context
	End Rem
	Field context:Byte Ptr

	Rem
		bbdoc: Creates a new ZMQ context
		returns: TZMQ_Context
		about: Throws a TZMQ_Exception on error
	End Rem
	Method Create:TZMQ_Context(io_threads:Int = 1)
		If context Then Throw "Context already exists!"
		Self.context = zmq_init(io_threads)
		If Self.context = Null Then Throw New TZMQ_Exception
		Return Self
	End Method
	
	Rem
		bbdoc: Destructor
		about: Will call @Term() when collected
	End Rem
	Method Destroy()
		Self.Term()
	End Method
	
	Rem
		bbdoc: Terminate ZMQ context
	End Rem
	Method Term()
		Local rc:Int = zmq_term(Self.context)
		If rc = -1 Then Throw New TZMQ_Exception
	End Method
	
	Rem
		bbdoc: Create a ZMQ socket
		returns: TZMQ_Socket
		about: Lookup the constants to see which socket types are available
	End Rem
	Method Socket:TZMQ_Socket(socket_type:Int)
		Local socket:TZMQ_Socket = New TZMQ_Socket
		Return socket.Create(Self.context, socket_type)
	End Method
End Type