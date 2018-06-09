# ainjectortest - Audio Injector Stereo Sound Card test

Based on [this](//github.com/Audio-Injector/stereo-and-zero/blob/master/audio.injector.scripts-0.1/audioInjector-test.sh) test script.

----

The script which plays a pulsing 10 kHz tone at high volume through the system.
To use it, make sure you don't have speakers plugged in!
Plug in an RCA cable from input to output (Red to Red, White to White).
Also plug cheap headphones into the headphone jack and place them near to the Audio Injector so that the microphone can hear them.
Lastly run the script:

```
ainjectortest.sh line-in
```

and then

```
ainjectortest.sh mic
```

Two PNG files should be created: **audio-injector-line-in.png** and **audio-injector-mic.png**.

----

Required utilities: *ffmpeg*, *arecord*, *aplay*, *bc*.
