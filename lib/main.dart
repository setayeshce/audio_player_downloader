import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'audio_controller.dart';
import 'download_controller.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      home: AudioPlayerScreen(),
    );
  }
}
class AudioPlayerScreen extends StatelessWidget {
  final audioController = Get.put(AudioController());
  final downloadController = Get.put(DownloadController());

  @override
  Widget build(BuildContext context) {
    final audioUrl = 'https://www.learningcontainer.com/wp-content/uploads/2020/02/Sample-FLAC-File.flac';

    return Scaffold(
      appBar: AppBar(
        title: Text('Audio Player Example'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _buildPlayerStateText(),
            SizedBox(height: 20),
            _buildDurationText(),
            _buildPositionText(),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => audioController.play(audioUrl),
              child: Text('Play'),
            ),
            ElevatedButton(
              onPressed: audioController.pause,
              child: Text('Pause'),
            ),
            ElevatedButton(
              onPressed: audioController.stop,
              child: Text('Stop'),
            ),
            _buildDownloadButton(audioUrl),
            _buildDownloadProgress(),
            _buildSlider(),
          ],
        ),
      ),
    );
  }

  Widget _buildPlayerStateText() {
    return Obx(() => Text('Player State: ${audioController.playerState}'));
  }

  Widget _buildDurationText() {
    return Obx(() => Text('Duration: ${audioController.duration.value.inSeconds} seconds'));
  }

  Widget _buildPositionText() {
    return Obx(() => Text('Position: ${audioController.position.value.inSeconds} seconds'));
  }

  Widget _buildDownloadButton(String audioUrl) {
    return Obx(() {
      if (audioController.localFilePath.isEmpty) {
        return ElevatedButton(
          onPressed: downloadController.isDownloading.value ? null : () async {
            String path = await downloadController.downloadAudio(audioUrl);
            audioController.localFilePath = path;
          },
          child: Text('Download'),
        );
      } else {
        return SizedBox.shrink();
      }
    });
  }

  Widget _buildDownloadProgress() {
    return Obx(() {
      if (downloadController.isDownloading.value) {
        return Column(
          children: [
            CircularProgressIndicator(value: downloadController.downloadProgress.value),
            SizedBox(height: 20),
            Text('${(downloadController.downloadProgress.value * 100).toStringAsFixed(2)}%'),
          ],
        );
      } else {
        return SizedBox.shrink();
      }
    });
  }

  Widget _buildSlider() {
    return Obx(() => Slider(
      value: audioController.position.value.inSeconds.toDouble(),
      min: 0,
      max: audioController.duration.value.inSeconds.toDouble(),
      onChanged: (double value) {
        audioController.seek(Duration(seconds: value.toInt()));
      },
    ));
  }
}
