import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
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
                    ),
                  ),
                  SizedBox(width: 24),
                  Expanded(
                    child: Text(
                      'LinguaLearn — это некоммерческий портал, созданный для поддержки студентов в изучении иностранных языков. '
                      'Мы предлагаем доступ к качественным образовательным ресурсам, интерактивным курсам и поддержке сообщества. '
                      'Наша цель — помочь вам развить языковые навыки, необходимые для успешной учебы и карьеры.',
                      style: TextStyle(fontSize: 40),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 40),
              Divider(),
              SizedBox(
                height: 40,
              ),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Изучайте в своем темпе',
                      style: TextStyle(
                        fontSize: 40,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(
                    width: 24,
                  ),
                  Expanded(
                    child: Image.network(
                      'https://media.istockphoto.com/id/1483233750/ru/%D1%84%D0%BE%D1%82%D0%BE/%D0%BF%D0%B0%D1%80%D0%B0-%D0%B4%D0%B5%D0%BB%D0%BE%D0%B2%D1%8B%D1%85-%D0%BB%D1%8E%D0%B4%D0%B5%D0%B9-%D0%B3%D1%83%D0%BB%D1%8F%D1%8E%D1%82-%D0%B2%D0%BC%D0%B5%D1%81%D1%82%D0%B5-%D0%B8-%D1%80%D0%B0%D0%B7%D0%B3%D0%BE%D0%B2%D0%B0%D1%80%D0%B8%D0%B2%D0%B0%D1%8E%D1%82.jpg?s=2048x2048&w=is&k=20&c=f6d-YnoTqkx5uRgHavcK1kj2puonC-oCaChGsTOZ61Q=',
                    ),
                  ),
                ],
              ),
              SizedBox(height: 40),
              Divider(),
              SizedBox(
                height: 40,
              ),
              Row(
                children: [
                  Expanded(
                    child: Image.network(
                      'https://media.istockphoto.com/id/1345613849/ru/%D0%B2%D0%B5%D0%BA%D1%82%D0%BE%D1%80%D0%BD%D0%B0%D1%8F/%D0%BC%D1%83%D0%B6%D1%87%D0%B8%D0%BD%D1%8B-%D0%B1%D0%B5%D1%81%D0%B5%D0%B4%D1%83%D1%8E%D1%82.jpg?s=2048x2048&w=is&k=20&c=OFzA2k8MJkHcWa3EYN4TZBGSVy2IEcVNErpXRs6eKgs=',
                      // height: 500,
                      // width: 700,
                      // fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(
                    width: 24,
                  ),
                  Expanded(
                    child: Text(
                      'Изучайте новый язык с уверенностью',
                      style: TextStyle(
                        fontSize: 40,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 40),
              Divider(),
              SizedBox(
                height: 40,
              ),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Развивайте свои навыки различными инструментами',
                      style: TextStyle(
                        fontSize: 40,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(
                    width: 24,
                  ),
                  Expanded(
                    child: Image.network(
                      'https://media.istockphoto.com/id/1316967414/ru/%D1%84%D0%BE%D1%82%D0%BE/%D0%B2%D0%B8%D0%B4-%D1%81%D0%B2%D0%B5%D1%80%D1%85%D1%83-%D0%B7%D0%B0%D0%B6%D0%B8%D0%BC%D0%B0-%D0%B3%D0%B0%D0%B5%D1%87%D0%BD%D0%BE%D0%B3%D0%BE-%D0%BA%D0%BB%D1%8E%D1%87%D0%B0-%D0%B8-%D0%B4%D0%BE%D1%81%D0%BA%D0%B8-%D0%BD%D0%B0%D0%BF%D0%B8%D1%81%D0%B0%D0%BD%D0%BD%D0%BE%D0%B9-%D1%81-develop-your-skills-%D0%BD%D0%B0-%D0%B1%D0%B5%D0%BB%D0%BE%D0%BC-%D0%B4%D0%B5%D1%80%D0%B5%D0%B2%D1%8F%D0%BD%D0%BD%D0%BE%D0%BC.jpg?s=2048x2048&w=is&k=20&c=KGGQHQwh7dYDSsNG6HEijSWBnAG7Fg8SciGI_3wHz04=',
                    ),
                  ),
                ],
              ),
              SizedBox(height: 40),
              Divider(),
              SizedBox(
                height: 40,
              ),
              statistics(),
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
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Готовы погрузиться в уникальный путь изучения языков ? ->',
                    style: TextStyle(color: Colors.redAccent),
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    child: Text('Зарегистрироваться'),
                  ),
                ],
              ),
              SizedBox(height: 20),

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

Container statistics() {
  return Container(
    color: Colors.yellow[200],
    width: double.infinity,
    child: Column(
      children: [
        Text(
          'Статистика',
        ),
        AspectRatio(
          aspectRatio: 1.3,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: AspectRatio(
                  aspectRatio: 1,
                  child: PieChart(
                    PieChartData(
                        sectionsSpace: 0,
                        centerSpaceRadius: 40,
                        sections: List.generate(4, (i) {
                          const radius = 50.0;
                          const fontSize = 16.0;
                          switch (i) {
                            case 0:
                              return PieChartSectionData(
                                value: 40,
                                title: '40%',
                                radius: radius,
                                titleStyle: TextStyle(
                                  fontSize: fontSize,
                                  fontWeight: FontWeight.bold,
                                ),
                              );
                            case 1:
                              return PieChartSectionData(
                                value: 30,
                                title: '30%',
                                radius: radius,
                                titleStyle: TextStyle(
                                  fontSize: fontSize,
                                  fontWeight: FontWeight.bold,
                                ),
                              );
                            case 2:
                              return PieChartSectionData(
                                value: 15,
                                title: '15%',
                                radius: radius,
                                titleStyle: TextStyle(
                                  fontSize: fontSize,
                                  fontWeight: FontWeight.bold,
                                ),
                              );
                            case 3:
                              return PieChartSectionData(
                                value: 15,
                                title: '15%',
                                radius: radius,
                                titleStyle: TextStyle(
                                  fontSize: fontSize,
                                  fontWeight: FontWeight.bold,
                                ),
                              );
                            default:
                              throw Error();
                          }
                        })),
                  ),
                ),
              ),
              // PieChart(
              //   PieChartData(),
              // ),
            ],
          ),
        ),
      ],
    ),
  );
}
