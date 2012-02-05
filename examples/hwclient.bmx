Rem
	Hello World client
	Connects REQ socket to tcp://127.0.0.1:6000
	Sends "Hello" to server, expects "World" back
End Rem
SuperStrict
Import htbaapub.zmq

Local context:TZMQ_Context = New TZMQ_Context.Create(1)
Local requester:TZMQ_Socket = context.Socket(ZMQ_REQ)
requester.Connect("tcp://127.0.0.1:6000")

For Local i:Int = 0 To 9
	Print "Sending request " + i
	requester.Send("Hello")
	Local reply:TZMQ_Message = requester.Recv()
	Print "Received reply " + i + ": " + reply.ToString()
	reply.Close()
Next
