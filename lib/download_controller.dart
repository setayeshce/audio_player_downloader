import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class DownloadController extends GetxController {
  var downloadProgress = 0.0.obs;
  var isDownloading = false.obs;


  Future<String> checkLocalFile(String audioUrl) async {
    final directory = await getApplicationDocumentsDirectory();
    final fileExtension = _getFileExtensionFromUrl(audioUrl);
    final filePath = '${directory.path}/audio.$fileExtension';
    final fileExists = await File(filePath).exists();

    if (fileExists) {
      return filePath;
    }
    return '';
  }

  Future<String> downloadAudio(String audioUrl) async {
    final directory = await getApplicationDocumentsDirectory();
    final fileExtension = _getFileExtensionFromUrl(audioUrl);
    final filePath = '${directory.path}/audio.$fileExtension';
    final dio = Dio();

    isDownloading.value = true;
    update();

    await dio.download(audioUrl, filePath, onReceiveProgress: (received, total) {
      if (total != -1) {
        downloadProgress.value = (received / total);
        update();
      }
    });

    isDownloading.value = false;
    update();
    return filePath;
  }

  String _getFileExtensionFromUrl(String url) {
    return url.split('.').last;
  }
}
