import 'package:flutter/material.dart';

typedef FuncOnPlayPauseTapped = void Function(bool isPlaying);

class PlayPauseButton extends StatefulWidget {
  PlayPauseButton({this.onPlayPauseTapped, Key? key}) : super(key: key);

  FuncOnPlayPauseTapped? onPlayPauseTapped;

  @override
  _PlayPauseButtonState createState() => _PlayPauseButtonState();
}

class _PlayPauseButtonState extends State<PlayPauseButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _isPlaying = true;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 200,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 3.0),
        ),
        child: AnimatedIcon(
          icon: AnimatedIcons.pause_play,
          progress: _controller,
          size: 128,
          color: Colors.white,
        ),
      ),
      onTap: () {
        if (_isPlaying) {
          _controller.forward();
        } else {
          _controller.reverse();
        }

        if (widget.onPlayPauseTapped != null) {
          widget.onPlayPauseTapped!(_isPlaying);
        }
        _isPlaying = !_isPlaying;
      },
    );
  }
}
