import 'package:flutter/material.dart';

abstract class ThemeEvent {
  const ThemeEvent();
}

class ThemeModeChanged extends ThemeEvent {
  final ThemeMode themeMode;

  const ThemeModeChanged(this.themeMode);
}