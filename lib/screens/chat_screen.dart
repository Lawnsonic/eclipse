import 'package:flutter/cupertino.dart';
import '../data/contact.dart';
import '../data/game_state.dart';

class ChatMessage {
  ChatMessage({
    required this.text,
    required this.isMe,
    required this.timestamp,
  });

  final String text;
  final bool isMe;
  final DateTime timestamp;
}

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key, required this.contact});

  final Contact contact;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<ChatMessage> _messages = [];

  @override
  void initState() {
    super.initState();
    _messages.addAll([
      ChatMessage(
        text: 'Hey! Welcome to ${widget.contact.locationName}. How is your estate doing?',
        isMe: false,
        timestamp: DateTime.now().subtract(const Duration(minutes: 15)),
      ),
      ChatMessage(
        text: widget.contact.statusQuote,
        isMe: false,
        timestamp: DateTime.now().subtract(const Duration(minutes: 10)),
      ),
    ]);
  }

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage([String? presetText]) {
    final text = (presetText ?? _textController.text).trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add(
        ChatMessage(text: text, isMe: true, timestamp: DateTime.now()),
      );
      if (presetText == null) {
        _textController.clear();
      }
    });

    GameState.instance.addEclipsePoints(
      10,
      'Chat with ${widget.contact.firstName} (+10 EP)',
    );

    _scrollToBottom();

    Future.delayed(const Duration(milliseconds: 900), () {
      if (!mounted) return;
      String reply;
      if (text.toLowerCase().contains('solar') || text.toLowerCase().contains('flare')) {
        reply = 'Thank you for the Solar Flare! My ${widget.contact.houseTier.title} is glowing with extra energy today! ✨';
      } else if (text.toLowerCase().contains('upgrade') || text.toLowerCase().contains('house') || text.toLowerCase().contains('estate')) {
        reply = 'Upgrading to Level ${widget.contact.houseLevel} took some dedication! Keep tapping the Solar Forge and calling friends to harvest CP!';
      } else {
        reply = 'Great to hear from you! Stop by my estate in ${widget.contact.locationName} anytime.';
      }

      setState(() {
        _messages.add(
          ChatMessage(text: reply, isMe: false, timestamp: DateTime.now()),
        );
      });
      _scrollToBottom();
    });
  }

  void _sendSolarFlareGift() {
    _sendMessage('☀️ Sending you a Solar Flare blessing for your ${widget.contact.houseTier.title}!');
    GameState.instance.addEclipsePoints(
      25,
      'Solar Flare Gift Exchanged (+25 EP)',
    );
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent + 80,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.systemGroupedBackground,
      navigationBar: CupertinoNavigationBar(
        middle: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: widget.contact.avatarColor,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  widget.contact.initials,
                  style: const TextStyle(
                    color: CupertinoColors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.contact.fullName,
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                Text(
                  'Lv ${widget.contact.houseLevel} ${widget.contact.houseTier.title}',
                  style: TextStyle(
                    fontSize: 10,
                    color: widget.contact.houseTier.accentColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final msg = _messages[index];
                  return Align(
                    alignment: msg.isMe
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 10,
                      ),
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.76,
                      ),
                      decoration: BoxDecoration(
                        color: msg.isMe
                            ? const Color(0xFF0284C7)
                            : CupertinoColors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: CupertinoColors.systemGrey.withValues(
                              alpha: 0.12,
                            ),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Text(
                        msg.text,
                        style: TextStyle(
                          color: msg.isMe
                              ? CupertinoColors.white
                              : CupertinoColors.black,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              color: CupertinoColors.white,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _QuickActionChip(
                      label: '☀️ Send Solar Flare (+25 EP)',
                      onTap: _sendSolarFlareGift,
                    ),
                    const SizedBox(width: 8),
                    _QuickActionChip(
                      label: '🏡 How did you reach Lv ${widget.contact.houseLevel}?',
                      onTap: () => _sendMessage('How did you upgrade to Lv ${widget.contact.houseLevel}? Any tips?'),
                    ),
                    const SizedBox(width: 8),
                    _QuickActionChip(
                      label: '📍 Beautiful realm coordinates!',
                      onTap: () => _sendMessage('Your estate at ${widget.contact.locationName} looks incredible on the map!'),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: CupertinoColors.white,
                border: Border(
                  top: BorderSide(
                    color: CupertinoColors.separator.withValues(alpha: 0.5),
                  ),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: CupertinoTextField(
                      controller: _textController,
                      placeholder: 'Message ${widget.contact.firstName}...',
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: CupertinoColors.extraLightBackgroundGray,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      onSubmitted: (_) => _sendMessage(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  CupertinoButton(
                    padding: EdgeInsets.zero,
                    onPressed: () => _sendMessage(),
                    child: Container(
                      width: 38,
                      height: 38,
                      decoration: const BoxDecoration(
                        color: Color(0xFF0284C7),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        CupertinoIcons.arrow_up,
                        color: CupertinoColors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickActionChip extends StatelessWidget {
  const _QuickActionChip({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: const Color(0xFF0284C7).withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: const Color(0xFF0284C7).withValues(alpha: 0.3),
          ),
        ),
        child: Text(
          label,
          style: const TextStyle(
            color: Color(0xFF0284C7),
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
