/*
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
*/
#ifdef WIN32
#include "zeromq/include/zmq.h"
#else
#include <zmq.h>
#endif

zmq_msg_t * bmx_zmq_message_t() {
	zmq_msg_t *msg;
	msg = malloc(sizeof(zmq_msg_t));
	return msg;	
}

void bmx_zmq_free(zmq_msg_t *msg) {
	if(msg) {
		free(msg);
		msg = NULL;
	}
}

zmq_msg_t * bmx_zmq_new_message(const char *string) {
	int length = strlen(string);
	zmq_msg_t *msg;
	msg = malloc(sizeof(zmq_msg_t));
	zmq_msg_init_size (msg, length);
	memcpy(zmq_msg_data(msg), string, length);
	return msg;
}

zmq_pollitem_t * bmx_zmq_pollitem_t(void *socket, short events) {
	zmq_pollitem_t *item = { socket, 0, events, 0};
	return item;
}

short bmx_zmq_pollitem_t_get_events(zmq_pollitem_t *item) {
	return item.events;
}

short bmx_zmq_pollitem_t_get_revents(zmq_pollitem_t *item) {
	return item.revents;
}