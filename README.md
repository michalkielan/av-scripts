[![build](https://github.com/michalkielan/av-scripts/actions/workflows/build.yml/badge.svg?branch=master)](https://github.com/michalkielan/av-scripts/actions/workflows/build.yml)
[![tests](https://github.com/michalkielan/av-scripts/actions/workflows/tests.yml/badge.svg?branch=master)](https://github.com/michalkielan/av-scripts/actions/workflows/tests.yml)

# av-scripts
A collection of scripts designed to help with transcoding and manipulating audio and video files, useful for video editing tasks. Scripts written in bash leverages FFmpeg to process media files in various ways.

## Features
* Video Transcoding: Convert between different video codecs (e.g., H.265, ProRes) and formats.
* Audio Manipulation: Extract, replace, or convert audio tracks from video files.
* Resolution and Quality Adjustments: Resize and adjust video quality for proxy files.
* Metadata Management: Copy or modify metadata, including tags, titles, and subtitles.
* Batch Processing: Automate and process multiple files simultaneously for large-scale media projects.

## Requirements
* FFmpeg: Ensure FFmpeg is installed and available on your system. If using hardware-accelerated encoding, ensure that your system has an necessary GPU drivers installed.
* CUDA-capable NVIDIA GPU or Apple silicon for hardware-accelerated transcoding.

## Installation

Clone repository, navigate into the project directory and run the `bootstrap` script to configure `PATH`

```
$ git clone https://github.com/michalkielan/av-scripts.git
$ cd av-scripts
$ ./bootstrap
```

## Usage
Transcode a video to H.265 using hardware encoder.

`$ to_h265`

Transcode a video to AV1.

`$ to_av1`

Export to PCM audio.

`$ to_pcm`

Transcode audio file to AAC.

`$ to_aac <audio file>`

Generate proxy videos for editing.

`$ gen_proxy <output path (optional, default: current directory)>`

Generate media info for videos.

`$ gen_mediainfo`

Download audio from youtube video

`$ yt_audio <youtube video link`

Separate vocal from audio file.

`$ split_audio <audio file>`

## Testing
The tests are written using Bats (Bash Automated Testing System) framework.

`$ bats tests`

## License
[MIT](https://github.com/michalkielan/av-scripts/blob/master/LICENSE)
