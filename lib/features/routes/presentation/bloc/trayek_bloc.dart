import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';
import '../../data/repositories/trayek_repository.dart';
import 'trayek_event.dart';
import 'trayek_state.dart';

class TrayekBloc extends Bloc<TrayekEvent, TrayekState> {
  final TrayekRepository repository;

  TrayekBloc({required this.repository}) : super(const TrayekInitial()) {
    on<TrayekRequested>(_onTrayekRequested);
  }

  Future<void> _onTrayekRequested(
    TrayekRequested event,
    Emitter<TrayekState> emit,
  ) async {
    emit(const TrayekLoading());

    try {
      final trayeks = await repository.getTrayeks();
      emit(TrayekLoaded(trayeks));
    } catch (error, stackTrace) {
      debugPrint('ERROR MEMUAT TRAYEK: $error');
      debugPrintStack(stackTrace: stackTrace);

      emit(TrayekError('Gagal memuat data trayek. Silakan coba lagi.'));
    }
  }
}
