import 'package:get/get.dart';
import 'package:audioplayers/audioplayers.dart';

class AudioController extends GetxController {
  AudioPlayer player = AudioPlayer(); // Initialize the player directly here
  var  playerState = PlayerState.stopped.obs;
  var  duration = Duration().obs;
  var  position = Duration().obs;
  String localFilePath = '';

  AudioController() {
    _initAudioPlayer();
  }

  _initAudioPlayer() {
    player.onDurationChanged.listen((Duration d) {
      duration.value = d;
      update();
    });
    player.onPositionChanged.listen((Duration p) {
      position.value = p;
      update();
    });
    player.onPlayerStateChanged.listen((PlayerState state) {
      playerState.value = state;
      update();
    });
  }

  Future<void> play(String audioUrl) async {
    if (localFilePath.isNotEmpty) {
      await player.setSourceDeviceFile(localFilePath);
    } else {
      await player.setSourceUrl(audioUrl);
    }
    await player.resume();
  }

  Future<void> pause() async {
    await player.pause();
  }

  Future<void> stop() async {
    await player.stop();
  }

  Future<void> seek(Duration newPosition) async {
    await player.seek(newPosition);
  }

  @override
  void onClose() {
    player.dispose();
    super.onClose();
  }
}
