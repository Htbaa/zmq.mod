SuperStrict
Import htbaapub.zmq
Local context:TZMQ_Context = New TZMQ_Context.Create()

'Connect to the task ventilator
Local receiver:TZMQ_Socket = context.Socket(ZMQ_PULL)
receiver.Connect("tcp://localhost:5557")

'Connect to the weather server
Local subscriber:TZMQ_Socket = context.Socket(ZMQ_SUB)
subscriber.Connect("tcp://localhost:6000")
subscriber.SetSockOpt(ZMQ_SUBSCRIBE, "10001")

'Process messages from both sockets
'We prioritize traffic from the task ventilator
Repeat
	'Process any waiting tasks
	Repeat
		Local task:TZMQ_Message = receiver.Recv(ZMQ_NOBLOCK)
		If task = Null Then Exit		
	Forever
	
	'Process any waiting weather updates
	Repeat
		Local update:TZMQ_Message = subscriber.Recv(ZMQ_NOBLOCK)
		If update = Null Then Exit
	Forever
	
	'No activity, so sleep for 1 msec
	Delay 1
Forever