MultithreadedTCPserver
======================

To use this service:

./start.sh ... This starts the Server session

ruby Client.rb "Your Message" ... sends a request including your message to the server.

	1. ruby Client.rb "HELO text\n"
    	   "HELO text\nIP:[ip address]\nPort:[port number]\nStudentID:[your student ID]\n"

	2. ruby Client.rb "KILL_SERVICE\n"
	   Terminate Service

	3. Any other message will simply give you back a greeting response.

