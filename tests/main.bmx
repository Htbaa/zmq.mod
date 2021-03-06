SuperStrict
Framework bah.maxunit
Import htbaapub.zmq

New TTestSuite.run()

Type TZMQ_Test Extends TTest

	Method Setup() {before}
	End Method
	
	Method Teardown() {after}
	End Method

	Method Version() {test}
		Local parts:String[] = TZMQ.Version().Split(".")
		assertTrue(parts.Length = 3, "Version string contains 3 parts")
	End Method
	
	'Make sure recreating an existing context isn't possible
	Method ContextReCreate() {test}
		Local ct:TZMQ_Context = New TZMQ_Context.Create()
		Try
			ct = ct.Create()
		Catch ex:String
			assertNotNull(ex, "Recreating context failed properly")
		Catch ex:TZMQ_Exception
			fail(ex.ToString())
		End Try
		ct.Term()
	End Method

	'Make sure a socket can be created
	Method SocketCreate() {test}
		Local ct:TZMQ_Context = New TZMQ_Context.Create()
		Local socket:TZMQ_Socket = ct.socket(ZMQ_PUB)
		assertNotNull(socket, "Created socket")
		assertTrue(socket.socket <> Null, "Created pointer to socket")
		socket.Close()
		ct.Term()
	End Method

	'Make sure created messages contain expected data
	Method MessageCreationFromStringIntegrity() {test}
		For Local i:Int = 0 To 1000
			Local text:String = "Message " + i
			Local msg:TZMQ_Message = New TZMQ_Message.CreateFromString(text)
			assertEquals(text, msg.ToString(), "Message text match")
			assertEqualsI(text.Length, msg.Size(), "Message size match")
			msg.Close()
		Next
	End Method

	'Make sure created messages contain expected data
	Method MessageCreationFromPointerIntegrity() {test}
		For Local i:Int = 0 To 1000
			Local text:String = "Message " + i
			Local msg:TZMQ_Message = New TZMQ_Message.Create(text.ToCString(), text.Length)
			assertEquals(text, msg.ToString(), "Message text match")
			assertEqualsI(text.Length, msg.Size(), "Message size match")
			msg.Close()
			assertTrue(msg.content = Null, "Message data freed")
		Next
	End Method
	
	'Make sure exchanged messages aren't corrupt
	Method MessageExchangingIntegrity() {test}
		Local addr:String = "tcp://127.0.0.1:6000"
		Local ct:TZMQ_Context = New TZMQ_Context.Create()
		Local publisher:TZMQ_Socket = ct.socket(ZMQ_PUB)
		Local subscriber:TZMQ_Socket = ct.socket(ZMQ_SUB)
		
		publisher.Bind(addr)
		subscriber.Connect(addr)
		subscriber.SetSockOpt(ZMQ_SUBSCRIBE , Null)

		Delay 1000
		For Local i:Int = 0 To 10
			Delay 10
			Local text:String = "Message " + i
			publisher.Send(text)
			Local msg:TZMQ_Message = subscriber.Recv()
			If msg = Null Then Continue
			assertEquals(text, msg.ToString(), "Message " + i + " match")
			assertEqualsI(text.Length, msg.Size(), "Message " + i + " size match")
			msg.Close()
		Next
		
		subscriber.Close()
		publisher.Close()
		ct.Term()
	End Method
End Type
