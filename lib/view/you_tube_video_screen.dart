import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pod_player/pod_player.dart';

class PlayVideoFromYoutube extends StatefulWidget {
  final String url;
  const PlayVideoFromYoutube({super.key, required this.url});

  @override
  State<PlayVideoFromYoutube> createState() => _PlayVideoFromYoutubeState();
}

class _PlayVideoFromYoutubeState extends State<PlayVideoFromYoutube> {
  PodPlayerController? controller;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadVideo();
  }

  void loadVideo() async {
    try {
      final urls = await PodPlayerController.getYoutubeUrls(widget.url);

      if (urls == null || urls.isEmpty) {
        Get.snackbar("Error", "Unable to fetch video URLs");
        setState(() => isLoading = false);
        return;
      }

      controller = PodPlayerController(
        playVideoFrom: PlayVideoFrom.networkQualityUrls(videoUrls: urls),
        podPlayerConfig: const PodPlayerConfig(videoQualityPriority: [240]),
      );

      await controller!.initialise();
      setState(() => isLoading = false);
    } catch (e) {
      setState(() => isLoading = false);
      Get.snackbar("Error", "Failed to load video: $e");
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("YouTube Player")),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : controller == null
          ? const Center(child: Text("Failed to load video."))
          : Center(child: PodVideoPlayer(controller: controller!)),
    );
  }
}
