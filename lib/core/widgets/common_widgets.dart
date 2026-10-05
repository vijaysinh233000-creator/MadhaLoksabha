import 'dart:async';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../theme/app_theme.dart';

/// Rounded white card used throughout both dashboards.
class AppCard extends StatelessWidget {
  const AppCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(18),
    this.color,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color ?? Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14081F33),
            blurRadius: 22,
            offset: Offset(0, 8),
          ),
        ],
      ),
      padding: padding,
      child: child,
    );
  }
}

/// Section heading with an icon, e.g. "🔍 नाव शोधा".
class SectionTitle extends StatelessWidget {
  const SectionTitle({
    super.key,
    required this.icon,
    required this.title,
    this.iconColor,
    this.trailing,
    this.center = false,
  });

  final IconData icon;
  final String title;
  final Color? iconColor;
  final Widget? trailing;
  final bool center;

  @override
  Widget build(BuildContext context) {
    final text = Text(
      title,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      textAlign: center ? TextAlign.center : TextAlign.start,
      style: const TextStyle(
        fontSize: 17,
        fontWeight: FontWeight.w800,
        color: AppColors.navyText,
      ),
    );
    if (center && trailing == null) {
      // Centered variant: let the text shrink instead of overflowing the row.
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 20, color: iconColor ?? AppColors.saffron),
          const SizedBox(width: 8),
          Flexible(child: text),
        ],
      );
    }
    return Row(
      children: [
        Icon(icon, size: 20, color: iconColor ?? AppColors.saffron),
        const SizedBox(width: 8),
        Expanded(child: text),
        if (trailing != null) ...[const SizedBox(width: 8), trailing!],
      ],
    );
  }
}

class Pill extends StatelessWidget {
  const Pill({
    super.key,
    required this.label,
    this.color = AppColors.surface,
    this.textColor = AppColors.textSecondary,
    this.icon,
    this.maxWidth = 260,
  });

  final String label;
  final Color color;
  final Color textColor;
  final IconData? icon;
  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: label,
      waitDuration: const Duration(milliseconds: 500),
      child: Container(
        constraints: BoxConstraints(maxWidth: maxWidth),
        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 13, color: textColor),
              const SizedBox(width: 4),
            ],
            Flexible(
              child: Text(
                label,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: textColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({super.key, this.message});
  final String? message;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(
            width: 36,
            height: 36,
            child: CircularProgressIndicator(
              strokeWidth: 3,
              color: AppColors.saffron,
            ),
          ),
          if (message != null) ...[
            const SizedBox(height: 14),
            Text(
              message!,
              style: const TextStyle(color: AppColors.textSecondary),
            ),
          ],
        ],
      ),
    );
  }
}

class AppVideoLoadingScreen extends StatefulWidget {
  const AppVideoLoadingScreen({
    super.key,
    this.backgroundColor = const Color(0xFF07131F),
    this.onComplete,
  });

  final Color backgroundColor;
  final VoidCallback? onComplete;

  @override
  State<AppVideoLoadingScreen> createState() => _AppVideoLoadingScreenState();
}

class _AppVideoLoadingScreenState extends State<AppVideoLoadingScreen> {
  late final VideoPlayerController _controller;
  bool _hasCompleted = false;
  bool _videoReady = false;
  bool _videoVisible = false;
  bool _needsPlaybackTap = false;
  Timer? _startupTimer;
  Timer? _playbackTimer;
  Timer? _fadeTimer;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset(
      'assets/videos/loading_intro.mp4',
    );
    _controller.addListener(_handleVideoProgress);
    _startupTimer = Timer(const Duration(seconds: 8), _completeSplash);
    unawaited(_initializeAndPlay());
  }

  Future<void> _initializeAndPlay() async {
    try {
      await _controller.initialize().timeout(const Duration(seconds: 8));
      if (!mounted || _hasCompleted) return;
      _startupTimer?.cancel();
      await _controller.setLooping(false);
      // Keep the supplied intro audio. Browsers that block sound autoplay will
      // fall back to the explicit tap-to-play control below.
      await _controller.setVolume(1);
      setState(() {
        _videoReady = true;
        _videoVisible = true;
      });
      await _startPlayback();
    } catch (error, stackTrace) {
      debugPrint('Splash video failed to initialize: $error');
      debugPrintStack(stackTrace: stackTrace);
      if (!mounted || _hasCompleted) return;
      _startupTimer?.cancel();
      _playbackTimer?.cancel();
      _playbackTimer = Timer(
        const Duration(milliseconds: 1400),
        _completeSplash,
      );
    }
  }

  Future<void> _startPlayback() async {
    try {
      await _controller.play();
      if (!mounted || _hasCompleted) return;
      if (_controller.value.isPlaying) {
        _playbackTimer?.cancel();
        final duration = _controller.value.duration;
        _playbackTimer = Timer(
          (duration > Duration.zero ? duration : const Duration(seconds: 20)) +
              const Duration(seconds: 2),
          _completeSplash,
        );
      } else {
        setState(() => _needsPlaybackTap = true);
      }
    } catch (error, stackTrace) {
      debugPrint('Splash video autoplay requires user interaction: $error');
      debugPrintStack(stackTrace: stackTrace);
      if (!mounted || _hasCompleted) return;
      setState(() => _needsPlaybackTap = true);
    }
  }

  void _handleVideoProgress() {
    if (!mounted || !_controller.value.isInitialized || _hasCompleted) {
      return;
    }

    if (_controller.value.hasError) {
      debugPrint(
        'Splash video playback failed: ${_controller.value.errorDescription}',
      );
      _playbackTimer?.cancel();
      setState(() => _needsPlaybackTap = true);
      return;
    }

    if (_controller.value.isPlaying && _playbackTimer == null) {
      final duration = _controller.value.duration;
      _playbackTimer = Timer(
        (duration > Duration.zero ? duration : const Duration(seconds: 20)) +
            const Duration(seconds: 2),
        _completeSplash,
      );
      if (_needsPlaybackTap) {
        setState(() => _needsPlaybackTap = false);
      }
    }

    final duration = _controller.value.duration;
    if (duration <= Duration.zero) return;

    final position = _controller.value.position;
    if (position >= duration - const Duration(milliseconds: 160)) {
      _completeSplash();
    }
  }

  void _completeSplash() {
    if (!mounted || _hasCompleted) return;
    _hasCompleted = true;
    _startupTimer?.cancel();
    _playbackTimer?.cancel();
    setState(() => _videoVisible = false);
    _fadeTimer = Timer(const Duration(milliseconds: 280), () {
      if (mounted) widget.onComplete?.call();
    });
  }

  @override
  void dispose() {
    _startupTimer?.cancel();
    _playbackTimer?.cancel();
    _fadeTimer?.cancel();
    _controller.removeListener(_handleVideoProgress);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final videoReady = _videoReady && _controller.value.isInitialized;

    return SizedBox.expand(
      child: DecoratedBox(
        decoration: BoxDecoration(color: widget.backgroundColor),
        child: Center(
          child: videoReady
              ? GestureDetector(
                  onTap: _needsPlaybackTap ? _startPlayback : null,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      AnimatedOpacity(
                        opacity: _videoVisible ? 1 : 0,
                        duration: const Duration(milliseconds: 320),
                        curve: Curves.easeInOutCubic,
                        child: FittedBox(
                          fit: BoxFit.contain,
                          alignment: Alignment.center,
                          child: SizedBox(
                            width: _controller.value.size.width > 0
                                ? _controller.value.size.width.toDouble()
                                : 1,
                            height: _controller.value.size.height > 0
                                ? _controller.value.size.height.toDouble()
                                : 1,
                            child: VideoPlayer(_controller),
                          ),
                        ),
                      ),
                      if (_needsPlaybackTap)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 14,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xCC07131F),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.play_arrow_rounded,
                                color: Colors.white,
                                size: 28,
                              ),
                              SizedBox(width: 8),
                              Text(
                                'आवाजासह व्हिडिओ सुरू करा',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                )
              : const SizedBox(
                  width: 36,
                  height: 36,
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                    color: Colors.white,
                  ),
                ),
        ),
      ),
    );
  }
}

