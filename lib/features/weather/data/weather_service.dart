import 'dart:convert';
import 'package:http/http.dart' as http;

class WeatherInfo {
  final double temperatureC;
  final int weatherCode;

  WeatherInfo({required this.temperatureC, required this.weatherCode});

  String get emoji {
    // Simple mapping (Open-Meteo weathercode)
    final c = weatherCode;
    if ([0].contains(c)) return '☀️';
    if ([1, 2, 3].contains(c)) return '⛅';
    if ([45, 48].contains(c)) return '🌫️';
    if ([51, 53, 55, 56, 57].contains(c)) return '🌦️';
    if ([61, 63, 65, 66, 67, 80, 81, 82].contains(c)) return '🌧️';
    if ([71, 73, 75, 77, 85, 86].contains(c)) return '❄️';
    if ([95, 96, 99].contains(c)) return '⛈️';
    return '🌡️';
  }
}

class WeatherService {
  static Future<WeatherInfo> fetch(double lat, double lon) async {
    final uri = Uri.parse(
        'https://api.open-meteo.com/v1/forecast'
            '?latitude=$lat&longitude=$lon'
            '&current_weather=true'
    );
    final resp = await http.get(uri);
    if (resp.statusCode != 200) {
      throw Exception('Weather http ${resp.statusCode}');
    }
    final json = jsonDecode(resp.body) as Map<String, dynamic>;
    final cw = json['current_weather'] as Map<String, dynamic>;
    return WeatherInfo(
      temperatureC: (cw['temperature'] as num).toDouble(),
      weatherCode: (cw['weathercode'] as num).toInt(),
    );
  }
}
