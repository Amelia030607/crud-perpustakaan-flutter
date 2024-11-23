import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'insert.dart'; 

class BookListPage extends StatefulWidget {
  const BookListPage({super.key}); // Konstruktor untuk widget BookListPage

  @override
  _BookListPageState createState() => _BookListPageState(); // Membuat state untuk BookListPage
}

class _BookListPageState extends State<BookListPage> {
  // Variabel untuk menyimpan daftar buku
  List<Map<String, dynamic>> books = []; // books adalah nama tabel pada database

  @override
  void initState() {
    super.initState();
    fetchBooks(); // Memanggil fungsi fetchBooks() untuk mengambil data buku dari Supabase saat aplikasi pertama kali dibuka
  }

  // Fungsi untuk mengambil data buku dari Supabase
  Future<void> fetchBooks() async {
    final response = await Supabase.instance.client.from('books').select(); // Mengambil data dari tabel 'books'

    setState(() {
      books = List<Map<String, dynamic>>.from(response); // Menyimpan hasil response ke dalam variabel 'books'
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Daftar Buku')), // Judul pada bagian AppBar
        backgroundColor: Color.fromARGB(255, 236, 165, 230), // Warna background AppBar
        actions: [
          // Tombol untuk refresh data buku
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: fetchBooks, // Memanggil fungsi fetchBooks untuk mengambil data terbaru
          ),
        ],
      ),
      body: books.isEmpty
          ? const Center(
              child: CircularProgressIndicator(), // Menampilkan indikator loading saat data masih kosong atau sedang dimuat
            )
          : ListView.builder(
              itemCount: books.length, // Menghitung jumlah item pada daftar buku
              itemBuilder: (context, index) {
                final book = books[index]; // Mengambil data buku berdasarkan index
                return ListTile(
                  title: Text(
                    book['title'] ?? 'No Title', // Menampilkan judul buku, atau 'No Title' jika data tidak ada
                    style: TextStyle(
                      fontWeight: FontWeight.bold, // Menebalkan teks judul buku
                      fontSize: 18, // Ukuran font judul
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start, // Menyusun teks di sebelah kiri
                    children: [
                      Text(
                        book['author'] ?? 'No Author', // Menampilkan nama penulis atau 'No Author' jika tidak ada data
                        style: TextStyle(
                          fontStyle: FontStyle.italic, // Menampilkan nama penulis dengan gaya miring
                          fontSize: 14, // Ukuran font penulis
                        ),
                      ),
                      Text(
                        book['description'] ?? 'No Description', // Menampilkan deskripsi buku atau 'No Description' jika tidak ada data
                        style: TextStyle(
                          fontSize: 12, // Ukuran font deskripsi
                        ),
                      ),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min, // Menyusun tombol di sisi kanan ListTile
                    children: [
                      // Tombol Edit
                      IconButton(
                        icon: Icon(Icons.edit, color: Colors.blue), // Ikon untuk tombol edit
                        onPressed: () {
                          // Arahkan ke halaman EditBookPage untuk mengirim data buku yang akan diedit
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder: (context) => EditBookPage(book: book),
                          //   ),
                          // ).then((_) {
                          //   fetchBooks(); // Refresh data setelah kembali dari halaman edit
                          // });
                        },
                      ),
                      // Tombol Delete
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.red), // Ikon untuk tombol delete
                        onPressed: () {
                          // Konfirmasi sebelum menghapus buku (ALERT)
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('Delete Book'), // Judul dialog konfirmasi
                                content: Text('Are you sure you want to delete this book?'), // Isi pesan dialog
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop(); // Menutup dialog jika tombol Cancel ditekan
                                    },
                                    child: Text('Cancel'), // Tombol Cancel
                                  ),
                                  TextButton(
                                    onPressed: () async {
                                      // Tunggu hingga proses delete selesai (fungsi deleteBook bisa dipanggil di sini)
                                      // await deleteBook(book['id']);
                                      Navigator.of(context).pop(); // Menutup dialog setelah proses delete selesai
                                    },
                                    child: Text('Delete'), // Tombol Delete
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton( // FloatingActionButton digunakan untuk menambah buku baru
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddBookPage()), // Navigasi ke halaman AddBookPage untuk menambah buku
          ).then((_) {
            fetchBooks(); // Refresh data setelah kembali dari halaman AddBookPage
          });
        },
        child: const Icon(Icons.add), // Ikon untuk tombol tambah buku
        tooltip: 'Add Book', // Tooltip untuk tombol tambah buku
      ),
    );
  }
}
