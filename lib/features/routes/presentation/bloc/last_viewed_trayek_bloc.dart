import 'package:flutter_bloc/flutter_bloc.dart';

import 'last_viewed_trayek_event.dart';
import 'last_viewed_trayek_state.dart';

class LastViewedTrayekBloc
    extends Bloc<LastViewedTrayekEvent, LastViewedTrayekState> {
  LastViewedTrayekBloc() : super(const LastViewedTrayekInitial()) {
    on<LastViewedTrayekUpdated>((event, emit) {
      emit(LastViewedTrayekLoaded(event.trayek));
    });
  }
}