import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pod_player/pod_player.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ListView(
          shrinkWrap: true,
          children: [
            _button(
              'Play video from vimeo',
              onPressed: () {
                Get.to(
                  () => const VimeoVideoViewer(),
                  transition: Transition.cupertino,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _button(String text, {void Function()? onPressed}) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: OutlinedButton(
          onPressed: onPressed ?? () {},
          child: Text(
            text,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}

class VimeoVideoViewer extends StatefulWidget {
  const VimeoVideoViewer({Key? key}) : super(key: key);

  @override
  State<VimeoVideoViewer> createState() => VimeoVideoViewerState();
}

class VimeoVideoViewerState extends State<VimeoVideoViewer> {
  PodPlayerController? controller;
  bool isLoading = true;
  bool hasError = false;

  @override
  void initState() {
    super.initState();
    loadVideo();
  }

  void loadVideo() async {
    try {
      final urls = await PodPlayerController.getVimeoUrls('222018604');
      if (urls == null || urls.isEmpty) {
        Get.snackbar("Error", "No video URLs found.");
        setState(() {
          isLoading = false;
          hasError = true;
        });
        return;
      }

      controller = PodPlayerController(
        playVideoFrom: PlayVideoFrom.networkQualityUrls(videoUrls: urls),
        podPlayerConfig: const PodPlayerConfig(videoQualityPriority: [240]),
      )..initialise();

      setState(() => isLoading = false);
    } catch (e) {
      setState(() {
        isLoading = false;
        hasError = true;
      });
      debugPrint("===== VIMEO API ERROR: $e ==========");
      Get.snackbar("Error", "Failed to load video: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (hasError || controller == null) {
      return const Center(child: Text('Failed to load video.'));
    }

    return Center(child: PodVideoPlayer(controller: controller!));
  }
}
