// view/ai_assistant_screen.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../utils/app_styles.dart';
import '../../utils/app_size.dart';
import '../controller/ai_assistant/ai_assistant_controller.dart';
import '../model/ai_assistant/ai_assistant_model.dart';

class AiAssistantScreen extends StatefulWidget {
  const AiAssistantScreen({super.key});

  @override
  State<AiAssistantScreen> createState() => _AiAssistantScreenState();
}

class _AiAssistantScreenState extends State<AiAssistantScreen> {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _sendMessage(AiAssistantController controller) {
    final text = _textController.text.trim();
    if (text.isEmpty) return;
    _textController.clear();
    controller.sendMessage(text);
    _scrollToBottom();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AiAssistantController(),
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F6FA),
        appBar: _buildAppBar(),
        body: Consumer<AiAssistantController>(
          builder: (context, controller, _) {
            _scrollToBottom();
            return Column(
              children: [
                // Chat messages list
                Expanded(
                  child: controller.messages.isEmpty
                      ? _buildEmptyState()
                      : ListView.builder(
                          controller: _scrollController,
                          padding: EdgeInsets.all(AppSizes.pagePadding),
                          itemCount:
                              controller.messages.length +
                              (controller.isLoading ? 1 : 0),
                          itemBuilder: (context, index) {
                            // Show typing indicator
                            if (index == controller.messages.length) {
                              return _TypingIndicator();
                            }
                            final message = controller.messages[index];
                            return _MessageBubble(message: message);
                          },
                        ),
                ),

                // Input bar
                _buildInputBar(controller),
              ],
            );
          },
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0.5,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.black),
        onPressed: () => Navigator.pop(context),
      ),
      title: Row(
        children: [
          // AI Icon
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: const Color(0xFF1F8FB5).withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.auto_awesome,
              color: Color(0xFF1F8FB5),
              size: 18,
            ),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Ai Assistant',
                style: AppStyles.poppins(
                  fontSize: AppSizes.fs15,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              Text(
                'Metro line 3 • Station B4',
                style: AppStyles.poppins(
                  fontSize: AppSizes.fs11,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.auto_awesome,
            size: 48,
            color: const Color(0xFF1F8FB5).withValues(alpha: 0.4),
          ),
          const SizedBox(height: 12),
          Text(
            'Ask me anything about\nyour site safety',
            textAlign: TextAlign.center,
            style: AppStyles.poppins(
              fontSize: AppSizes.fs14,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputBar(AiAssistantController controller) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        AppSizes.w(16),
        AppSizes.h(10),
        AppSizes.w(16),
        AppSizes.h(24),
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Color(0x10000000),
            blurRadius: 8,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          // + button
          Container(
            width: AppSizes.w(36),
            height: AppSizes.w(36),
            decoration: BoxDecoration(
              color: const Color(0xFFF0F2F5),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.add, color: Colors.grey, size: 20),
          ),
          const SizedBox(width: 10),

          // Text field
          Expanded(
            child: TextField(
              controller: _textController,
              style: AppStyles.poppins(fontSize: AppSizes.fs14),
              decoration: InputDecoration(
                hintText: 'Type a Message',
                hintStyle: AppStyles.poppins(
                  fontSize: AppSizes.fs14,
                  color: Colors.grey,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: const Color(0xFFF0F2F5),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: AppSizes.w(16),
                  vertical: AppSizes.h(10),
                ),
              ),
              onSubmitted: (_) => _sendMessage(controller),
            ),
          ),
          const SizedBox(width: 10),

          // Mic / Send button
          GestureDetector(
            onTap: () => _sendMessage(controller),
            child: Container(
              width: AppSizes.w(44),
              height: AppSizes.w(44),
              decoration: const BoxDecoration(
                color: Color(0xFF1F8FB5),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.mic, color: Colors.white, size: 22),
            ),
          ),
        ],
      ),
    );
  }
}

// Message Bubble Widget
class _MessageBubble extends StatelessWidget {
  final AiMessage message;
  const _MessageBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    final isUser = message.role == MessageRole.user;
    final time = DateFormat('hh:mm a').format(message.timestamp);

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: isUser
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: [
          // Bubble
          Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.75,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: isUser
                  ? const Color(0xFF1F3A5F) // dark blue for user
                  : Colors.white, // white for AI
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(16),
                topRight: const Radius.circular(16),
                bottomLeft: Radius.circular(isUser ? 16 : 4),
                bottomRight: Radius.circular(isUser ? 4 : 16),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Text(
              message.content,
              style: AppStyles.poppins(
                fontSize: AppSizes.fs13,
                color: isUser ? Colors.white : const Color(0xFF2D2D2D),
                height: 1.5,
              ),
            ),
          ),

          // Timestamp
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              time,
              style: AppStyles.poppins(
                fontSize: AppSizes.fs10,
                color: Colors.grey,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Typing Indicator
class _TypingIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                _dot(delay: 0),
                const SizedBox(width: 4),
                _dot(delay: 200),
                const SizedBox(width: 4),
                _dot(delay: 400),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _dot({required int delay}) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.4, end: 1.0),
      duration: Duration(milliseconds: 600 + delay),
      builder: (_, value, __) => Opacity(
        opacity: value,
        child: Container(
          width: 8,
          height: 8,
          decoration: const BoxDecoration(
            color: Color(0xFF1F8FB5),
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
}
