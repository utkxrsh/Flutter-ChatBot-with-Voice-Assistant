import 'package:chatbot/feature_box.dart';
import 'package:flutter/material.dart';
import 'package:chatbot/pallete.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final speechToText = SpeechToText();
  String lastWords = '';
  @override
  void initState() {
    super.initState();
    initSpeechToText();
  }

  Future<void> initSpeechToText() async {
    await speechToText.initialize();
    setState(() {});
  }

  Future<void> startListening() async {
    await speechToText.listen(onResult: onSpeechResult);
    setState(() {});
  }

  Future<void> stopListening() async {
    await speechToText.stop();
    setState(() {});
  }

  void onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      lastWords = result.recognizedWords;
    });
  }

  @override
  void dispose() {
    super.dispose();
    speechToText.stop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vortex'),
        leading: const Icon(Icons.menu_outlined),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(children: [
          // ai image
          Stack(
            children: [
              const Center(
                  // child: Container(
                  //     height: 120,
                  //     width: 120,
                  //     margin: const EdgeInsetsDirectional.only(top: 4),
                  //     decoration: const BoxDecoration(
                  //         color: Pallete.assistantCircleColor,
                  //         shape: BoxShape.circle)),
                  ),
              Container(
                height: 175,
                decoration: const BoxDecoration(
                  shape: BoxShape.rectangle,
                  image: DecorationImage(
                    image: AssetImage('assets/images/chatbot.png'),
                  ),
                ),
              )
            ],
          ),
          // chat bot intro message
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 10,
            ),
            margin: const EdgeInsets.symmetric(horizontal: 40).copyWith(
              top: 30,
            ),
            decoration: BoxDecoration(
              border: Border.all(
                color: Pallete.borderColor,
              ),
              borderRadius: BorderRadius.circular(20).copyWith(
                topLeft: const Radius.circular(0),
              ),
            ),
            child: const Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                'What task can I do for you ?',
                style: TextStyle(
                  fontFamily: 'Cera Pro',
                  color: Pallete.mainFontColor,
                  fontSize: 25,
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(10),
            margin: const EdgeInsets.only(left: 22, top: 10),
            alignment: Alignment.centerLeft,
            child: const Text(
              'Here are few commands',
              style: TextStyle(
                  fontFamily: 'Cera Pro',
                  fontWeight: FontWeight.bold,
                  color: Pallete.mainFontColor,
                  fontSize: 20),
            ),
          ),
          // Suggestion commands
          Column(
            children: const [
              FeatureBox(
                color: Color.fromARGB(255, 91, 155, 250),
                headerText: 'ChatGPT',
                descriptionText:
                    'A smarter way to stay organized with ChatGPT.',
              ),
              FeatureBox(
                color: Color.fromARGB(255, 156, 214, 251),
                headerText: 'Dall-E',
                descriptionText:
                    'Get inspired and stay creative with your personal assistant powered by Dall-E.',
              ),
              FeatureBox(
                color: Pallete.thirdSuggestionBoxColor,
                headerText: 'Smart Voice Assistant',
                descriptionText:
                    'Get best of both worlds with a voice assistant powered by Dall-E & ChatGPT.',
              ),
            ],
          )
        ]),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromARGB(255, 70, 248, 153),
        onPressed: () async {
          if (await speechToText.hasPermission && speechToText.isNotListening) {
            await startListening();
          } else if (speechToText.isListening) {
            await stopListening();
          } else {
            initSpeechToText();
          }
        },
        child: const Icon(
          Icons.mic_rounded,
          size: 30,
        ),
      ),
    );
  }
}