class EmptyState extends StatelessWidget {
  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.action,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: AppColors.saffronLight,
              borderRadius: BorderRadius.circular(36),
            ),
            child: Icon(icon, size: 34, color: AppColors.saffron),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w800,
              color: AppColors.navyText,
            ),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 6),
            Text(
              subtitle!,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.textSecondary,
                height: 1.4,
              ),
            ),
          ],
          if (action != null) ...[const SizedBox(height: 16), action!],
        ],
      ),
    );
  }
}

class ErrorState extends StatelessWidget {
  const ErrorState({super.key, required this.message, this.onRetry});
  final String message;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return EmptyState(
      icon: Icons.error_outline_rounded,
      title: 'काहीतरी चूक झाली',
      subtitle: message,
      action: onRetry == null
          ? null
          : OutlinedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('पुन्हा प्रयत्न करा'),
            ),
    );
  }
}

/// Simple numbered pagination bar.
class PaginationBar extends StatelessWidget {
  const PaginationBar({
    super.key,
    required this.page,
    required this.totalPages,
    required this.onChanged,
  });

  final int page;
  final int totalPages;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    if (totalPages <= 1) return const SizedBox.shrink();
    final pages = <int>{
      1,
      totalPages,
      page,
      page - 1,
      page + 1,
      page - 2,
      page + 2,
    }.where((p) => p >= 1 && p <= totalPages).toList()..sort();
    final children = <Widget>[];
    children.add(
      _navBtn(
        Icons.chevron_left_rounded,
        page > 1 ? () => onChanged(page - 1) : null,
      ),
    );
    int? last;
    for (final p in pages) {
      if (last != null && p - last > 1) {
        children.add(
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 4),
            child: Text('…', style: TextStyle(color: AppColors.textMuted)),
          ),
        );
      }
      children.add(_pageBtn(p));
      last = p;
    }
    children.add(
      _navBtn(
        Icons.chevron_right_rounded,
        page < totalPages ? () => onChanged(page + 1) : null,
      ),
    );
    return Wrap(
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 4,
      runSpacing: 4,
      children: children,
    );
  }

  Widget _navBtn(IconData icon, VoidCallback? onTap) =>
      IconButton(onPressed: onTap, icon: Icon(icon), color: AppColors.navyText);

  Widget _pageBtn(int p) {
    final active = p == page;
    return InkWell(
      onTap: active ? null : () => onChanged(p),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: 36,
        height: 36,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: active ? AppColors.saffron : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: active ? AppColors.saffron : AppColors.border,
          ),
        ),
        child: Text(
          '$p',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            color: active ? Colors.white : AppColors.navyText,
          ),
        ),
      ),
    );
  }
}

/// Max-width centered column used for page content.
class PageContainer extends StatelessWidget {
  const PageContainer({
    super.key,
    required this.child,
    this.maxWidth = 1100,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
  });
  final Widget child;
  final double maxWidth;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: Padding(padding: padding, child: child),
      ),
    );
  }
}

void showSnack(BuildContext context, String message, {bool error = false}) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: error ? AppColors.danger : AppColors.navy,
      ),
    );
}
