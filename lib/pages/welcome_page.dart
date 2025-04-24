import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:video_player/video_player.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final String videoUrl =
        'https://videos.pexels.com/video-files/31576430/13457171_1920_1080_30fps.mp4';

    return Scaffold(
      appBar: AppBar(
        title: Text('Добро пожаловать на LinguaLearn!'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Заголовок
              Text(
                'Изучайте языки легко и увлекательно!',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),

              // Описание
              Row(
                children: [
                  Expanded(
                    child: Image.network(
                      'https://media.istockphoto.com/id/2173915109/photo/skill-competency-development-concept-up-new-ability-skill-training-for-technology-evolution.jpg?s=2048x2048&w=is&k=20&c=EntBZe7FHA2R7aGAA8OlfMgN7aoLf95MwU3ZOTk0iIU=', // Замените на URL вашей картинки
                      height: 200,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      'LinguaLearn — это некоммерческий портал, созданный для поддержки студентов в изучении иностранных языков. '
                      'Мы предлагаем доступ к качественным образовательным ресурсам, интерактивным курсам и поддержке сообщества. '
                      'Наша цель — помочь вам развить языковые навыки, необходимые для успешной учебы и карьеры.',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),

              // Преимущества
              Text(
                'Преимущества:',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                '• Разнообразие языков: Изучайте английский, испанский, французский и другие языки.',
                style: TextStyle(fontSize: 18),
              ),
              Text(
                '• Интерактивные уроки: Уникальные методики обучения, которые делают процесс увлекательным.',
                style: TextStyle(fontSize: 18),
              ),
              Text(
                '• Поддержка сообщества: Общайтесь с другими учащимися и преподавателями.',
                style: TextStyle(fontSize: 18),
              ),
              Text(
                '• Доступ к ресурсам: Получите доступ к множеству учебных материалов, включая видео, аудио и текстовые задания.',
                style: TextStyle(fontSize: 18),
              ),
              Text(
                '• Академическая поддержка: Наша команда всегда готова помочь вам с любыми вопросами.',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 20),

              // Кнопки действий
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      // Действие для кнопки "Начать обучение"
                    },
                    child: Text('Начать обучение'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // Действие для кнопки "Посмотреть демо-уроки"
                    },
                    child: Text('Посмотреть демо-уроки'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // Действие для кнопки "Зарегистрироваться"
                    },
                    child: Text('Зарегистрироваться'),
                  ),
                ],
              ),
              SizedBox(height: 20),
              //VideoPlayerScreen(videoUrl: videoUrl),
              //YouTubePlayerScreen(),

              // Контактная информация
              Text(
                'Есть вопросы? Свяжитесь с нами: support@lingualearn.com',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 10),
              Text(
                'Политика конфиденциальности | Условия использования',
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class VideoPlayerScreen extends StatefulWidget {
  final String videoUrl;

  VideoPlayerScreen({required this.videoUrl});

  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl))
      ..initialize().then((_) {
        setState(() {}); // Обновляем состояние после инициализации
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Проверяем, инициализирован ли контроллер
        _controller.value.isInitialized
            ? AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller),
              )
            : CircularProgressIndicator(),
        SizedBox(height: 10),
        // Кнопка для воспроизведения/паузы
        FloatingActionButton(
          onPressed: () {
            setState(() {
              _controller.value.isPlaying
                  ? _controller.pause()
                  : _controller.play();
            });
          },
          child: Icon(
            _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
          ),
        ),
      ],
    );
  }
}

class YouTubePlayerScreen extends StatefulWidget {
  const YouTubePlayerScreen({super.key});

  @override
  _YouTubePlayerScreenState createState() => _YouTubePlayerScreenState();
}

class _YouTubePlayerScreenState extends State<YouTubePlayerScreen> {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController.fromVideoId(
      videoId: '2S9oO8MQi0o', // Замените на ID вашего видео
      params: const YoutubePlayerParams(
        showControls: true,
        showFullscreenButton: true,
        mute: false,
      ),
    );
  }

  @override
  void dispose() {
    _controller.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('YouTube Player'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            YoutubePlayer(
              controller: _controller,
              aspectRatio: 16 / 9,
            ),
          ],
        ),
      ),
    );
  }
}
