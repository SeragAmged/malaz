import 'package:flutter/material.dart';

class RollingDigit extends StatefulWidget {
  const RollingDigit({super.key, required this.digit, required this.style});

  final String digit;
  final TextStyle style;

  @override
  State<RollingDigit> createState() => _RollingDigitState();
}

class _RollingDigitState extends State<RollingDigit>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<Offset> _slideOut;
  late Animation<Offset> _slideIn;
  late Animation<double> _fadeOut;
  late Animation<double> _fadeIn;

  String _from = '';
  bool _animating = false;
  int _direction = 1;

  @override
  void initState() {
    super.initState();
    _from = widget.digit;
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _buildAnimations(_direction);
    _ctrl.addStatusListener((s) {
      if (s == AnimationStatus.completed) {
        setState(() {
          _from = widget.digit; // always settle to whatever is current
          _animating = false;
        });
        _ctrl.reset();
      }
    });
  }

  void _buildAnimations(int dir) {
    _slideOut = Tween<Offset>(
      begin: Offset.zero,
      end: Offset(0, -0.85 * dir),
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeIn));

    _slideIn = Tween<Offset>(
      begin: Offset(0, 0.85 * dir),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOut));

    _fadeOut = Tween<double>(
      begin: 1,
      end: 0,
    ).animate(CurvedAnimation(parent: _ctrl, curve: const Interval(0, 0.35)));

    _fadeIn = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _ctrl, curve: const Interval(0.35, 1)));
  }

  @override
  void didUpdateWidget(RollingDigit oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.digit != widget.digit) {
      final oldVal = int.tryParse(oldWidget.digit) ?? 0;
      final newVal = int.tryParse(widget.digit) ?? 0;
      _direction = newVal > oldVal ? 1 : -1;
      _buildAnimations(_direction);
      setState(() => _animating = true);
      _ctrl.forward();
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: _charWidth(),
      child: AnimatedBuilder(
        animation: _ctrl,
        builder: (_, _) {
          if (!_animating) {
            return Text(widget.digit, style: widget.style);
          }
          return Stack(
            clipBehavior: Clip.none,
            children: [
              SlideTransition(
                position: _slideOut,
                child: FadeTransition(
                  opacity: _fadeOut,
                  child: Text(_from, style: widget.style),
                ),
              ),
              SlideTransition(
                position: _slideIn,
                child: FadeTransition(
                  opacity: _fadeIn,
                  child: Text(widget.digit, style: widget.style),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // Approximate monospaced width for a digit at this font size.
  double _charWidth() {
    final tp = TextPainter(
      text: TextSpan(text: '0', style: widget.style),
      textDirection: TextDirection.ltr,
    )..layout();
    return tp.width;
  }
}
