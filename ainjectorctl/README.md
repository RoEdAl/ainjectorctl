# ainjectorctl - mixer tool for Audio Injector Stereo Sound Card for Raspberry Pi

## Usage

1. Sound card initialization: `ainjectorctl init-playback` or `ainjectorctl init`.
1. Playback: `ainjectorctl playback-to line-out` or `ainjectorctl playback line`.
1. Record:
    * From line-in: `ainjectorctl record-from line-in` or `ainjectorctl record line`.
    * From microphone: `ainjectorctl record-from mic` or `ainjectorctl record mic`.
    * Turn off recording: `ainjectorctl record off`.
1. Listen / monitor:
    * Listen line-in: `ainjectorctl listen line-in` or `ainjectorctl monitor line`.
    * Listen microphone: `ainjectorctl listen mic` or `ainjectorctl monitor mic`.
    * Turn off listening: `ainjectorctl listen off` or `ainjectorctl monitor off`.
