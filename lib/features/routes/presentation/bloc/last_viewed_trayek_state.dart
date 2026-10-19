import '../../data/models/trayek_model.dart';

abstract class LastViewedTrayekState {
  const LastViewedTrayekState();
}

class LastViewedTrayekInitial extends LastViewedTrayekState {
  const LastViewedTrayekInitial();
}

class LastViewedTrayekLoaded extends LastViewedTrayekState {
  final TrayekModel trayek;

  const LastViewedTrayekLoaded(this.trayek);
}