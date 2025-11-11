import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:geolocator/geolocator.dart';
import '../../weather/data/weather_service.dart';

class WeatherBadge extends StatefulWidget {
  const WeatherBadge({super.key});

  @override
  State<WeatherBadge> createState() => _WeatherBadgeState();
}

class _WeatherBadgeState extends State<WeatherBadge> {
  WeatherInfo? _info;
  String? _err;

  // Fallback: Tunis
  static const _fallbackLat = 36.8065;
  static const _fallbackLon = 10.1815;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      double lat = _fallbackLat;
      double lon = _fallbackLon;

      // Try to get permission & GPS, else fallback
      final enabled = await Geolocator.isLocationServiceEnabled();
      LocationPermission perm = await Geolocator.checkPermission();
      if (perm == LocationPermission.denied || perm == LocationPermission.deniedForever) {
        perm = await Geolocator.requestPermission();
      }
      if (enabled && (perm == LocationPermission.always || perm == LocationPermission.whileInUse)) {
        final pos = await Geolocator.getCurrentPosition();
        lat = pos.latitude;
        lon = pos.longitude;
      }

      final info = await WeatherService.fetch(lat, lon);
      if (!mounted) return;
      setState(() => _info = info);
    } catch (e) {
      if (!mounted) return;
      setState(() => _err = e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final dateStr = DateFormat.yMMMMEEEEd().format(DateTime.now());
    final color = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: color.surfaceVariant.withOpacity(0.7),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.outlineVariant.withOpacity(0.5)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(dateStr, style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(width: 10),
          if (_info != null) Row(
            children: [
              Text(_info!.emoji, style: const TextStyle(fontSize: 18)),
              const SizedBox(width: 6),
              Text('${_info!.temperatureC.toStringAsFixed(0)}°C',
                  style: Theme.of(context).textTheme.titleMedium),
            ],
          )
          else if (_err != null)
            const Icon(Icons.cloud_off, size: 18)
          else
            const SizedBox(
              width: 18, height: 18,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
        ],
      ),
    );
  }
}
