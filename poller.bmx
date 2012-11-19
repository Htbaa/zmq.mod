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
typedef struct
{
    void *socket;
#if defined _WIN32
    SOCKET fd;
#else
    int fd;
#endif
    short events;
    short revents;
} zmq_pollitem_t;

ZMQ_EXPORT int zmq_poll (zmq_pollitem_t *items, int nitems, long timeout);
end rem

Type TZMQ_Poller
	
	Field _events:TList = New TList
	Field _namedEvents:TList = New TList
	Field _pollItems:TList = New TList
	Field _rawPollItems:TList = New TList

	Method Create:TZMQ_Poller(items:TZMQ_Poller_Item[])
		Self._pollItems = TList.FromArray(items)
		Return Self
	End Method

	Method Poll(timeout:Long = -1)
		Self._ClearEvents()
		'Local rc:Int = zmq_poll(Self._items, Self._itemCount, timeout)
		'If rc = -1 Then DebugLog TZMQ.Error()
	End Method
	
	Method _ClearEvents()
		Self._events.Clear()
		Self._namedEvents.Clear()
	End Method

	Method _RawPollItems:TList()
		If Self._rawPollItems.Count() = 0
			For Local item:TZMQ_Poller_Item = EachIn Self._pollItems
				Self._rawPollItems.AddLast(item._GetRawPollItem())
			Next
		End If
		Return Self._rawPollItems
	End Method
	
	Method HasEvent:Byte(name:String)
		Return False
	End Method
	
	Method Destroy()
		DebugLog "Should free all poll items"
	End Method
	
End Type

Type TZMQ_Poller_Item
	Field socket:Byte Ptr
	Field name:String
	Field events:Int
	Field callback()

	Method Create:TZMQ_Poller_Item(socket:Byte Ptr, name:String, events:Int, callback() = Null)
		Self.socket = socket
		Self.name = name
		Self.events = events
		Self.callback = callback
		Return Self
	End Method
	
	Method _GetRawPollItem:Byte Ptr()
		Return bmx_zmq_pollitem_t(Self.socket, Self.events)
	End Method
End Type