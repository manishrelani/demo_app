part of 'landing_cubit.dart';

sealed class LandingState {
  const LandingState();
}

final class LandingLoading extends LandingState {}

final class LandingNavigate extends LandingState {
  final String screen;

  const LandingNavigate(this.screen);
}

final class LandingError extends LandingState {}
