import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

abstract class ThemeState extends Equatable {
  const ThemeState();
  @override
  List<Object?> get props => [];
}

class ThemeInitial extends ThemeState {}
class ThemeLoadedState extends ThemeState {
  final ThemeMode themeMode;
  const ThemeLoadedState(this.themeMode);
  @override
  List<Object?> get props => [themeMode];
}

abstract class ThemeEvent extends Equatable {
  const ThemeEvent();
  @override
  List<Object?> get props => [];
}

class LoadThemeEvent extends ThemeEvent {}
class ToggleThemeEvent extends ThemeEvent {}
class SetThemeEvent extends ThemeEvent {
  final bool isDark;
  const SetThemeEvent(this.isDark);
  @override
  List<Object?> get props => [isDark];
}

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc() : super(ThemeInitial()) {
    on<LoadThemeEvent>(_onLoadTheme);
    on<ToggleThemeEvent>(_onToggleTheme);
    on<SetThemeEvent>(_onSetTheme);
  }

  Future<void> _onLoadTheme(LoadThemeEvent event, Emitter<ThemeState> emit) async {
    emit(const ThemeLoadedState(ThemeMode.light));
  }

  Future<void> _onToggleTheme(ToggleThemeEvent event, Emitter<ThemeState> emit) async {
    if (state is ThemeLoadedState) {
      final currentMode = (state as ThemeLoadedState).themeMode;
      final newMode = currentMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
      emit(ThemeLoadedState(newMode));
    }
  }

  Future<void> _onSetTheme(SetThemeEvent event, Emitter<ThemeState> emit) async {
    emit(ThemeLoadedState(event.isDark ? ThemeMode.dark : ThemeMode.light));
  }
}

enum ThemeMode { light, dark }
