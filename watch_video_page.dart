import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';

class WatchVideoPage extends StatefulWidget {
  @override
  _WatchVideoPageState createState() => _WatchVideoPageState();
}

class _WatchVideoPageState extends State<WatchVideoPage>
    with SingleTickerProviderStateMixin {
  late VideoPlayerController _controller;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  bool _initialized = false;
  bool _isFullscreen = false;
  Timer? _hideTimer;

  late String url;
  late String title;
  bool _didInit = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_didInit) return;
    _didInit = true;

    final args = ModalRoute.of(context)!.settings.arguments as Map;
    url = args['url'] as String;

    final titleMap = args['title'] as Map<String, dynamic>;
    final localeCode = Localizations.localeOf(context).languageCode;
    title =
        titleMap.containsKey(localeCode)
            ? titleMap[localeCode]
            : titleMap.values.first;

    _controller = VideoPlayerController.networkUrl(Uri.parse(url))
      ..initialize().then((_) {
        setState(() => _initialized = true);
        _controller.play();
        _startAutoHideTimer();
      });

    _controller.addListener(() {
      setState(() {});
    });

    _fadeController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );

    _fadeAnimation = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(_fadeController);
  }

  @override
  void dispose() {
    _controller.dispose();
    _fadeController.dispose();
    _hideTimer?.cancel();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  void _startAutoHideTimer() {
    _fadeController.reverse();

    _hideTimer?.cancel();
    _hideTimer = Timer(Duration(seconds: 3), () {
      _fadeController.forward();
    });
  }

  void _toggleFullscreen() {
    setState(() {
      _isFullscreen = !_isFullscreen;
    });

    if (_isFullscreen) {
      SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft]);
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    } else {
      SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    }

    _startAutoHideTimer();
  }

  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    final hours = duration.inHours;
    return hours > 0 ? '$hours:$minutes:$seconds' : '$minutes:$seconds';
  }

  Widget _buildControls() {
    final position = _controller.value.position;
    final duration = _controller.value.duration;

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        FadeTransition(
          opacity: _fadeAnimation,
          child: VideoProgressIndicator(
            _controller,
            allowScrubbing: true,
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            colors: VideoProgressColors(
              playedColor: Colors.white,
              bufferedColor: Colors.white54,
              backgroundColor: Colors.white24,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  formatDuration(position),
                  style: TextStyle(color: Colors.white, fontSize: 14),
                ),
                Text(
                  formatDuration(duration),
                  style: TextStyle(color: Colors.white, fontSize: 14),
                ),
              ],
            ),
          ),
        ),
        FadeTransition(
          opacity: _fadeAnimation,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: Icon(Icons.replay_10, color: Colors.white),
                onPressed: () {
                  final pos = _controller.value.position;
                  final newPos = Duration(seconds: max(0, pos.inSeconds - 10));
                  _controller.seekTo(newPos);
                  _startAutoHideTimer();
                },
              ),
              IconButton(
                icon: Icon(
                  _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
                  color: Colors.white,
                  size: 36,
                ),
                onPressed: () {
                  setState(() {
                    _controller.value.isPlaying
                        ? _controller.pause()
                        : _controller.play();
                  });
                  _startAutoHideTimer();
                },
              ),
              IconButton(
                icon: Icon(Icons.forward_10, color: Colors.white),
                onPressed: () {
                  final pos = _controller.value.position;
                  final dur = _controller.value.duration;
                  final newPos = Duration(
                    seconds: min(dur.inSeconds, pos.inSeconds + 10),
                  );
                  _controller.seekTo(newPos);
                  _startAutoHideTimer();
                },
              ),
              IconButton(
                icon: Icon(
                  _isFullscreen ? Icons.fullscreen_exit : Icons.fullscreen,
                  color: Colors.white,
                ),
                onPressed: _toggleFullscreen,
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final videoPlayerWidget = GestureDetector(
      onTap: _startAutoHideTimer,
      child: AspectRatio(
        aspectRatio:
            _controller.value.isInitialized
                ? _controller.value.aspectRatio
                : 16 / 9,
        child: VideoPlayer(_controller),
      ),
    );

    if (!_initialized) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_controller.value.hasError) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Text(
            'Failed to load video',
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Center(child: videoPlayerWidget),

          // Back button
          Positioned(
            top: _isFullscreen ? 8 : 40,
            left: 8,
            child: SafeArea(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: IconButton(
                  icon: Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () {
                    if (_isFullscreen) _toggleFullscreen();
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ),
          ),

          // Centered title (non-blocking and properly sized)
          Positioned(
            top: _isFullscreen ? 8 : 40,
            left: _isFullscreen ? 60 : 0,
            right: _isFullscreen ? 60 : 0,
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: IgnorePointer(
                ignoring: true, // allow touches to pass through
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      title,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Controls
          Positioned(left: 0, right: 0, bottom: 0, child: _buildControls()),
        ],
      ),
    );
  }
}
