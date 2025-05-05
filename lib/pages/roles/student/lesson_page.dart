import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:igi_course_project/DAL/models/course/course.dart';
import 'package:igi_course_project/DAL/models/lesson/lesson.dart';
import 'package:igi_course_project/DAL/models/lesson/question.dart';
import 'package:igi_course_project/DAL/models/user_result/user_result.dart';
import 'package:igi_course_project/bloc/user_result/user_result_bloc.dart';
import 'package:igi_course_project/bloc/user_result/user_result_event.dart';
import 'package:igi_course_project/bloc/user_result/user_result_state.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart'
    hide PlayerState;

class LessonPage extends StatefulWidget {
  final Lesson lesson;
  final Course course;
  final String userId;
  const LessonPage(
      {super.key,
      required this.course,
      required this.userId,
      required this.lesson});

  @override
  State<LessonPage> createState() => _LessonPageState();
}

class _LessonPageState extends State<LessonPage> {
  final Map<String, String?> testUserAnswers = {};
  final Map<String, String?> writtenExerciseAnswers = {};
  late List<YoutubePlayerController> _youtubePlayerControllers;
  late AudioPlayer _audioPlayer;
  PlayerState? _playerState;
  Duration? _duration;
  Duration? _position;
  double _volume = 1.0;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _audioPlayer.setReleaseMode(ReleaseMode.stop);
    if (widget.lesson.theoryUrls.isNotEmpty) {
      _youtubePlayerControllers = widget.lesson.theoryUrls.map((url) {
        final videoId = YoutubePlayerController.convertUrlToId(url);
        return YoutubePlayerController.fromVideoId(
          videoId: videoId!,
          params: const YoutubePlayerParams(
            showControls: true,
            showFullscreenButton: true,
            mute: false,
          ),
        );
      }).toList();
    }

