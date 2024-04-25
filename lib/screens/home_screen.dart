import "dart:convert";

import "package:fltr_m_001_random_meal_generator/models/meal.dart";
import "package:flutter/material.dart";
import "package:http/http.dart" as http;
import "package:youtube_player_flutter/youtube_player_flutter.dart";

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Meal _meal;
  bool _isLoading = false;

  late final YoutubePlayerController? _controller;

  @override
  void initState() {
    super.initState();
    _getRandomMeal();
  }

  @override
  void dispose() {
    _controller!.dispose();
    super.dispose();
  }

  Future _getRandomMeal() async {
    setState(() {
      _isLoading = true;
    });
    final http.Response response = await http.get(
      Uri.parse(
        "https://www.themealdb.com/api/json/v1/1/random.php",
      ),
    );

    Meal meal = Meal.fromMap(
      map: json.decode(response.body),
    );

    setState(() {
      _meal = meal;
      _isLoading = false;
    });
    print(_meal.youtubeUrl);
    _controller = _meal.youtubeUrl == null
        ? null
        : YoutubePlayerController(
            initialVideoId: _meal.youtubeUrl!,
            flags: const YoutubePlayerFlags(
              autoPlay: false,
              mute: false,
            ),
          );
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            MaterialButton(
              onPressed: _getRandomMeal,
              minWidth: double.infinity,
              height: size.height * 0.125,
              color: Colors.black,
              elevation: 0,
              padding: const EdgeInsets.symmetric(
                vertical: 12.0,
                horizontal: 48.0,
              ),
              child: const Text(
                "Feeling Hungry",
                style: TextStyle(
                  fontSize: 24.0,
                  color: Colors.white,
                ),
              ),
            ),
            _isLoading
                ? const Center(
                    child: CircularProgressIndicator(
                      color: Colors.black,
                    ),
                  )
                : Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        height: size.height * 0.5,
                        child: Image.network(
                          _meal.imageUrl!,
                          width: double.infinity,
                          height: size.height * 0.5,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _meal.name!,
                              style: const TextStyle(
                                fontSize: 26.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 12.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  ".${_meal.category!}",
                                  textAlign: TextAlign.end,
                                  style: const TextStyle(
                                    fontSize: 18.0,
                                    color: Colors.black87,
                                  ),
                                ),
                                const SizedBox(width: 24.0),
                                Text(
                                  ".${_meal.area!}",
                                  textAlign: TextAlign.start,
                                  style: const TextStyle(
                                    fontSize: 18.0,
                                    color: Colors.black87,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12.0),
                            if (_meal.tags != null && _meal.tags!.isNotEmpty)
                              Row(
                                children: [
                                  const Text(
                                    "Tags: ",
                                    style: TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(width: 4.0),
                                  Text(_meal.tags!.join(", ")),
                                ],
                              ),
                            if (_meal.tags != null && _meal.tags!.isNotEmpty)
                              const SizedBox(height: 12.0),
                            const Text(
                              "Ingredients: ",
                              style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4.0),
                            ListView(
                              shrinkWrap: true,
                              children: _meal.ingredients
                                  .map(
                                    (i) => Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 4.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          const Icon(
                                            Icons.arrow_right_alt,
                                            size: 12.0,
                                            color: Colors.black87,
                                          ),
                                          const SizedBox(width: 8.0),
                                          Text("${i.ingredient}: "),
                                          const SizedBox(width: 4.0),
                                          Text(
                                            i.measure,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                  .toList(),
                            ),
                            const SizedBox(height: 12.0),
                            const Text(
                              "Instructions: ",
                              style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4.0),
                            Text(_meal.instructions!),
                            const SizedBox(height: 24.0),
                            if (_meal.youtubeUrl != null)
                              SizedBox(
                                width: double.infinity,
                                height: size.height * 0.5,
                                child: YoutubePlayer(
                                  controller: _controller!,
                                ),
                              ),
                            SizedBox(height: size.height * 0.2),
                          ],
                        ),
                      ),
                    ],
                  ),
          ],
        ),
      ),
    );
  }
}
