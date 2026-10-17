import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/network/api_client.dart';
import '../../data/repositories/trayek_repository.dart';
import '../bloc/trayek_bloc.dart';
import '../bloc/trayek_event.dart';
import '../widgets/trayek_list_view.dart';

class TrayekPage extends StatelessWidget {
  const TrayekPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TrayekBloc(
        repository: TrayekRepository(
          apiClient: ApiClient(),
        ),
      )..add(const TrayekRequested()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Daftar Trayek'),
        ),
        body: const TrayekListView(),
      ),
    );
  }
}