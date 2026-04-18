import 'package:flutter/material.dart';

// ── Kategori ──────────────────────────────────────────────────────────────────
enum DestinationCategory { semua, sejarah, pantai, alam, kuliner }

extension DestinationCategoryLabel on DestinationCategory {
  String get label {
    switch (this) {
      case DestinationCategory.semua:
        return 'Semua';
      case DestinationCategory.sejarah:
        return 'Sejarah';
      case DestinationCategory.pantai:
        return 'Pantai';
      case DestinationCategory.alam:
        return 'Alam';
      case DestinationCategory.kuliner:
        return 'Kuliner';
    }
  }

  IconData get icon {
    switch (this) {
      case DestinationCategory.semua:
        return Icons.apps_rounded;
      case DestinationCategory.sejarah:
        return Icons.account_balance_rounded;
      case DestinationCategory.pantai:
        return Icons.beach_access_rounded;
      case DestinationCategory.alam:
        return Icons.park_rounded;
      case DestinationCategory.kuliner:
        return Icons.restaurant_rounded;
    }
  }
}

// ── Models ────────────────────────────────────────────────────────────────────
class NearbyDestination {
  final String name;
  final double rating;
  final String distance;
  final String description;
  final String imagePath;

  const NearbyDestination({
    required this.name,
    required this.rating,
    required this.distance,
    required this.description,
    required this.imagePath,
  });
}

class DestinationData {
  final String title;
  final String categoryLabel;
  final DestinationCategory category;
  final String distance;
  final String jamBuka;
  final String hargaTiket;
  final String description;
  final String shortDesc;
  final String lokasi;
  final List<String> tags;
  final List<String> tips;
  final List<NearbyDestination> nearby;
  final String imagePath;   // path gambar utama
  final Color bgColor;      // warna fallback jika gambar gagal
  final double mapsLat;
  final double mapsLng;

  const DestinationData({
    required this.title,
    required this.categoryLabel,
    required this.category,
    required this.distance,
    required this.jamBuka,
    required this.hargaTiket,
    required this.description,
    required this.shortDesc,
    required this.lokasi,
    required this.tags,
    required this.tips,
    required this.nearby,
    required this.imagePath,
    required this.bgColor,
    required this.mapsLat,
    required this.mapsLng,
  });
}

