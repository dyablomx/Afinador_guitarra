import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class MetronomePage extends StatefulWidget {
  const MetronomePage({super.key});
  @override
  State<MetronomePage> createState() => _MetronomePageState();
}

class _MetronomePageState extends State<MetronomePage> {
  final AudioPlayer _player = AudioPlayer();
  Timer? _timer;
  double _bpm = 100;
  bool _isPlaying = false;
  int _beat = -1; // tiempo actual (0 a 3)

  @override
  void initState() {
    super.initState();
    _player.setPlayerMode(PlayerMode.lowLatency);
  }

  Duration get _interval => Duration(milliseconds: (60000 / _bpm).round());

  void _tick() {
    _player.play(AssetSource('click.wav'));
    setState(() => _beat = (_beat + 1) % 4);
  }

  void _start() {
    _beat = -1;
    _tick();
    _timer = Timer.periodic(_interval, (_) => _tick());
    setState(() => _isPlaying = true);
  }

  void _stop() {
    _timer?.cancel();
    setState(() {
      _isPlaying = false;
      _beat = -1;
    });
  }

  void _changeBpm(double value) {
    setState(() => _bpm = value);
    if (_isPlaying) {
      _timer?.cancel();
      _timer = Timer.periodic(_interval, (_) => _tick());
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Metrónomo')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '${_bpm.round()}',
            style: const TextStyle(fontSize: 80, fontWeight: FontWeight.bold),
          ),
          const Text('BPM'),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(4, (i) {
              return Container(
                margin: const EdgeInsets.all(8),
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: i == _beat ? Colors.teal : Colors.grey.shade300,
                ),
              );
            }),
          ),
          Slider(min: 40, max: 220, value: _bpm, onChanged: _changeBpm),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: _isPlaying ? _stop : _start,
            icon: Icon(_isPlaying ? Icons.stop : Icons.play_arrow),
            label: Text(_isPlaying ? 'Detener' : 'Iniciar'),
          ),
        ],
      ),
    );
  }
}
