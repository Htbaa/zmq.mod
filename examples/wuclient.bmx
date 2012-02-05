Rem
	Weather Update client
	Connects SUB socket to tcp://127.0.0.1:6000
	Collects weather updates and finds average temperature in zip code
End Rem
SuperStrict
Import htbaapub.zmq

Local context:TZMQ_Context = New TZMQ_Context.Create(1)
Local subscriber:TZMQ_Socket = context.Socket(ZMQ_SUB)
subscriber.Connect("tcp://127.0.0.1:6000")
'Subscribe to zipcode: NYC
Local filter:String = "10002"
subscriber.SetSockOpt(ZMQ_SUBSCRIBE, filter)

Local total_temp:Int
Local update_count:Int = 100

For Local i:Int = 1 To update_count
	Local msg:TZMQ_Message = subscriber.Recv()
	Local parts:String[] = msg.ToString().Split(" ")
	total_temp :+ parts[1].ToInt()
	Print msg.ToString()
	msg.Close()
Next

Print "Average temperature for zipcode '" + filter + "' was " + (total_temp / update_count)