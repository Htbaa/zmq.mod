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

'Socket Types
Const ZMQ_PAIR:Int = 0
Const ZMQ_PUB:Int = 1
Const ZMQ_SUB:Int = 2
Const ZMQ_REQ:Int = 3
Const ZMQ_REP:Int = 4
Const ZMQ_DEALER:Int = 5
Const ZMQ_ROUTER:Int = 6
Const ZMQ_PULL:Int = 7
Const ZMQ_PUSH:Int = 8
Const ZMQ_XPUB:Int = 9
Const ZMQ_XSUB:Int = 10

'Socket Options
Const ZMQ_HWM:Int = 1
Const ZMQ_SWAP:Int = 2
Const ZMQ_AFFINITY:Int = 4
Const ZMQ_IDENTITY:Int = 5
Const ZMQ_SUBSCRIBE:Int = 6
Const ZMQ_UNSUBSCRIBE:Int = 7
Const ZMQ_RATE:Int = 8
Const ZMQ_RECOVERY_IVL:Int = 9
Const ZMQ_MCAST_LOOP:Int = 10
Const ZMQ_SNDBUF:Int = 11
Const ZMQ_RCVBUF:Int = 12
Const ZMQ_RCVMORE:Int = 13
Const ZMQ_FD:Int = 14
Const ZMQ_EVENTS:Int = 15
Const ZMQ_TYPE:Int = 16
Const ZMQ_LINGER:Int = 17
Const ZMQ_RECONNECT_IVL:Int = 18
Const ZMQ_BACKLOG:Int = 19
Const ZMQ_RECOVERY_IVL_MSEC:Int = 20   'opt. recovery time, reconcile in 3.x
Const ZMQ_RECONNECT_IVL_MAX:Int = 21

'Send/recv options
Const ZMQ_NOBLOCK:Int = 1
Const ZMQ_SNDMORE:Int =  2

'I/O multiplexing
Const ZMQ_POLLIN:Int = 1
Const ZMQ_POLLOUT:Int = 2
Const ZMQ_POLLERR:Int = 4

'Built-in devices
Const ZMQ_STREAMER:Int = 1
Const ZMQ_FORWARDER:Int = 2
Const ZMQ_QUEUE:Int = 3
