import 'package:flutter/material.dart';
import 'package:pixel_adventure/pixel_adventure.dart';

class SoundSlider extends StatefulWidget {
  final PixelAdventure game;
  const SoundSlider({super.key, required this.game});

  @override
  State<SoundSlider> createState() => _SoundSliderState();
}

class _SoundSliderState extends State<SoundSlider> {
  late double _currentSliderValue;

  @override
  void initState() {
    _currentSliderValue = widget.game.soundVolume;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text('Volume: ', style: TextStyle(fontSize: 16, color: Colors.white)),

        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            trackHeight: 8,
            thumbShape: RoundSliderThumbShape(enabledThumbRadius: 10),
          ),
          child: Slider(
            value: _currentSliderValue,
            min: 0.0,
            max: 1.0,
            divisions: 10,
            label: (_currentSliderValue * 100).round().toString(),
            onChanged: (value) {
              setState(() {
                _currentSliderValue = value;
              });
              widget.game.soundVolume = value;

              widget.game.soundVolume == 0
                  ? widget.game.playSounds = false
                  : widget.game.playSounds = true;
            },
          ),
        ),
      ],
    );
  }
}
