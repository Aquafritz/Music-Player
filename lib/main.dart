// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, camel_case_types, sort_child_properties_last, sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:audioplayers/audioplayers.dart';


void main() {
 WidgetsFlutterBinding.ensureInitialized();
  Future.delayed(const Duration(seconds: 3), () {
    FlutterNativeSplash.remove();
    runApp(const MainApp());
  });
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: HomePage(),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset('video/vidback.mp4')
      ..initialize().then((_) {
        _controller.setLooping(true);
        _controller.setVolume(0.0);
        _controller.play();
        setState(() {});
      });
  }

 @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SizedBox.expand(
            child: FittedBox(
              fit: BoxFit.cover,
              child: SizedBox(
                width: _controller.value.size.width,
                height: _controller.value.size.height,
                child: VideoPlayer(_controller),
              ),
            ),
          ),
           Center(
             child: cardswipe(),
           ),
        ],
      ),
      
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}

class CardData {
  final String imagePath;
  final String audioPath;

  CardData({required this.imagePath, required this.audioPath});
}

class cardswipe extends StatelessWidget {
  final List<CardData> cards = [
    CardData(imagePath: 'assets/iceicebaby.jpg', audioPath: 'song/iceice.mp3'),
    CardData(imagePath: 'assets/idonnawanna.jpg', audioPath: 'song/idonwanna.mp3'),
    CardData(imagePath: 'assets/barbiegirl.jpg', audioPath: 'song/barbie.mp3'),
    CardData(imagePath: 'assets/basketbol.jpg', audioPath: 'song/basketbol.mp3'),
    CardData(imagePath: 'assets/beautifulsunday.jpg', audioPath: 'song/sunday.mp3'),
    CardData(imagePath: 'assets/bulaklak.jpg', audioPath: 'song/bulaklak.mp3'),
    CardData(imagePath: 'assets/inano.jpg', audioPath: 'song/inano.mp3'),
    CardData(imagePath: 'assets/nothingsgonna.png', audioPath: 'song/nothingsgonnachange.mp3'),
    CardData(imagePath: 'assets/obladi.jpg', audioPath: 'song/obladi.mp3'),
    CardData(imagePath: 'assets/touchbytouch.jpg', audioPath: 'song/touchbytouch.mp3'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      height: 300,
      child: CardSwiper(
        cardsCount: cards.length,
       cardBuilder: (context, index, percentThresholdX, percentThresholdY) {
          return _buildCard(index, cards);
       }
      ),
    );
  }
}

Widget _buildCard(int index, List<CardData> cards) {
  return Container(
    width: 300,
    height: 300,
    decoration: BoxDecoration(
      image: DecorationImage(
        image: AssetImage(cards[index].imagePath),
        fit: BoxFit.cover,
      ),
    ),
    child: InkWell(
      onTap: () {
        _stopAndPlayAudio(cards[index].audioPath);
      },
    ),
  );
}

AudioPlayer? _audioPlayer;

void _stopAndPlayAudio(String audioPath) async {
  try {
    if (_audioPlayer != null) {
      await _audioPlayer!.stop();
    }
    _audioPlayer = AudioPlayer();
    await _audioPlayer!.play(UrlSource(audioPath));
  } catch (error) {
    debugPrint('Error playing audio: $error');
    // Handle the error gracefully, e.g., display a message to the user
  }
}