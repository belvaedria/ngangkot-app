import '../../../../core/network/api_client.dart';
import '../models/trayek_model.dart';

class TrayekRepository {
  final ApiClient apiClient;

  TrayekRepository({required this.apiClient});

  Future<List<TrayekModel>> getTrayeks() async {
    final response = await apiClient.dio.get('/trayeks');

    final data = response.data;

    if (data is! List) {
      throw const FormatException(
        'Format respons API trayek tidak sesuai.',
      );
    }

    return data
        .map(
          (item) => TrayekModel.fromJson(
            Map<String, dynamic>.from(item as Map),
          ),
        )
        .toList();
  }

  Future<TrayekModel> getTrayekByKode(String kode) async {
    final response = await apiClient.dio.get(
      '/trayeks/${Uri.encodeComponent(kode)}',
    );

    final data = response.data;

    // Mendukung respons berupa objek langsung atau
    // objek yang dibungkus dalam key "data".
    final json = data is Map && data['data'] is Map
        ? Map<String, dynamic>.from(data['data'] as Map)
        : Map<String, dynamic>.from(data as Map);

    return TrayekModel.fromJson(json);
  }
}