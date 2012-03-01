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
	bbdoc: Type that represents a ZMQ socket
End Rem
Type TZMQ_Socket

	Rem
		bbdoc: Pointer to a ZMQ context
	End Rem
	Field context:Byte Ptr

	Rem
		bbdoc: Pointer to a ZMQ socket
		about: Use @Close() to free socket
	End Rem
	Field socket:Byte Ptr

	Rem
		bbdoc: Create a ZMQ Socket
		returns: TZMQ_Socket
		about: Throws a TZMQ_Exception on errors
	End Rem
	Method Create:TZMQ_Socket(context:Byte Ptr, socket_type:Int)
		If socket Then Throw "Socket already exists!"
		Self.context = context
		Self.socket = zmq_socket(Self.context, socket_type)
		If Self.socket = Null Then Throw New TZMQ_Socket_Exception
		Return Self
	End Method

	Rem
		bbdoc: Destructor
		about: Will call @Close() when collected
	End Rem
	Method Destroy()
		Self.Close()
	End Method
	
	Rem
		bbdoc: Bind to an address
		about: Throws a TZMQ_Exception on errors
	End Rem
	Method Bind(address:String)
		Local rc:Int = zmq_bind(Self.socket, address)
		If rc = -1 Then Throw New TZMQ_Socket_Exception
	End Method

	Rem
		bbdoc: Connect to a ZMQ socket
		about: Throws a TZMQ_Exception on errors
	End Rem
	Method Connect(address:String)
		Local rc:Int = zmq_connect(Self.socket, address)
		If rc = -1 Then Throw New TZMQ_Socket_Exception
	End Method
	
	Rem
		bbdoc: Close socket
		about: Throws a TZMQ_Exception on errors
	End Rem
	Method Close()
		Local rc:Int = zmq_close(Self.socket)
		If rc = -1 Then Throw New TZMQ_Socket_Exception
	End Method
	
	Rem
		bbdoc: Set a socket option
		about: Throws a TZMQ_Exception on errors
	End Rem
	Method SetSockOpt(socket_option:Int, value:String)
		Local rc:Int = zmq_setsockopt(Self.socket, socket_option, value, value.Length)
		If rc = -1 Then Throw New TZMQ_Socket_Exception
	End Method

	Rem
		bbdoc: Get a socket options
		about: Not yet implemented!
	End Rem
	Method GetSockOpt(socket_option:Int)
		Throw "Not yet implemented"
	End Method
	
	Rem
		bbdoc: Send message to socket
		about: Throws a TZMQ_Exception on errors
		message can either be a String, which will be converted to a TZMQ_Message,
		or you can pass a TZMQ_Message straight away
	End Rem
	Method Send(message:Object, flags:Int = 0)
		If TZMQ_Message(message)
			Local rc:Int = zmq_send(Self.socket, TZMQ_Message(message).message, flags)
			If rc = -1 Then Throw New TZMQ_Socket_Exception
		Else If String(message)
			Local content:String = String(message)
			Local msg:TZMQ_Message = New TZMQ_Message.CreateFromString(content)
			Try
				Self.Send(msg, flags)
				msg.Close()
			Catch ex:TZMQ_Socket_Exception
				msg.Close()
				Throw ex
			End Try
		End If
	End Method
	
	Rem
		bbdoc: Receive message from socket
		returns: TZMQ_Message
	End Rem
	Method Recv:TZMQ_Message(flags:Int = 0)
		Local msg:Byte Ptr = bmx_zmq_message_t()
		zmq_msg_init(msg)
		If zmq_recv(Self.socket, msg, flags) = -1 Then Return Null
		Return New TZMQ_Message.CreateFromMessage(msg)
	End Method
End Type