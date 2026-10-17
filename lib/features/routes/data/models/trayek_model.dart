class TrayekModel {
  final int id;
  final String kodeTrayek;
  final String namaTrayek;
  final double latAsal;
  final double lngAsal;
  final double latTujuan;
  final double lngTujuan;
  final String? ruteJson;
  final List<String> daftarJalan;
  final String? gambarUrl;
  final String? kodeBalik;
  final bool tampilDiMenu;
  final int? harga;
  final String warnaAngkot;

  const TrayekModel({
    required this.id,
    required this.kodeTrayek,
    required this.namaTrayek,
    required this.latAsal,
    required this.lngAsal,
    required this.latTujuan,
    required this.lngTujuan,
    this.ruteJson,
    required this.daftarJalan,
    this.gambarUrl,
    this.kodeBalik,
    required this.tampilDiMenu,
    this.harga,
    required this.warnaAngkot,
  });

  factory TrayekModel.fromJson(Map<String, dynamic> json) {
    return TrayekModel(
      id: (json['id'] as num).toInt(),
      kodeTrayek: json['kode_trayek'] as String? ?? '',
      namaTrayek: json['nama_trayek'] as String? ?? '',
      latAsal: (json['lat_asal'] as num).toDouble(),
      lngAsal: (json['lng_asal'] as num).toDouble(),
      latTujuan: (json['lat_tujuan'] as num).toDouble(),
      lngTujuan: (json['lng_tujuan'] as num).toDouble(),
      ruteJson: json['rute_json'] as String?,
      daftarJalan: (json['daftar_jalan'] as List<dynamic>? ?? [])
          .map((jalan) => jalan.toString())
          .toList(),
      gambarUrl: json['gambar_url'] as String?,
      kodeBalik: json['kode_balik'] as String?,
      tampilDiMenu: json['tampil_di_menu'] as bool? ?? true,
      harga: (json['harga'] as num?)?.toInt(),
      warnaAngkot: json['warna_angkot'] as String? ?? '#2563EB',
    );
  }
}