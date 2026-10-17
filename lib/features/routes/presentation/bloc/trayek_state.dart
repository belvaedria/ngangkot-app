import '../../data/models/trayek_model.dart';

abstract class TrayekState {
  const TrayekState();
}

class TrayekInitial extends TrayekState {
  const TrayekInitial();
}

class TrayekLoading extends TrayekState {
  const TrayekLoading();
}

class TrayekLoaded extends TrayekState {
  final List<TrayekModel> trayeks;

  const TrayekLoaded(this.trayeks);
}

class TrayekError extends TrayekState {
  final String message;

  const TrayekError(this.message);
}