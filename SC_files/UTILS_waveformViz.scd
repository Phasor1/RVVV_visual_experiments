// 1. define some env variable
(
~waveform_visualizer = NetAddr("127.0.0.1", 45000);

// audio visualization stuff **********************************
~b_sendWaveformViaOsc = true;
~chunkSize = 2048;
~numChunks = 8;
~relay_buffer.free;
~relay_buffer = Buffer.alloc(s, ~chunkSize * ~numChunks);
)


// 2. define the visualize waveform OSC callback
//    uncomment the line corresponding to your OSC address pattern
(
OSCdef(\visualize_waveform, { |msg|
	// the partition to retrieve is the one BEFORE the latest transition point
	var partition = (msg[3] - 1) % ~numChunks;

	~relay_buffer.getn(partition.asInteger * ~chunkSize, ~chunkSize, { |data|
		var tmp;

		if( ~b_sendWaveformViaOsc, {
			//tmp = (data.as(Array)).collect({|v| (v.clip(-1.0, 1.0)*127).asInteger});
			tmp = (data.as(Array)).collect({|v| (v*127).asInteger});
			//~waveform_visualizer.sendMsg( \waveform, *(data.as(Array)));

			// uncomment your line below
			//~waveform_visualizer.sendMsg( "/davide/waveform", *tmp);
			//~waveform_visualizer.sendMsg( "/nicola/waveform", *tmp);
			//~waveform_visualizer.sendMsg( "/daniele/waveform", *tmp);
		});
	});

}, '/buffer_refresh');
)


// 3. define the synth which is going write your output audio on the buffer
(
SynthDef(\waveformViz, {
	|in=0, amp=1.0,relay_buf|
	var sig = In.ar( in, 2 );

	// ######### visualization stuff
	var phase, trig, partition;
	// #########

	sig = sig * amp;
	//sig[0].poll;

	// ######### visualization stuff
	phase = Phasor.ar(0, 1, 0, ~chunkSize);
	trig = HPZ1.ar(phase) < 0;
	partition = PulseCount.ar(trig) % ~numChunks;
	BufWr.ar( Mix.ar(sig), relay_buf, phase + (~chunkSize * partition));
	SendReply.ar(trig, '/buffer_refresh', partition);
	// #########
}).add;
);


// 4. instantiate your audioViz synth
~synth_audioViz = Synth(\waveformViz, [\in, 0, \relay_buf, ~relay_buffer], target:s.defaultGroup, addAction:\addAfter);
~synth_audioViz.set(\in, 0, \relay_buf, ~relay_buffer);
~synth_audioViz.free;

// eventually scale down the value you are sending to the visuals server
~synth_audioViz.set(\amp, 0.25);



// TEST AREA ////////////////////////////////////////////////////////////////////////////
~relay_buffer.free
s.plotTree;


(
Pbindef(\test,
	\degree, Pseq((0..7),inf),
		\dur, 1,
		\amp, 1,
).quant_([4]).play;
)

Pbindef(\test).stop;