    _initAudioPlayerStreams();
  }

  void _initAudioPlayerStreams() {
    _audioPlayer.onDurationChanged.listen((duration) {
      setState(() {
        _duration = duration;
      });
    });

    _audioPlayer.onPositionChanged.listen((position) {
      setState(() {
        _position = position;
      });
    });

    _audioPlayer.onPlayerStateChanged.listen((state) {
      setState(() {
        _playerState = state;
      });
    });

    _audioPlayer.onPlayerComplete.listen((event) {
      setState(() {
        _playerState = PlayerState.stopped;
        _position = Duration.zero;
      });
    });
  }

  @override
  void dispose() {
    for (var c in _youtubePlayerControllers) {
      c.close();
    }
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.lesson.title),
      ),
      body: BlocBuilder<UserResultBloc, UserResultState>(
          builder: (context, state) {
        if (state is InProgress) {
          return Center(
              child:
                  CircularProgressIndicator()); // Показываем индикатор загрузки
        } else if (state is UserResultSaved) {
          return Center(
              child:
                  Text('Результаты успешно сохранены!')); // Успешное сохранение
        } else if (state is UserResultError) {
          return Center(
              child: Text(
                  'Ошибка при сохранении результатов: ${state.message}')); // Ошибка
        }
        return ListView(
          children: [
            if (widget.lesson.theoryUrls.isNotEmpty)
              Text(
                'Theory',
                style: Theme.of(context).textTheme.displayLarge,
                textAlign: TextAlign.center,
              ),
            if (widget.lesson.theoryUrls.isNotEmpty)
              Column(
                children: _youtubePlayerControllers.map((controller) {
                  return Padding(
                    padding: const EdgeInsets.all(90.0),
                    child: YoutubePlayer(
                      controller: controller,
                      aspectRatio: 16 / 9,
                    ),
                  );
                }).toList(),
              ),
            // Отображение грамматических упражнений
            Text(
              'Grammar Exercises',
              style: Theme.of(context).textTheme.displayLarge,
              textAlign: TextAlign.center,
            ),
            ...widget.lesson.grammarExercises.map((exercise) {
              return ExpansionTile(
                title: Text(
                  exercise.type,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                children: exercise.questions.map((question) {
                  return QuestionWidget(
                    question: question,
                    onAnswerSelected: (selectedOption) {
                      testUserAnswers[question.task] = selectedOption;
                    },
                  );
                }).toList(),
              );
            }).toList(),

            Text(
              'Reading Exercises',
              style: Theme.of(context).textTheme.displayLarge,
              textAlign: TextAlign.center,
            ),

            // Отображение чтения
            ...widget.lesson.readingExercises.map((exercise) {
              return ExpansionTile(
                title: Text(
                  exercise.type,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      exercise.text,
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ),
                  ...exercise.questions.map((question) {
                    return QuestionWidget(
                      question: question,
                      onAnswerSelected: (selectedOption) {
                        testUserAnswers[question.task] = selectedOption;
                      },
                    );
                  }).toList(),
                ],
              );
            }).toList(),

            Text(
              'Audition Exercises',
              style: Theme.of(context).textTheme.displayLarge,
              textAlign: TextAlign.center,
            ),

            // Отображение аудирования
            ...widget.lesson.auditionExercises.map((exercise) {
              return ExpansionTile(
                  title: Text(
                    exercise.type,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  children: [
                    // Аудиоплеер для воспроизведения аудиофайла
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                icon: Icon(Icons.play_arrow),
                                onPressed: () async {
                                  await _audioPlayer.setSource(UrlSource(
                                    exercise.url,
                                  ));
                                  await _audioPlayer.resume();
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.pause),
                                onPressed: () async {
                                  await _audioPlayer.pause();
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.stop),
                                onPressed: () async {
                                  await _audioPlayer.stop();
                                },
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              Icon(Icons.volume_up),
                              Slider(
                                value: _volume,
                                min: 0.0,
                                max: 1.0,
                                onChanged: (value) {
                                  setState(() {
                                    _volume = value;
                                    _audioPlayer.setVolume(
                                        _volume); // Устанавливаем громкость
                                  });
                                },
                              ),
                            ],
                          ),
                          Slider(
                            value: (_position != null &&
                                    _duration != null &&
                                    _position!.inMilliseconds > 0 &&
                                    _position!.inMilliseconds <
                                        _duration!.inMilliseconds)
                                ? _position!.inMilliseconds /
                                    _duration!.inMilliseconds
                                : 0.0,
                            onChanged: (value) {
                              final duration = _duration;
                              if (duration == null) {
                                return;
                              }
                              final position = value * duration.inMilliseconds;
                              _audioPlayer.seek(
                                  Duration(milliseconds: position.round()));
                            },
                          ),
                          Text(
                            _position != null
                                ? '${_position.toString().split('.').first} / ${_duration.toString().split('.').first}'
                                : _duration != null
                                    ? _duration.toString().split('.').first
                                    : '',
                            style: const TextStyle(fontSize: 16.0),
                          ),
                        ],
                      ),
                    ),
                    ...exercise.questions.map((question) {
                      return QuestionWidget(
                        question: question,
                        onAnswerSelected: (selectedOption) {
                          testUserAnswers[question.task] = selectedOption;
                        },
                      );
                    }),
                  ]);
            }).toList(),

            Text(
              'Written Exercises',
              style: Theme.of(context).textTheme.displayLarge,
              textAlign: TextAlign.center,
            ),
            // Отображение письменных упражнений
            ...widget.lesson.writtenExercises.map((exercise) {
              return Card(
                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(exercise.task, style: TextStyle(fontSize: 16)),
                      SizedBox(height: 8),
                      TextField(
                        onChanged: (value) {
                          setState(() {
                            //testUserAnswers[exercise.task] = value;
                            writtenExerciseAnswers[exercise.task] = value;
                            // Сохраняем ответ в userAnswers
                          });
                        },
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Введите ваш ответ',
                        ),
                      ),
                      SizedBox(height: 8),
                      if (writtenExerciseAnswers[exercise.task] != null)
                        Text(
                          'Ваш ответ: ${writtenExerciseAnswers[exercise.task]}',
                          style: TextStyle(color: Colors.blue),
                        ),
                    ],
                  ),
                ),
              );
            }).toList(),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () {
                  List<String> correctAnswers = [];
                  List<String?> writtenAnswers =
                      []; // Для хранения ответов на письменные упражнения

                  // Сбор всех правильных ответов из всех типов упражнений
                  for (var lesson in widget.course.lessons) {
                    for (var exercise in lesson.grammarExercises) {
                      for (var question in exercise.questions) {
                        correctAnswers.add(question.answer);
                      }
                    }

                    for (var exercise in lesson.readingExercises) {
                      for (var question in exercise.questions) {
                        correctAnswers.add(question.answer);
                      }
                    }

                    for (var exercise in lesson.auditionExercises) {
                      for (var question in exercise.questions) {
                        correctAnswers.add(question.answer);
                      }
                    }

                    for (var exercise in lesson.writtenExercises) {
                      writtenAnswers.add(writtenExerciseAnswers[
                          exercise.task]); // Добавляем ответ студента
                    }
                  }

                  // Подсчет баллов
                  double score = 0;
                  for (var lesson in widget.course.lessons) {
                    for (var exercise in lesson.grammarExercises) {
                      for (var question in exercise.questions) {
                        String questionTask =
                            question.task; // Получаем текст задания
                        if (testUserAnswers[questionTask] == question.answer) {
                          score++;
                        }
                      }
                    }

                    for (var exercise in lesson.readingExercises) {
                      for (var question in exercise.questions) {
                        String questionTask =
                            question.task; // Получаем текст задания
                        if (testUserAnswers[questionTask] == question.answer) {
                          score++;
                        }
                      }
                    }

                    for (var exercise in lesson.auditionExercises) {
                      for (var question in exercise.questions) {
                        String questionTask =
                            question.task; // Получаем текст задания
                        if (testUserAnswers[questionTask] == question.answer) {
                          score++;
                        }
                      }
                    }
                  }

                  // Вычисляем процент
                  score = (score / correctAnswers.length) *
                      100; // Оценка в процентах

                  // Создаем объект UserResult
                  final userResult = UserResult(
                    userId: widget.userId,
                    courseId: widget.course.documentId,
                    lessonName: widget.lesson.title,
                    testAnswers: testUserAnswers.values.toList(),
                    correctAnswers: correctAnswers,
                    score: score,
                    testDate: DateTime.now(),
                    writtenExerciseAnswers: writtenAnswers,
                    teacherFeedback: [],
                  );
                  print(userResult);

                  // Сохраняем результаты
                  BlocProvider.of<UserResultBloc>(context).add(
                      SaveUserResultEvent(
                          widget.course.documentId, userResult));
                },
                child: Text('Сохранить результаты'),
              ),
            ),
          ],
        );
      }),
    );
  }
}

class QuestionWidget extends StatefulWidget {
  final Question question;
  final ValueChanged<String?> onAnswerSelected;

  const QuestionWidget(
      {super.key, required this.question, required this.onAnswerSelected});

  @override
  _QuestionWidgetState createState() => _QuestionWidgetState();
}

class _QuestionWidgetState extends State<QuestionWidget> {
  String? selectedOption;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.question.task, style: TextStyle(fontSize: 16)),
            SizedBox(height: 8),
            Column(
              children: widget.question.options.map((option) {
                return RadioListTile<String>(
                  title: Text(option),
                  value: option,
                  groupValue: selectedOption,
                  onChanged: (value) {
                    setState(() {
                      selectedOption = value;
                    });
                    widget.onAnswerSelected(value);
                  },
                );
              }).toList(),
            ),
            if (selectedOption != null)
              Text(
                'Выбранный ответ: $selectedOption',
                style: TextStyle(color: Colors.blue),
              ),
          ],
        ),
      ),
    );
  }
}
