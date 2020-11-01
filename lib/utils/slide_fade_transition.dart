import 'package:flutter/material.dart';

class SlideFadeTransition extends StatefulWidget {

  final Duration duration;
  final Widget child;
  final EdgeInsets padding;

  SlideFadeTransition({@required this.duration, @required this.child, this.padding});

  @override
  _SlideFadeTransitionState createState() => _SlideFadeTransitionState();
}

class _SlideFadeTransitionState extends State<SlideFadeTransition> with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> _animFade;
  Animation<Offset> _animSlide;

  @override
  void initState() {
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _animFade = _controller.drive(Tween<double>(
      begin: 0.4,
      end: 1.0
    ));
    _animSlide = _controller.drive(Tween<Offset>(
        begin: Offset(0, 0.5),
        end: Offset.zero
    ));

    _controller.forward();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.padding ?? EdgeInsets.zero,
      child: SlideTransition(
          position: _animSlide,
        child: FadeTransition(
          opacity: _animFade,
          child: widget.child,
        ),
      ),
    );
  }
}
