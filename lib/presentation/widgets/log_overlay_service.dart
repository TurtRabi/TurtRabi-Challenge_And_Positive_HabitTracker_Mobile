import 'package:flutter/material.dart';

enum LogType { loading, success, error, warning, info }

class LogOverlayService {
  static final List<OverlayEntry> _activeOverlays = [];

  static void show(
      BuildContext context, {
        required String message,
        LogType type = LogType.info,
        bool dismissible = true,
        Duration duration = const Duration(seconds: 3),
      }) {
    final icon = _getIcon(type);
    final bgColor = _getBgColor(type);
    late OverlayEntry entry;

    entry = OverlayEntry(
      builder: (context) {
        int index = _activeOverlays.indexOf(entry); // update vị trí realtime
        return _LogWithProgress(
          index: index < 0 ? 0 : index,
          icon: icon,
          bgColor: bgColor,
          message: message,
          dismissible: dismissible,
          duration: duration,
          onClose: () => _remove(entry),
        );
      },
    );

    _activeOverlays.add(entry);
    Overlay.of(context).insert(entry);

    // Auto remove
    if (type != LogType.loading) {
      Future.delayed(duration, () => _remove(entry));
    }
  }

  static void _remove(OverlayEntry entry) {
    if (_activeOverlays.contains(entry)) {
      entry.remove();
      _activeOverlays.remove(entry);
      _repositionAll(); // Cập nhật lại vị trí log
    }
  }

  static void _repositionAll() {
    for (final entry in _activeOverlays) {
      entry.markNeedsBuild();
    }
  }

  static void hideAll() {
    for (final entry in _activeOverlays) {
      entry.remove();
    }
    _activeOverlays.clear();
  }

  static Widget _getIcon(LogType type) {
    switch (type) {
      case LogType.success:
        return const Icon(Icons.check_circle, color: Colors.white, size: 20);
      case LogType.error:
        return const Icon(Icons.error, color: Colors.white, size: 20);
      case LogType.warning:
        return const Icon(Icons.warning, color: Colors.white, size: 20);
      case LogType.loading:
        return const SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
        );
      default:
        return const Icon(Icons.info, color: Colors.white, size: 20);
    }
  }

  static Color _getBgColor(LogType type) {
    switch (type) {
      case LogType.success:
        return Colors.green.shade600;
      case LogType.error:
        return Colors.red.shade600;
      case LogType.warning:
        return Colors.orange.shade700;
      case LogType.loading:
        return Colors.grey.shade800;
      default:
        return Colors.blue.shade600;
    }
  }
}

class _LogWithProgress extends StatefulWidget {
  final int index;
  final Widget icon;
  final Color bgColor;
  final String message;
  final bool dismissible;
  final Duration duration;
  final VoidCallback onClose;

  const _LogWithProgress({
    required this.index,
    required this.icon,
    required this.bgColor,
    required this.message,
    required this.dismissible,
    required this.duration,
    required this.onClose,
  });

  @override
  State<_LogWithProgress> createState() => _LogWithProgressState();
}

class _LogWithProgressState extends State<_LogWithProgress>
    with SingleTickerProviderStateMixin {
  late AnimationController _progressController;

  @override
  void initState() {
    super.initState();
    _progressController = AnimationController(
      vsync: this,
      duration: widget.duration,
    )..forward();
  }

  @override
  void dispose() {
    _progressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 20.0 + (widget.index * 72),
      right: 20,
      child: Material(
        color: Colors.transparent,
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 350),
          opacity: 1,
          child: Container(
            constraints: const BoxConstraints(maxWidth: 320),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: widget.bgColor,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.16),
                  blurRadius: 8,
                )
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    widget.icon,
                    const SizedBox(width: 10),
                    Flexible(
                      child: Text(
                        widget.message,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    if (widget.dismissible)
                      IconButton(
                        icon: const Icon(Icons.close, size: 18, color: Colors.white),
                        onPressed: widget.onClose,
                      ),
                  ],
                ),
                if (widget.duration.inMilliseconds > 0 && widget.bgColor != Colors.grey.shade800)
                  Padding(
                    padding: const EdgeInsets.only(top: 6.0),
                    child: AnimatedBuilder(
                      animation: _progressController,
                      builder: (context, child) {
                        return LinearProgressIndicator(
                          value: 1 - _progressController.value,
                          backgroundColor: Colors.white24,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          minHeight: 4,
                        );
                      },
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
