import 'package:flutter/material.dart';
import 'package:dash_chat_2/dash_chat_2.dart';

import 'package:flutter_application_1/service/gemini.dart';

class DoctorScreen extends StatefulWidget {
  const DoctorScreen({super.key});

  @override
  State<DoctorScreen> createState() => _DoctorScreenState();
}

class _DoctorScreenState extends State<DoctorScreen> {
  final ChatUser user1 = ChatUser(id: '1', firstName: 'me');
  final ChatUser user2 = ChatUser(id: '2', firstName: 'bot');

  final List<ChatMessage> messagesList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 65, 23, 78),
      appBar: AppBar(
        title: const Text('Doctor Chat'),
        backgroundColor: Colors.purple,
      ),
      body: DashChat(
        messageListOptions: MessageListOptions(
          onLoadEarlier: () async {
            await Future.delayed(const Duration(seconds: 1));
          },
        ),
        scrollToBottomOptions: const ScrollToBottomOptions(),
        // messageOptions: MessageOptions(
        //   avatarBuilder: (p0, onPressAvatar, onLongPressAvatar) {
        //     return Image.network(
        //       'https://media.discordapp.net/attachments/1544648774100459611/1546216449863843991/1280px-Google_Gemini_icon_2025.svg.png?ex=6a9ef9c8&is=6a9da848&hm=01b45075aedd015085ef761058894a82b4384fbbd4a8e705e198fbc997c9a8b0&=&format=webp&quality=lossless&width=700&height=700',
        //       height: 30,
        //       width: 30,
        //     );
        //   },
        // ),
        currentUser: user1,
        onSend: (message) async {
          messagesList.insert(0, message);
          setState(() {});

          try {
            final botMessage = await GeminiAPI().sendRequest(message.text);
            if (!mounted) return;
            messagesList.insert(
              0,
              ChatMessage(
                user: user2,
                createdAt: DateTime.now(),
                text: botMessage,
              ),
            );
            setState(() {});
          } catch (e) {
            if (!mounted) return;
            messagesList.insert(
              0,
              ChatMessage(
                user: user2,
                createdAt: DateTime.now(),
                text: e.toString(),
              ),
            );
            setState(() {});
          }
        },
        messages: messagesList,
      ),
    );
  }
}
