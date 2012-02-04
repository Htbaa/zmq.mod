Rem

	This is a simple example of a threaded application which uses one PUBLISHER
	thread and serveral SUBSCRIBER threads.
End Rem
SuperStrict
Import htbaapub.zmq

Print "ZMQ Version: " + TZMQ.Version()

Global context:TZMQ_Context = New TZMQ_Context.Create(1)
Global addr:String = "tcp://127.0.0.1:6000"

'The Publisher
Function MyPublisherThread:Object(data:Object)
	'Create a ZMQ_PUB socket
	Local socket:TZMQ_Socket = context.Socket(ZMQ_PUB)
	'Bind to socket to the given address
	socket.Bind(addr)
	Repeat
		'Manually create a TZMQ_Message
		Local msg:TZMQ_Message = New TZMQ_Message.Create("Hello world! " + Rnd(100))
		'Send the message to any SUBSCRIBERs
		socket.Send(msg)
		'Free the message
		'would otherwise be garbage collected, but it doesn't hurt to clean up yourself
		msg.Close()
		Delay 1000
		'Send a String without manually creating a TZMQ_Message object
		socket.Send("Foo Bar " + Rnd(100))
		Delay 1000
	Forever
	'We won't get here, but otherwise clean up
	socket.Close()
	Return Null
End Function

'A Subscriber
Function MySubscriberThread:Object(data:Object)
	'Create a SUBSCRIBER socket
	Local socket:TZMQ_Socket = context.Socket(ZMQ_SUB)
	'Connect to given address
	socket.Connect(addr)
	'Set socket option to subscribe, no filter
	socket.SetSockOpt(ZMQ_SUBSCRIBE, Null)
	Repeat
		'Receive message
		Local msg:TZMQ_Message = socket.Recv()
		If msg <> Null
			Print "Subscriber " + String(data) + " received: " + msg.ToString()
			msg.Close()
		End If
	Forever
	'We won't get here, but otherwise clean up
	socket.Close()
	Return Null
End Function

'create a thread!
Local thread1:TThread = CreateThread(MyPublisherThread, Null)
'Increase amount of subcribers to add more SUBSCRIBERS
'but do note that STDOUT will be scrambled
Local subcribers:Int = 1
For Local i:Int = 1 To subcribers
	Print "Starting subscriber " + i
	CreateThread(MySubscriberThread, String(i))
Next

'Wait for the main thread to finish, which is never
Print WaitThread(thread1).ToString()
'Terminate context
context.Term()
