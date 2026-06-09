import 'dart:async';
import 'package:flutter/material.dart';

final class RestTimerDialog extends StatefulWidget {
  final int seconds;
  const RestTimerDialog({super.key, this.seconds = 90});

  @override
  State<RestTimerDialog> createState() => _RestTimerDialogState();
}

final class _RestTimerDialogState extends State<RestTimerDialog> with SingleTickerProviderStateMixin {
  late int _remaining;
  late Timer _timer;
  late AnimationController _controller;
  bool _paused = false;

  @override
  void initState() {
    super.initState();
    _remaining = widget.seconds;
    _controller = AnimationController(vsync: this, duration: Duration(seconds: widget.seconds));
    _controller.forward();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!_paused && _remaining > 0) {
        setState(() => _remaining--);
        if (_remaining == 0) _complete();
      }
    });
  }

  void _complete() {
    _timer.cancel();
    _controller.stop();
    Navigator.of(context).pop();
  }

  void _togglePause() {
    setState(() {
      _paused = !_paused;
      if (_paused) {
        _controller.stop();
      } else {
        _controller.forward();
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final progress = _paused ? _controller.value : (_remaining / widget.seconds);
    final minutes = (_remaining ~/ 60).toString().padLeft(2, '0');
    final seconds = (_remaining % 60).toString().padLeft(2, '0');

    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Rest', style: theme.textTheme.titleMedium),
          const SizedBox(height: 16),
          SizedBox(
            width: 120,
            height: 120,
            child: Stack(
              alignment: Alignment.center,
              children: [
                CircularProgressIndicator(
                  value: progress,
                  strokeWidth: 8,
                  valueColor: theme.colorScheme.primary,
                  trackColor: theme.colorScheme.surfaceContainerHighest,
                ),
                Text('$minutes:$seconds', style: theme.textTheme.displaySmall?.copyWith(fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                onPressed: _togglePause,
                child: Text(_paused ? 'Resume' : 'Pause'),
              ),
              const SizedBox(width: 12),
              TextButton(
                onPressed: _complete,
                child: const Text('Skip'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
