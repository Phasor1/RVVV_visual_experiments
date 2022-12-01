
// 1. first define the OSC message destiation
// to send the evaluated lines of code to
// (change the IP address and port below)
~history_collector = NetAddr("127.0.0.1", 45000);


// 2. then start an 'History' object
History.start;


// 3. and implement the forward function in order to
// send evaluated lines of code to the network via OSC
(
History.forwardFunc_({
	|evaluated_code|
	//evaluated_code.postln;
	~history_collector.sendMsg( "/davide/history", evaluated_code );
});
)

// 4. now evaluate your code!!!


// 5. when you are happy, clear the history and close it
History.clear.end;

// 6. if you want, you can also see everything you have
// evaluated till now
History.showLogFile;


// if you want to test it locally, evaluate the OSC handler here
(
OSCdef( \test_history_collector, {
	| msg, time, addr, recvPort |
	msg[1].postln;
}, '/myname/history', recvPort: 45000);
)



3 + 4

(
"wat"
)



(
Tdef(\print_test, {
	loop{
		var player = [0,1,2].choose;
		switch( player,
			0, {
				~history_collector.sendMsg( "/davide/history", "io\nsono davide" );
			},
			1, {
				~history_collector.sendMsg( "/nicola/history", "io\nsono\nnicola" );
			},
			2, {
				~history_collector.sendMsg( "/daniele/history", "io\nsono daniele\n!!" );
			}
		);
		1.wait;
	};
})
)

Tdef(\print_test).play;
Tdef(\print_test).stop;
Tdef.gui