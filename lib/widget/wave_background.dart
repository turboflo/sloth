import 'package:flutter/material.dart';
import 'package:wave/config.dart';
import 'package:wave/wave.dart';

class WaveBackground extends StatelessWidget {
  const WaveBackground({
    Key? key,
    required this.colors,
  }) : super(key: key);

  final ColorScheme colors;

  @override
  Widget build(BuildContext context) {
    return WaveWidget(
      config: CustomConfig(
        colors: [
          colors.secondary,
          colors.primary,
        ],
        durations: [
          8000,
          6400,
        ],
        heightPercentages: [
          0.70,
          0.72,
        ],
      ),
      backgroundColor: colors.background,
      size: const Size(double.infinity, double.infinity),
      waveAmplitude: 0,
    );
  }
}
