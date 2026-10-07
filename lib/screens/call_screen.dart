import 'dart:async';
import 'package:flutter/cupertino.dart';
import '../data/contact.dart';
import '../data/game_state.dart';

class CallScreen extends StatefulWidget {
  const CallScreen({super.key, required this.contact});

  final Contact contact;

  @override
  State<CallScreen> createState() => _CallScreenState();
}

class _CallScreenState extends State<CallScreen>
    with SingleTickerProviderStateMixin {
  late Timer _timer;
  int _secondsElapsed = 0;
  int _earnedCP = 0;

  bool _isMuted = false;
  bool _isSpeaker = true;

  late AnimationController _waveController;

  @override
  void initState() {
    super.initState();
    _waveController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    )..repeat();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          _secondsElapsed++;
          _earnedCP += 5;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _waveController.dispose();
    super.dispose();
  }

  String _formatDuration(int seconds) {
    final m = (seconds ~/ 60).toString().padLeft(2, '0');
    final s = (seconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  void _endCall() {
    _timer.cancel();
    GameState.instance.addCallPoints(
      _earnedCP,
      'Call with ${widget.contact.fullName} (${_secondsElapsed}s)',
    );

    showCupertinoModalPopup<void>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => CupertinoActionSheet(
        title: Text('Call Finished • ${widget.contact.fullName}'),
        message: Column(
          children: [
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xFF10B981).withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    CupertinoIcons.phone_fill,
                    color: Color(0xFF10B981),
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '+$_earnedCP Call Points Earned!',
                    style: const TextStyle(
                      color: Color(0xFF10B981),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Call Duration: ${_formatDuration(_secondsElapsed)}\nUse Call Points to upgrade your estate house!',
            ),
          ],
        ),
        actions: [
          CupertinoActionSheetAction(
            onPressed: () {
              GameState.instance.convertCallPointsToEclipse(_earnedCP);
              Navigator.of(ctx).pop();
              Navigator.of(context).pop();
            },
            child: Text(
              'Convert to +${_earnedCP * 3} Eclipse Points (Solar Forge)',
            ),
          ),
          CupertinoActionSheetAction(
            isDefaultAction: true,
            onPressed: () {
              Navigator.of(ctx).pop();
              Navigator.of(context).pop();
            },
            child: const Text('Keep as Call Points'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: const Color(0xFF0F172A),
      navigationBar: CupertinoNavigationBar(
        backgroundColor: CupertinoColors.transparent,
        border: null,
        leading: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: _endCall,
          child: const Icon(
            CupertinoIcons.chevron_back,
            color: CupertinoColors.white,
          ),
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),
            Text(
              widget.contact.fullName,
              style: const TextStyle(
                color: CupertinoColors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              _formatDuration(_secondsElapsed),
              style: TextStyle(
                color: CupertinoColors.white.withValues(alpha: 0.7),
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFF10B981).withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: const Color(0xFF10B981).withValues(alpha: 0.5),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    CupertinoIcons.bolt_fill,
                    color: Color(0xFF10B981),
                    size: 14,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    '+$_earnedCP Call Points (+5/sec)',
                    style: const TextStyle(
                      color: Color(0xFF10B981),
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            AnimatedBuilder(
              animation: _waveController,
              builder: (context, child) {
                return Stack(
                  alignment: Alignment.center,
                  children: [
                    CustomPaint(
                      size: const Size(220, 220),
                      painter: _AudioWaveformPainter(
                        progress: _waveController.value,
                        color: widget.contact.avatarColor,
                      ),
                    ),
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: widget.contact.avatarColor,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: widget.contact.avatarColor.withValues(
                              alpha: 0.4,
                            ),
                            blurRadius: 24,
                            spreadRadius: 4,
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          widget.contact.initials,
                          style: const TextStyle(
                            color: CupertinoColors.white,
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 20),
            Text(
              '${widget.contact.houseTier.title} • Lv ${widget.contact.houseLevel}',
              style: TextStyle(
                color: widget.contact.houseTier.accentColor,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _CallControlButton(
                    icon: _isMuted
                        ? CupertinoIcons.mic_off
                        : CupertinoIcons.mic_solid,
                    label: _isMuted ? 'Muted' : 'Mute',
                    isActive: _isMuted,
                    onTap: () => setState(() => _isMuted = !_isMuted),
                  ),
                  _CallControlButton(
                    icon: CupertinoIcons.volume_up,
                    label: 'Speaker',
                    isActive: _isSpeaker,
                    onTap: () => setState(() => _isSpeaker = !_isSpeaker),
                  ),
                  _CallControlButton(
                    icon: CupertinoIcons.chat_bubble_2_fill,
                    label: 'Message',
                    isActive: false,
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 36),
            CupertinoButton(
              onPressed: _endCall,
              padding: EdgeInsets.zero,
              child: Container(
                width: 68,
                height: 68,
                decoration: const BoxDecoration(
                  color: Color(0xFFEF4444),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Color(0x66EF4444),
                      blurRadius: 16,
                      offset: Offset(0, 6),
                    ),
                  ],
                ),
                child: const Icon(
                  CupertinoIcons.phone_down_fill,
                  color: CupertinoColors.white,
                  size: 32,
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

class _CallControlButton extends StatelessWidget {
  const _CallControlButton({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isActive
                  ? CupertinoColors.white
                  : CupertinoColors.white.withValues(alpha: 0.15),
            ),
            child: Icon(
              icon,
              color: isActive ? CupertinoColors.black : CupertinoColors.white,
              size: 24,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: TextStyle(
              color: CupertinoColors.white.withValues(alpha: 0.8),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

class _AudioWaveformPainter extends CustomPainter {
  _AudioWaveformPainter({required this.progress, required this.color});

  final double progress;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    for (int i = 1; i <= 3; i++) {
      final ringProgress = (progress + (i * 0.33)) % 1.0;
      final radius = 55 + (ringProgress * 50);
      final alpha = (1.0 - ringProgress).clamp(0.0, 1.0) * 0.45;
      final paint = Paint()
        ..color = color.withValues(alpha: alpha)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0;
      canvas.drawCircle(center, radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _AudioWaveformPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
