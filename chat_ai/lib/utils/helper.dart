import 'package:assets_audio_player/assets_audio_player.dart';
class Helper{
  playSound(String file) async {
    final assetsAudioPlayer = AssetsAudioPlayer();
   await assetsAudioPlayer.open(Audio(file, playSpeed: 1.2));
  }
}