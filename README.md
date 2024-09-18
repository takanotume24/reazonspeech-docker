## ReazonSpeech Docker Image
Docker Image of ReazonSpeech (https://github.com/reazon-research/ReazonSpeech) 

### Build
```
$ ./script/build.sh
```

### Run
1. Create a directory to store the downloaded file
    ```
    $ mkdir -p /tmp/test
    ```

1. Download the file into the created directory
    ```
    $ wget -O /tmp/test/speech-001.wav https://research.reazon.jp/_downloads/a8f2c35bb3d351a76212b2257d5bfc85/speech-001.wav
    ```

1. Run the Docker container with the bind mount
    ```
    $ docker run --rm -v /tmp/test:/data reazonspeech:2.1.0 reazonspeech-nemo-asr /data/speech-001.wav
    ```
