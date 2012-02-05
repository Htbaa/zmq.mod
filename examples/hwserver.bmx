Rem
	Hello World server
	Binds REP socket to tcp://127.0.0.1:6000
	Expects "Hello" from client, replies with "World"
End Rem
SuperStrict
Import htbaapub.zmq

Local context:TZMQ_Context = New TZMQ_Context.Create(1)
Local responder:TZMQ_Socket = context.Socket(ZMQ_REP)
responder.Bind("tcp://127.0.0.1:6000")

Repeat
	Local request:TZMQ_Message = responder.Recv()
	Print "Received request: " + request.ToString()
	Delay 100
	responder.Send("World")
Forever
