
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:gallery_saver_plus/gallery_saver.dart';
import 'package:video_player/video_player.dart';

import '../../common/common_imports/common_imports.dart';
import '../../common/widgets/appbar.dart';

class VideoApp extends StatefulWidget {
  final String videoUrl;
  const VideoApp({super.key, required this.videoUrl});

  @override
  _VideoAppState createState() => _VideoAppState();
}

class _VideoAppState extends State<VideoApp>
    with SingleTickerProviderStateMixin {
  late VideoPlayerController _controller;
  late AnimationController _animationController;
  bool iconDisappered = false;
  @override
  void initState() {
    super.initState();
    EasyLoading.show();
    _controller = VideoPlayerController.networkUrl(
      Uri.parse(widget.videoUrl),
    )..initialize().then((_) {
      EasyLoading.dismiss();
      setState(() {});
    });
    _controller.addListener(() {
      if (_controller.value.isCompleted) {
        setState(() {
          iconDisappered = false;
        });
        _controller.pause();
        _animationController.reverse();
      }
    });
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: CustomAppBar(
        color: TAppColors.venueCardTextColor,
        textColor: TAppColors.white,
        title: 'Video',
        prefixWidget: InkWell(
          onTap: () {
            EasyLoading.showSuccess(
                'Your download will start shortly. Thank you for your patience!');
            GallerySaver.saveVideo(widget.videoUrl).then(
                  (value) {
                value ?? false
                    ? EasyLoading.showSuccess('Video Downloaded Successfully')
                    : null;
              },
            );
          },
          child: const Icon(
            Icons.download,
            color: TAppColors.text4Color,
          ),
        ),
        hasSubTitle: false,
      ),
      body: Center(
        child: _controller.value.isInitialized
            ? GestureDetector(
          onTap: () {
            setState(() {
              if (_controller.value.isPlaying) {
                setState(() {
                  iconDisappered = false;
                });
                _controller.pause();
                _animationController.reverse();
              } else {
                _controller.play();
                Future.delayed(const Duration(milliseconds: 500), () {
                  setState(() {
                    iconDisappered = true;
                  });
                });
                _animationController.forward();
              }
            });
          },
          child: SizedBox(
            child: Stack(
              children: [
                Center(
                  child: AspectRatio(
                    aspectRatio: _controller.value.aspectRatio,
                    child: Center(child: VideoPlayer(_controller)),
                  ),
                ),
                Center(
                  child: iconDisappered
                      ? const SizedBox()
                      : AnimatedIcon(
                    size: 60,
                    color: Colors.white,
                    icon: AnimatedIcons.play_pause,
                    progress: _animationController,
                  ),
                )
              ],
            ),
          ),
        )
            : Container(),
      ),
    );
  }
}
