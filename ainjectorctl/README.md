# ainjectorctl - mixer tool for Audio Injector Stereo Sound Card for Raspberry Pi.

Sound card info/support: [Stereo Raspberry Pi sound card](http://www.audioinjector.net/rpi-hat).

## Usage

### Sound card initialization

```
ainjectorctl init-playback
```

or 

```
ainjectorctl init
```

### Playback

```
ainjectorctl playback-to line-out
```

or

```
ainjectorctl playback line
```

### Record

#### From line-in

```
ainjectorctl record-from line-in
```

or 

```
ainjectorctl record line
```

#### From microphone

```
ainjectorctl record-from mic
```

or

```
ainjectorctl record mic
```

#### Turn off recoding settings

```
ainjectorctl record off
```

### Listen / monitor

#### Listen line-in

```
ainjectorctl listen line-in
```

or

```
ainjectorctl monitor line
```

#### Listen microphone

```
ainjectorctl listen mic
```

or

```
ainjectorctl monitor mic
```

#### Turn off listening

```
ainjectorctl monitor off`
```