// ── Semua Data Destinasi ──────────────────────────────────────────────────────
const List<DestinationData> allDestinations = [

  // ── PANTAI ──────────────────────────────────────────────────────────────────
  DestinationData(
    title: 'Pantai Trikora',
    categoryLabel: 'Pantai',
    category: DestinationCategory.pantai,
    distance: '38 km dari pusat',
    jamBuka: '24 Jam',
    hargaTiket: 'Rp 10.000/orang',
    shortDesc: 'Pantai pasir putih dengan air jernih dan pemandangan matahari terbit yang memukau.',
    description:
        'Pantai Trikora merupakan salah satu pantai terbaik di Kepulauan Riau dengan hamparan pasir putih halus yang memanjang sepanjang beberapa kilometer. Terletak di timur Pulau Bintan, pantai ini menawarkan air laut yang jernih dan pemandangan matahari terbit yang memukau.',
    lokasi: 'Gunung Kijang, Bintan, Tanjungpinang',
    tags: ['Pantai', 'Snorkeling', 'Sunset', 'Seafood'],
    tips: [
      'Terbaik dikunjungi saat musim kemarau (April–Oktober)',
      'Tersedia penginapan di sekitar pantai',
      'Coba aktivitas snorkeling dan banana boat',
    ],
    nearby: [
      NearbyDestination(
        name: 'Pantai Senggiling',
        rating: 4.2,
        distance: '26 km',
        description: 'Pantai tenang cocok untuk bersantai',
        imagePath: 'assets/images/onboarding1.jpg',
      ),
      NearbyDestination(
        name: 'Taman Tepi Laut',
        rating: 4.5,
        distance: '38 km',
        description: 'Taman kota di tepi pantai yang populer',
        imagePath: 'assets/images/onboarding2.jpg',
      ),
    ],
    imagePath: 'assets/images/onboarding1.jpg',
    bgColor: Color(0xFF1A9BD7),
    mapsLat: 1.1085,
    mapsLng: 104.5435,
  ),

  DestinationData(
    title: 'Pantai Senggiling',
    categoryLabel: 'Pantai',
    category: DestinationCategory.pantai,
    distance: '12 km dari pusat',
    jamBuka: '24 Jam',
    hargaTiket: 'Gratis',
    shortDesc: 'Pantai tenang dan tidak terlalu ramai, cocok untuk bersantai bersama keluarga.',
    description:
        'Pantai Senggiling adalah pantai yang lebih tenang dan tidak terlalu ramai. Suasananya yang damai menjadikannya pilihan ideal untuk bersantai bersama keluarga, menikmati angin laut, dan menikmati pemandangan sunset yang indah.',
    lokasi: 'Jl. Gambir, Tanjungpinang',
    tags: ['Pantai', 'Sunset', 'Keluarga'],
    tips: [
      'Bawa bekal sendiri karena warung makan terbatas',
      'Kunjungi sore hari untuk menikmati sunset',
      'Cocok untuk piknik keluarga di akhir pekan',
    ],
    nearby: [
      NearbyDestination(
        name: 'Pantai Trikora',
        rating: 4.8,
        distance: '26 km',
        description: 'Pantai pasir putih ikonik di Bintan',
        imagePath: 'assets/images/onboarding1.jpg',
      ),
    ],
    imagePath: 'assets/images/onboarding2.jpg',
    bgColor: Color(0xFF26A69A),
    mapsLat: 0.9210,
    mapsLng: 104.4460,
  ),

  // ── SEJARAH ──────────────────────────────────────────────────────────────────
  DestinationData(
    title: 'Pulau Penyengat',
    categoryLabel: 'Sejarah',
    category: DestinationCategory.sejarah,
    distance: '15 menit dari pelabuhan',
    jamBuka: '24 Jam',
    hargaTiket: 'Rp 5.000/orang (ferry)',
    shortDesc: 'Pulau bersejarah bekas pusat Kerajaan Riau-Lingga dengan masjid yang dibangun dari putih telur.',
    description:
        'Pulau Penyengat adalah pulau kecil bersejarah yang pernah menjadi pusat Kerajaan Riau-Lingga. Di sini terdapat Masjid Raya Sultan Riau yang legendaris — dibangun dengan campuran putih telur sebagai bahan perekat. Pulau ini juga menyimpan istana, benteng, dan berbagai peninggalan budaya Melayu yang kaya.',
    lokasi: 'Pulau Penyengat, Tanjungpinang',
    tags: ['Sejarah', 'Budaya', 'Melayu', 'Religi'],
    tips: [
      'Naik pompong dari Pelabuhan Penyengat, harga Rp 8.000',
      'Sewa sepeda motor di pulau untuk keliling lebih mudah',
      'Kunjungi saat pagi agar tidak terlalu panas',
    ],
    nearby: [
      NearbyDestination(
        name: 'Masjid Raya Sultan Riau',
        rating: 4.8,
        distance: '0.2 km',
        description: 'Masjid ikonik dengan putih telur',
        imagePath: 'assets/images/onboarding3.jpg',
      ),
      NearbyDestination(
        name: 'Benteng Bukit Kursi',
        rating: 4.4,
        distance: '0.8 km',
        description: 'Benteng pertahanan era kerajaan',
        imagePath: 'assets/images/onboarding2.jpg',
      ),
    ],
    imagePath: 'assets/images/onboarding3.jpg',
    bgColor: Color(0xFFEF5350),
    mapsLat: 0.9265,
    mapsLng: 104.4607,
  ),

  DestinationData(
    title: 'Masjid Raya Sultan Riau',
    categoryLabel: 'Sejarah',
    category: DestinationCategory.sejarah,
    distance: '15 menit dari pelabuhan',
    jamBuka: '24 Jam',
    hargaTiket: 'Gratis',
    shortDesc: 'Masjid ikonik abad ke-18 yang dibangun dengan putih telur, simbol kejayaan Kerajaan Riau.',
    description:
        'Masjid Raya Sultan Riau adalah salah satu masjid paling ikonik di Indonesia. Dibangun pada abad ke-18, masjid ini terkenal karena menggunakan putih telur sebagai campuran semen. Bangunan berwarna kuning cerah ini menjadi pusat spiritual sekaligus simbol kejayaan Kerajaan Riau-Lingga.',
    lokasi: 'Pulau Penyengat, Tanjungpinang',
    tags: ['Sejarah', 'Religi', 'Arsitektur', 'Melayu'],
    tips: [
      'Kenakan pakaian sopan saat berkunjung',
      'Tersedia mukena dan sarung gratis untuk pengunjung',
      'Datang saat waktu sholat untuk suasana lebih sakral',
    ],
    nearby: [
      NearbyDestination(
        name: 'Pulau Penyengat',
        rating: 4.9,
        distance: '0.2 km',
        description: 'Pusat wisata sejarah Kerajaan Riau-Lingga',
        imagePath: 'assets/images/onboarding3.jpg',
      ),
    ],
    imagePath: 'assets/images/onboarding2.jpg',
    bgColor: Color(0xFFFFB300),
    mapsLat: 0.9268,
    mapsLng: 104.4601,
  ),

  DestinationData(
    title: 'Benteng Bukit Kursi',
    categoryLabel: 'Sejarah',
    category: DestinationCategory.sejarah,
    distance: '18 km dari pusat',
    jamBuka: '24 Jam',
    hargaTiket: 'Gratis',
    shortDesc: 'Benteng pertahanan era Kerajaan Riau-Lingga dengan panorama laut yang menakjubkan.',
    description:
        'Benteng Bukit Kursi merupakan benteng pertahanan yang dibangun pada masa Kerajaan Riau-Lingga di Pulau Penyengat. Dari puncak benteng, pengunjung dapat menikmati panorama laut yang indah dan pemandangan kota Tanjungpinang dari kejauhan.',
    lokasi: 'Pulau Penyengat, Tanjungpinang',
    tags: ['Sejarah', 'Benteng', 'Pemandangan'],
    tips: [
      'Bawa air minum karena trek cukup menanjak',
      'Terbaik dikunjungi pagi hari sebelum terik',
      'Pemandangan terbaik saat cuaca cerah',
    ],
    nearby: [
      NearbyDestination(
        name: 'Masjid Raya Sultan Riau',
        rating: 4.8,
        distance: '0.8 km',
        description: 'Masjid ikonik dengan putih telur',
        imagePath: 'assets/images/onboarding2.jpg',
      ),
    ],
    imagePath: 'assets/images/onboarding1.jpg',
    bgColor: Color(0xFF8D6E63),
    mapsLat: 0.9280,
    mapsLng: 104.4620,
  ),

  // ── ALAM ──────────────────────────────────────────────────────────────────────
  DestinationData(
    title: 'Taman Tepi Laut',
    categoryLabel: 'Alam',
    category: DestinationCategory.alam,
    distance: '2 km dari pusat',
    jamBuka: '24 Jam',
    hargaTiket: 'Gratis',
    shortDesc: 'Taman kota di tepi pantai yang menjadi tempat hangout favorit warga Tanjungpinang.',
    description:
        'Taman Tepi Laut adalah ruang publik favorit warga Tanjungpinang yang terletak tepat di tepi laut. Taman ini menjadi tempat berkumpul yang ramai terutama di sore dan malam hari. Pengunjung dapat menikmati pemandangan laut atau jogging di sepanjang jalur pejalan kaki.',
    lokasi: 'Jl. Tepi Laut, Tanjungpinang',
    tags: ['Alam', 'Taman', 'Keluarga', 'Gratis'],
    tips: [
      'Kunjungi sore hari untuk menikmati sunset',
      'Banyak pedagang kaki lima di sekitar taman',
      'Cocok untuk olahraga pagi atau jogging',
    ],
    nearby: [
      NearbyDestination(
        name: 'Pasar Bawah',
        rating: 4.3,
        distance: '0.5 km',
        description: 'Pasar tradisional ikonik Tanjungpinang',
        imagePath: 'assets/images/onboarding3.jpg',
      ),
    ],
    imagePath: 'assets/images/onboarding2.jpg',
    bgColor: Color(0xFF66BB6A),
    mapsLat: 0.9184,
    mapsLng: 104.4607,
  ),

  DestinationData(
    title: 'Taman Batu 10',
    categoryLabel: 'Alam',
    category: DestinationCategory.alam,
    distance: '10 km dari pusat',
    jamBuka: '06.00–22.00',
    hargaTiket: 'Gratis',
    shortDesc: 'Ruang terbuka publik dengan area bermain, jogging track, dan suasana yang asri.',
    description:
        'Taman Batu 10 adalah ruang terbuka hijau yang populer di kawasan Batu 10, Tanjungpinang Timur. Taman ini dilengkapi dengan area bermain anak, bangku taman, jogging track, dan berbagai fasilitas olahraga.',
    lokasi: 'Bintan Center, Pinang Kencana, Tanjungpinang Timur',
    tags: ['Alam', 'Taman', 'Olahraga', 'Gratis'],
    tips: [
      'Bawa anak-anak karena ada area bermain',
      'Ramai saat akhir pekan',
      'Fasilitas toilet tersedia di dalam taman',
    ],
    nearby: [
      NearbyDestination(
        name: 'Taman Tepi Laut',
        rating: 4.5,
        distance: '10 km',
        description: 'Taman di tepi laut favorit warga',
        imagePath: 'assets/images/onboarding2.jpg',
      ),
    ],
    imagePath: 'assets/images/onboarding3.jpg',
    bgColor: Color(0xFF43A047),
    mapsLat: 0.9413,
    mapsLng: 104.4953,
  ),

  DestinationData(
    title: 'Bukit Kursi Bintanh',
    categoryLabel: 'Alam',
    category: DestinationCategory.alam,
    distance: '20 km dari pusat',
    jamBuka: '06.00–18.00',
    hargaTiket: 'Gratis',
    shortDesc: 'Spot trekking dengan panorama alam Bintan yang hijau dan laut biru dari ketinggian.',
    description:
        'Bukit Kursi Bintanh menawarkan pengalaman wisata alam yang menyegarkan dengan trekking ringan menuju puncak bukit. Dari atas, pengunjung dapat menikmati panorama alam Bintan yang hijau dan laut biru yang memukau.',
    lokasi: 'Jl. Gambir, Tanjungpinang',
    tags: ['Alam', 'Trekking', 'Pemandangan', 'Outdoor'],
    tips: [
      'Gunakan alas kaki yang nyaman untuk trekking',
      'Bawa air minum yang cukup',
      'Hindari kunjungan saat musim hujan',
    ],
    nearby: [
      NearbyDestination(
        name: 'Pantai Senggiling',
        rating: 4.2,
        distance: '5 km',
        description: 'Pantai tenang cocok untuk bersantai',
        imagePath: 'assets/images/onboarding1.jpg',
      ),
    ],
    imagePath: 'assets/images/onboarding1.jpg',
    bgColor: Color(0xFF558B2F),
    mapsLat: 1.0100,
    mapsLng: 104.5100,
  ),

  // ── KULINER ──────────────────────────────────────────────────────────────────
  DestinationData(
    title: 'Pasar Bawah Tanjungpinang',
    categoryLabel: 'Kuliner',
    category: DestinationCategory.kuliner,
    distance: '1 km dari pusat',
    jamBuka: '06.00–22.00',
    hargaTiket: 'Gratis',
    shortDesc: 'Pasar tradisional ikonik di pinggir laut dengan beragam kuliner dan produk lokal.',
    description:
        'Pasar Bawah Tanjungpinang adalah pusat perdagangan dan kuliner di kota ini. Terletak di tepi laut, pasar ini menjual hasil laut segar, rempah-rempah, kain batik, hingga kuliner khas Melayu dan Tionghoa yang menggugah selera.',
    lokasi: 'Jl. Merdeka & Kawasan Tepi Laut, Tanjungpinang',
    tags: ['Kuliner', 'Belanja', 'Budaya', 'Seafood'],
    tips: [
      'Kunjungi pagi hari untuk produk segar',
      'Coba gonggong (siput laut) segar dari nelayan',
      'Tawar-menawar harga adalah hal biasa',
    ],
    nearby: [
      NearbyDestination(
        name: 'Taman Tepi Laut',
        rating: 4.5,
        distance: '0.5 km',
        description: 'Taman di tepi laut favorit warga',
        imagePath: 'assets/images/onboarding2.jpg',
      ),
    ],
    imagePath: 'assets/images/onboarding3.jpg',
    bgColor: Color(0xFFFF7043),
    mapsLat: 0.9175,
    mapsLng: 104.4614,
  ),

  DestinationData(
    title: 'Wisata Kuliner Gonggong',
    categoryLabel: 'Kuliner',
    category: DestinationCategory.kuliner,
    distance: '3 km dari pusat',
    jamBuka: '10.00–22.00',
    hargaTiket: 'Rp 30.000–Rp 80.000',
    shortDesc: 'Kuliner ikonik Tanjungpinang: siput laut gonggong yang segar dengan sambal kacang khas.',
    description:
        'Gonggong adalah kuliner ikonik Tanjungpinang yang wajib dicoba. Siput laut ini direbus dan disajikan dengan sambal kacang yang khas. Banyak warung di tepi laut yang menyajikan gonggong segar langsung dari nelayan lokal.',
    lokasi: 'Kawasan Tepi Laut, Tanjungpinang',
    tags: ['Kuliner', 'Seafood', 'Gonggong', 'Khas TPI'],
    tips: [
      'Paling enak dengan sambal kacang khasnya',
      'Pilih warung yang ramai pengunjung lokal',
      'Harga bervariasi, nego sebelum pesan',
    ],
    nearby: [
      NearbyDestination(
        name: 'Pasar Bawah',
        rating: 4.3,
        distance: '0.5 km',
        description: 'Pasar tradisional ikonik',
        imagePath: 'assets/images/onboarding3.jpg',
      ),
    ],
    imagePath: 'assets/images/onboarding1.jpg',
    bgColor: Color(0xFFAB47BC),
    mapsLat: 0.9200,
    mapsLng: 104.4580,
  ),

  DestinationData(
    title: 'Kedai Kopi Sakanak',
    categoryLabel: 'Kuliner',
    category: DestinationCategory.kuliner,
    distance: '1.5 km dari pusat',
    jamBuka: '07.00–22.00',
    hargaTiket: 'Gratis (beli minuman)',
    shortDesc: 'Kedai kopi tertua di Tanjungpinang dengan suasana autentik dan kopi seduhan tradisional.',
    description:
        'Kedai Kopi Sakanak adalah salah satu kedai kopi tertua di Tanjungpinang. Suasana autentik dengan dekorasi jadul dan kopi yang diseduh tradisional menjadi daya tarik tersendiri. Nikmati kopi dengan camilan khas seperti roti bakar dan kue tradisional Melayu.',
    lokasi: 'Jl. Bintan, Tanjungpinang',
    tags: ['Kuliner', 'Kopi', 'Tradisional', 'Nongkrong'],
    tips: [
      'Coba kopi susu khasnya yang creamy',
      'Buka dari pagi, cocok untuk sarapan',
      'Suasana ramai di pagi dan sore hari',
    ],
    nearby: [
      NearbyDestination(
        name: 'Pasar Bawah',
        rating: 4.3,
        distance: '0.3 km',
        description: 'Pasar tradisional ikonik',
        imagePath: 'assets/images/onboarding3.jpg',
      ),
    ],
    imagePath: 'assets/images/onboarding2.jpg',
    bgColor: Color(0xFF6D4C41),
    mapsLat: 0.9188,
    mapsLng: 104.4598,
  ),

  DestinationData(
    title: 'Mie Tarempa Khas Kepri',
    categoryLabel: 'Kuliner',
    category: DestinationCategory.kuliner,
    distance: '2 km dari pusat',
    jamBuka: '09.00–21.00',
    hargaTiket: 'Rp 20.000–Rp 35.000',
    shortDesc: 'Mie khas Kepulauan Riau dengan kuah gurih berbasis ikan dan rempah pilihan.',
    description:
        'Mie Tarempa adalah kuliner khas Kepulauan Riau dengan kuah berbasis ikan yang kaya rempah. Mie kuning tebal yang kenyal dengan topping ikan tuna suwir, telur, dan sambal pedas yang menggugah selera.',
    lokasi: 'Jl. Desiana, Tanjungpinang',
    tags: ['Kuliner', 'Mie', 'Khas Kepri', 'Seafood'],
    tips: [
      'Minta level pedas sesuai selera',
      'Datang sebelum jam makan siang agar tidak antri',
      'Porsi cukup besar, bisa untuk berbagi',
    ],
    nearby: [
      NearbyDestination(
        name: 'Wisata Kuliner Gonggong',
        rating: 4.6,
        distance: '1 km',
        description: 'Siput laut ikonik Tanjungpinang',
        imagePath: 'assets/images/onboarding1.jpg',
      ),
    ],
    imagePath: 'assets/images/onboarding3.jpg',
    bgColor: Color(0xFFFF8A65),
    mapsLat: 0.9195,
    mapsLng: 104.4620,
  ),

  DestinationData(
    title: 'Akau Potong Lembu',
    categoryLabel: 'Kuliner',
    category: DestinationCategory.kuliner,
    distance: '1 km dari pusat',
    jamBuka: '06.00–23.00',
    hargaTiket: 'Gratis (beli makanan)',
    shortDesc: 'Kawasan kuliner malam terpopuler dengan ratusan warung makanan khas lokal.',
    description:
        'Akau Potong Lembu adalah kawasan kuliner malam yang sangat populer. Di sepanjang jalan ini berjejer ratusan warung makan dengan berbagai kuliner khas Melayu, Tionghoa, dan nusantara — dari seafood hingga bubur Melayu.',
    lokasi: 'Jl. Gambir, Tanjungpinang',
    tags: ['Kuliner', 'Malam', 'Street Food', 'Seafood'],
    tips: [
      'Paling ramai mulai pukul 18.00–22.00',
      'Parkir tersedia di sekitar area',
      'Harga bervariasi dan bisa ditawar',
    ],
    nearby: [
      NearbyDestination(
        name: 'Pasar Bawah',
        rating: 4.3,
        distance: '0.5 km',
        description: 'Pasar tradisional ikonik',
        imagePath: 'assets/images/onboarding3.jpg',
      ),
    ],
    imagePath: 'assets/images/onboarding2.jpg',
    bgColor: Color(0xFFE53935),
    mapsLat: 0.9180,
    mapsLng: 104.4590,
  ),
];