import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/trayek_bloc.dart';
import '../bloc/trayek_event.dart';
import '../bloc/trayek_state.dart';
import '../pages/trayek_detail_page.dart';

class TrayekListView extends StatelessWidget {
  const TrayekListView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TrayekBloc, TrayekState>(
      builder: (context, state) {
        if (state is TrayekInitial || state is TrayekLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is TrayekError) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.cloud_off_outlined, size: 44),
                  const SizedBox(height: 12),
                  Text(state.message, textAlign: TextAlign.center),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () {
                      context.read<TrayekBloc>().add(const TrayekRequested());
                    },
                    child: const Text('Coba lagi'),
                  ),
                ],
              ),
            ),
          );
        }

        if (state is TrayekLoaded) {
          if (state.trayeks.isEmpty) {
            return const Center(child: Text('Belum ada data trayek.'));
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: state.trayeks.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final trayek = state.trayeks[index];

              return Card(
                clipBehavior: Clip.antiAlias,
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  leading: CircleAvatar(
                    backgroundColor: Color(
                      int.parse(trayek.warnaAngkot.replaceFirst('#', '0xFF')),
                    ),
                    child: const Icon(
                      Icons.directions_bus,
                      color: Colors.white,
                    ),
                  ),
                  title: Text(
                    trayek.namaTrayek,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => TrayekDetailPage(initialTrayek: trayek),
                      ),
                    );
                  },
                ),
              );
            },
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}
