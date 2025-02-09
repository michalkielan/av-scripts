# av-scripts
A collection of scripts designed to help with transcoding and manipulating audio and video files, useful for video editing tasks. Scripts written in bash leverages FFmpeg to process media files in various ways.

## Features
* Video Transcoding: Convert between different video codecs (e.g., H.265, ProRes) and formats.
* Audio Manipulation: Extract, replace, or convert audio tracks from video files.
* Resolution and Quality Adjustments: Resize and adjust video quality for proxy files.
* Metadata Management: Copy or modify metadata, including tags, titles, and subtitles.
* Batch Processing: Automate and process multiple files simultaneously for large-scale media projects.

## Requirements
* FFmpeg: Ensure FFmpeg is installed and available on your system.
* CUDA-capable NVIDIA GPU or Apple silicon for hardware-accelerated transcoding.

## Installation
Clone the repository:

`$ git clone https://github.com/michalkielan/av-scripts.git`

Navigate into the project directory:

`$ cd av-scripts`

Ensure FFmpeg is installed:

`$ ffmpeg -version`

If using hardware-accelerated encoding, ensure that your system has an necessary GPU drivers installed.

## Usage
Transcode a video to H.265 using hardware encoder.

`$ ./to_h265.sh`

Transcode a video to AV1.

`$ ./to_av1.sh`

Export to PCM audio.

`$ ./to_pcm.sh`

Transcode audio file to AAC.

`$ ./to_aac.sh`

Generate proxy videos for editing.

`$ ./gen_proxy.sh`

Download audio from youtube video

`$ ./yt_audio.sh`

Separate vocal from audio file.

`$ ./split_audio.sh`

## License
[MIT](https://github.com/michalkielan/av-scripts/blob/master/LICENSE)
