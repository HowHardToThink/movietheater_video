import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart'; // Імпорт плагіна для YouTube

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Кінотеатр',
      home: MovieSelectionScreen(),
    );
  }
}

final List<String> movies = ['Форсаж 10', 'Людина-павук 2', 'Перевізник 2', 'Капітан Америка'];

final Map<String, List<String>> sessions = {
  'Форсаж 10': ['10:00', '12:00', '14:00'],
  'Людина-павук 2': ['11:00', '13:00', '15:00'],
  'Перевізник 2': ['16:00', '18:00', '20:00'],
  'Капітан Америка': ['17:00', '19:00', '21:00'],
};

// Мапа для ID відео трейлерів на YouTube
final Map<String, String> trailerIds = {
  'Людина-павук 2': '3jBFwltrxJw',
  'Форсаж 10': 'eoOaKN4qCKw',
  'Перевізник 2': 'hnG25MEwiPo',
  'Капітан Америка': 'JerVrbLldXw',
};

class MovieSelectionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/39774.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Виберіть фільм',
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                SizedBox(height: 20),
                for (String movie in movies)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                        backgroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SessionSelectionScreen(movie: movie),
                          ),
                        );
                      },
                      child: Text(
                        movie,
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SessionSelectionScreen extends StatelessWidget {
  final String movie;

  SessionSelectionScreen({required this.movie});

  @override
  Widget build(BuildContext context) {
    // Отримуємо ID трейлера для фільму
    final String trailerId = trailerIds[movie] ?? '';

    return Scaffold(
      appBar: AppBar(
        title: Text('Вибір сеансу'),
        backgroundColor: Colors.blueAccent,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/39774.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Виберіть сеанс для фільму $movie',
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),

              // Додаємо YouTube трейлер, якщо є ID трейлера
              if (trailerId.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: YoutubePlayer(
                    controller: YoutubePlayerController(
                      initialVideoId: trailerId,
                      flags: YoutubePlayerFlags(
                        autoPlay: false,
                        mute: false,
                      ),
                    ),
                    showVideoProgressIndicator: true,
                  ),
                ),

              for (String session in sessions[movie]!)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                      backgroundColor: Colors.blueAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SeatingChartScreen(movie: movie, session: session),
                        ),
                      );
                    },
                    child: Text(
                      session,
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class SeatingChartScreen extends StatefulWidget {
  final String movie;
  final String session;

  SeatingChartScreen({required this.movie, required this.session});

  @override
  _SeatingChartScreenState createState() => _SeatingChartScreenState();
}

class _SeatingChartScreenState extends State<SeatingChartScreen> {
  final int rows = 8;
  final int seatsPerRow = 10;
  late List<List<bool>> _seats;
  final List<int> rowPrices = [500, 450, 400, 350, 300, 250, 200, 150];

  @override
  void initState() {
    super.initState();
    _seats = List.generate(rows, (_) => List.generate(seatsPerRow, (_) => false));
  }

  void _toggleSeat(int row, int seat) {
    setState(() {
      _seats[row][seat] = !_seats[row][seat];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Вибір місць'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/39774.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Виберіть місця для сеансу ${widget.movie} о ${widget.session}',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Column(
                    children: [
                      for (int row = 0; row < rows; row++)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            for (int seat = 0; seat < seatsPerRow; seat++)
                              GestureDetector(
                                onTap: () => _toggleSeat(row, seat),
                                child: Container(
                                  margin: EdgeInsets.all(6.0),
                                  width: 35,
                                  height: 35,
                                  decoration: BoxDecoration(
                                    color: _seats[row][seat] ? Colors.green : Colors.grey,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Center(
                                    child: Text(
                                      '${seat + 1}',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                    backgroundColor: Colors.blueAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  onPressed: () {
                    List<String> selectedSeats = [];
                    int totalPrice = 0;
                    for (int row = 0; row < rows; row++) {
                      for (int seat = 0; seat < seatsPerRow; seat++) {
                        if (_seats[row][seat]) {
                          selectedSeats.add('Ряд ${row + 1}, Місце ${seat + 1}');
                          totalPrice += rowPrices[row];
                        }
                      }
                    }

                    if (selectedSeats.isNotEmpty) {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text('Вибрані місця'),
                          content: Text(
                            'Ви обрали:\n${selectedSeats.join('\n')}\n\nЗагальна ціна: $totalPrice грн',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text('ОК'),
                            ),
                          ],
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Будь ласка, виберіть місця')),
                      );
                    }
                  },
                  child: Text('Підтвердити вибір'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
