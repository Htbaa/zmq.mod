Rem
	Weather Update server
	Binds PUB socket to tcp://127.0.0.1:6000
	Publishes random weather updates
End Rem
SuperStrict
Import htbaapub.zmq

Local context:TZMQ_Context = New TZMQ_Context.Create(1)
Local publisher:TZMQ_Socket = context.Socket(ZMQ_PUB)
publisher.Bind("tcp://127.0.0.1:6000")
?Not Win32
publisher.Bind("ipc://weather.ipc")
?

Repeat
	Local zipcode:Int = Rand(1, 100000)
	Local temperature:Int = Rand(1,215) - 80
	Local relhumidity:Int = Rand(1,50) + 10
	Local update:String = " ".Join([String(zipcode), String(temperature), String(relhumidity)])
	publisher.Send(update)
Forever
