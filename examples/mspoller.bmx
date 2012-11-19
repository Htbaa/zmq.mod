SuperStrict
Import htbaapub.zmq
Local context:TZMQ_Context = New TZMQ_Context.Create()

'Connect to the task ventilator
Local receiver:TZMQ_Socket = context.Socket(ZMQ_PULL)
receiver.Connect("tcp://localhost:5557")

'Connect to the weather server
Local subscriber:TZMQ_Socket = context.Socket(ZMQ_SUB)
subscriber.Connect("tcp://localhost:6000")
'subscriber.SetSockOpt(ZMQ_SUBSCRIBE, "10001")
subscriber.SetSockOpt(ZMQ_SUBSCRIBE, "10")

'Initialize poll set
Local items:TZMQ_Poller_Item[2]
items[0] = new TZMQ_Poller_Item.Create(receiver, "receiver", ZMQ_POLLIN)
items[1] = New TZMQ_Poller_Item.Create(subscriber, "subscriber", ZMQ_POLLIN)
Local poller:TZMQ_Poller = New TZMQ_Poller.Create(items)

'Process messages from both sockets
'We prioritize traffic from the task ventilator
Repeat
	poller.Poll()
	
	If poller.HasEvent("receiver")
		Local task:TZMQ_Message = receiver.Recv()
		'Process task
	End If

	If poller.HasEvent("subscriber")
		Local update:TZMQ_Message = subscriber.Recv()
		'Process weather update
		DebugLog update.ToString()
	End If
Forever