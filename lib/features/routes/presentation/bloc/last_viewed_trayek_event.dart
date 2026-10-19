import '../../data/models/trayek_model.dart';

abstract class LastViewedTrayekEvent {
  const LastViewedTrayekEvent();
}

class LastViewedTrayekUpdated extends LastViewedTrayekEvent {
  final TrayekModel trayek;

  const LastViewedTrayekUpdated(this.trayek);
}