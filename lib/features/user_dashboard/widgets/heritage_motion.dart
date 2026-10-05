import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';

/// Gives the heritage landscape restrained depth without moving foreground UI.
class HeritageParallaxBackground extends StatefulWidget {
  const HeritageParallaxBackground({super.key, required this.asset});
  final String asset;

  @override
  State<HeritageParallaxBackground> createState() =>
      _HeritageParallaxBackgroundState();
}

class _HeritageParallaxBackgroundState
    extends State<HeritageParallaxBackground> {
  ScrollPosition? _position;
  double _offset = 0;
  bool _queued = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final next = Scrollable.maybeOf(context)?.position;
    if (next != _position) {
      _position?.removeListener(_schedule);
      _position = next;
      _position?.addListener(_schedule);
    }
    _schedule();
  }

  void _schedule() {
    if (_queued || !mounted) return;
    _queued = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _queued = false;
      if (!mounted || MediaQuery.disableAnimationsOf(context)) return;
      final box = context.findRenderObject();
      if (box is! RenderBox || !box.hasSize) return;
      final viewport = MediaQuery.sizeOf(context).height;
      final center = box.localToGlobal(Offset.zero).dy + box.size.height / 2;
      final next = ((center - viewport / 2) / viewport * 16).clamp(-16.0, 16.0);
      if ((next - _offset).abs() > .2) setState(() => _offset = next);
    });
  }

  @override
  void dispose() {
    _position?.removeListener(_schedule);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _schedule();
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Transform.translate(
        offset: Offset(0, _offset),
        child: Transform.scale(
          scale: 1.04,
          child: Image.asset(widget.asset, fit: BoxFit.fill),
        ),
      ),
    );
  }
}

/// Reveals content on viewport entry; motion preferences also disable tilt.
class HeritageMotion extends StatefulWidget {
  const HeritageMotion({
    super.key,
    required this.child,
    this.enableTilt = true,
  });
  final Widget child;
  final bool enableTilt;
  @override
  State<HeritageMotion> createState() => _HeritageMotionState();
}

class _HeritageMotionState extends State<HeritageMotion>
    with SingleTickerProviderStateMixin {
  late final AnimationController _reveal = AnimationController(
    vsync: this,
    duration: AppMotion.reveal,
  );
  ScrollPosition? _position;
  bool _queued = false;
  bool _reduce = false;
  Offset _tilt = Offset.zero;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _reduce = MediaQuery.disableAnimationsOf(context);
    final next = Scrollable.maybeOf(context)?.position;
    if (next != _position) {
      _position?.removeListener(_schedule);
      _position = next;
      _position?.addListener(_schedule);
    }
    if (_reduce) _reveal.value = 1;
    _schedule();
  }

  void _schedule() {
    if (_queued || _reveal.value == 1) return;
    _queued = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _queued = false;
      if (!mounted) return;
      final box = context.findRenderObject();
      if (box is! RenderBox || !box.hasSize) return;
      final top = box.localToGlobal(Offset.zero).dy;
      if (top < MediaQuery.sizeOf(context).height - 35 &&
          top + box.size.height > 0 &&
          !_reveal.isAnimating) {
        _reveal.forward();
      }
    });
  }

  @override
  void dispose() {
    _position?.removeListener(_schedule);
    _reveal.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _schedule();
    return MouseRegion(
      onHover: _reduce || !widget.enableTilt
          ? null
          : (event) {
              final box = context.findRenderObject() as RenderBox;
              final point = box.globalToLocal(event.position);
              setState(
                () => _tilt = Offset(
                  (point.dx / box.size.width - .5).clamp(-.5, .5),
                  (point.dy / box.size.height - .5).clamp(-.5, .5),
                ),
              );
            },
      onExit: (_) => setState(() => _tilt = Offset.zero),
      child: AnimatedContainer(
        duration: AppMotion.standard,
        curve: AppMotion.curve,
        transformAlignment: Alignment.center,
        transform: Matrix4.identity()
          ..setEntry(3, 2, .001)
          ..translateByDouble(0, _tilt == Offset.zero ? 0 : -2, 0, 1)
          ..rotateX(-_tilt.dy * .025)
          ..rotateY(_tilt.dx * .025),
        child: AnimatedBuilder(
          animation: _reveal,
          child: widget.child,
          builder: (context, child) {
            final progress = Curves.easeOutCubic.transform(_reveal.value);
            return Opacity(
              opacity: progress,
              child: Transform(
                alignment: Alignment.center,
                transform: Matrix4.identity()
                  ..setEntry(3, 2, .001)
                  ..translateByDouble(0, 14 * (1 - progress), 0, 1),
                child: child,
              ),
            );
          },
        ),
      ),
    );
  }
}
