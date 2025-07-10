import 'package:flutter/material.dart';
import 'package:vimeo_video_player/vimeo_video_player.dart';

class VimeoVideoViewer extends StatefulWidget {
  final String url;

  const VimeoVideoViewer({super.key, required this.url});

  @override
  State<VimeoVideoViewer> createState() => _VimeoVideoViewerState();
}

class _VimeoVideoViewerState extends State<VimeoVideoViewer> {
  /// Used to notify that video is loaded or not
  bool isVideoLoading = true;

  /// Controller of the WebView
  //InAppWebViewController? webViewController;
  String convertVimeoUrlToID(String url) {
    return url.substring('https://vimeo.com/'.length);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            VimeoVideoPlayer(
              videoId: convertVimeoUrlToID(widget.url),
              isAutoPlay: true,
              onInAppWebViewCreated: (controller) {
                //    webViewController = controller;
              },
              onInAppWebViewLoadStart: (controller, url) {
                setState(() {
                  isVideoLoading = true;
                });
              },
              onInAppWebViewLoadStop: (controller, url) {
                setState(() {
                  isVideoLoading = false;
                });
              },
            ),
            if (isVideoLoading)
              const Center(child: CircularProgressIndicator()),
          ],
        ),
      ),
    );
  }
}
