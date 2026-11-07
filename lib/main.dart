import 'package:material_ui/material_ui.dart';

void main() => runApp(const MenuUmkmApp());

// ===== 1. MaterialApp + tema (hanya seed color yang ditulis langsung) =====
class MenuUmkmApp extends StatelessWidget {
  const MenuUmkmApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Menu UMKM Kuliner Medan',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFB3541E)),
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFB3541E),
          brightness: Brightness.dark,
        ),
      ),
      home: const HalamanMenu(),
    );
  }
}

// ===== Halaman utama: Stateless =====
class HalamanMenu extends StatelessWidget {
  const HalamanMenu({super.key});

  void _pesan(BuildContext context, String teks) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(teks)));
  }

  @override
  Widget build(BuildContext context) {
    final skema = Theme.of(context).colorScheme;
    final teks = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Mie Gomak Boru Medan')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // ----- Header: gambar, nama, deskripsi -----
          // Latar dari tema supaya ruang kosong di kiri/kanan gambar tetap rapi
          Container(
            decoration: BoxDecoration(
              color: skema.primaryContainer,
              borderRadius: BorderRadius.circular(16),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.asset(
                'assets/images/header.jpg',
                height: 180,
                width: double.infinity,
                fit: BoxFit.contain, // gambar tampil utuh, tidak terpotong
                errorBuilder: (context, error, stackTrace) => Container(
                  height: 180,
                  color: skema.primaryContainer,
                  child: const Center(
                    child: Icon(Icons.ramen_dining, size: 64),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text('Mie Gomak Boru Medan', style: teks.headlineSmall),
          const SizedBox(height: 4),
          Text(
            'Mie gomak khas Batak dengan kuah arsik dan sambal andaliman. '
            'Buka setiap hari di Medan.',
            style: teks.bodyMedium?.copyWith(color: skema.onSurfaceVariant),
          ),
          const SizedBox(height: 12),

          // ----- Tombol: FilledButton + OutlinedButton -----
          Row(
            children: [
              FilledButton.icon(
                onPressed: () => _pesan(context, 'Membuka pemesanan...'),
                icon: const Icon(Icons.shopping_bag_outlined),
                label: const Text('Pesan'),
              ),
              const SizedBox(width: 8),
              OutlinedButton.icon(
                onPressed: () => _pesan(context, 'Membuka peta...'),
                icon: const Icon(Icons.map_outlined),
                label: const Text('Lokasi'),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // ----- Kontak: Card + 3 ListTile -----
          const Card(
            child: Column(
              children: [
                ListTile(
                  leading: Icon(Icons.phone_outlined),
                  title: Text('+62 812-0000-0000'), // GANTI (nomor contoh)
                ),
                Divider(height: 1),
                ListTile(
                  leading: Icon(Icons.location_on_outlined),
                  title: Text('Jl. Contoh No. 1, Medan'), // GANTI
                ),
                Divider(height: 1),
                ListTile(
                  leading: Icon(Icons.schedule_outlined),
                  title: Text('Buka 10.00 - 00.00 WIB'), // GANTI
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          Text('Daftar Menu', style: teks.titleLarge),
          const SizedBox(height: 8),

          // ----- 4 menu: KartuMenu (Stateless) -----
          const KartuMenu(nama: 'Mie Gomak Arsik', harga: 'Rp 25.000', kategori: 'Makanan'),
          const KartuMenu(nama: 'Mie Gomak Kuah', harga: 'Rp 20.000', kategori: 'Makanan'),
          const KartuMenu(nama: 'Lapet Isi Kelapa', harga: 'Rp 8.000', kategori: 'Camilan'),
          const KartuMenu(nama: 'Teh Tarik Medan', harga: 'Rp 10.000', kategori: 'Minuman'),
        ],
      ),
    );
  }
}

// ===== 3. KartuMenu: Stateless (data hanya dari parameter) =====
class KartuMenu extends StatelessWidget {
  const KartuMenu({
    super.key,
    required this.nama,
    required this.harga,
    required this.kategori,
  });

  final String nama;
  final String harga;
  final String kategori;

  @override
  Widget build(BuildContext context) {
    final teks = Theme.of(context).textTheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(nama, style: teks.titleMedium),
                  const SizedBox(height: 4),
                  Text(harga, style: teks.bodyMedium),
                  const SizedBox(height: 8),
                  Chip(label: Text(kategori)), // kategori sebagai Chip
                ],
              ),
            ),
            TombolFavorit(namaMenu: nama),
          ],
        ),
      ),
    );
  }
}

// ===== 4. TombolFavorit: Stateful kecil (hanya ini yang berubah) =====
class TombolFavorit extends StatefulWidget {
  const TombolFavorit({super.key, required this.namaMenu});

  final String namaMenu;

  @override
  State<TombolFavorit> createState() => _TombolFavoritState();
}

class _TombolFavoritState extends State<TombolFavorit> {
  bool _favorit = false;

  void _ubah() {
    setState(() => _favorit = !_favorit);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _favorit
              ? '${widget.namaMenu} ditambahkan ke favorit'
              : '${widget.namaMenu} dihapus dari favorit',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: _ubah,
      // warna dari tema, bukan Colors.red
      color: Theme.of(context).colorScheme.primary,
      icon: Icon(_favorit ? Icons.favorite : Icons.favorite_border),
    );
  }
}