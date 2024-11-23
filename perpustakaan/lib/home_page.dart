import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'insert.dart';

class BookListPage extends StatefulWidget {
  const BookListPage({super.key});

  @override
  _BookListPageState createState() => _BookListPageState();
}

class _BookListPageState extends State<BookListPage> {
  // Variabel untuk menyimpan daftar buku
  List<Map<String, dynamic>> books = []; // books adalah nama tabel pada database

  @override
  void initState() {
    super.initState();
    fetchBooks(); // Fungsi untuk mengambil data pada tabel buku
  }

  // Fungsi untuk mengambil data buku dari Supabase
  Future<void> fetchBooks() async {
    final response = await Supabase.instance.client.from('books').select();
    setState(() {
      books = List<Map<String, dynamic>>.from(response);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Daftar Buku')),
        backgroundColor: Color.fromARGB(255, 236, 165, 230), // Warna background AppBar
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: fetchBooks, // Tombol untuk refresh data buku
          ),
        ],
      ),
      body: books.isEmpty
          ? const Center(
              child: CircularProgressIndicator(), // Indikator loading saat data kosong
            )
          : ListView.builder(
              itemCount: books.length,
              itemBuilder: (context, index) {
                final book = books[index];
                return ListTile(
                  title: Text(
                    book['title'] ?? 'No Title',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        book['author'] ?? 'No Author',
                        style: TextStyle(
                          fontStyle: FontStyle.italic,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        book['description'] ?? 'No Description',
                        style: TextStyle(
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Tombol Edit
                      IconButton(
                        icon: Icon(Icons.edit, color: Colors.blue),
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
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          // Konfirmasi sebelum menghapus buku (ALERT)
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('Delete Book'),
                                content: Text('Are you sure you want to delete this book?'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () async {
                                      // Tunggu hingga proses delete selesai
                                      // await deleteBook(book['id']);
                                      Navigator.of(context).pop();
                                    },
                                    child: Text('Delete'),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddBookPage()),
          ).then((_) {
            fetchBooks(); // Refresh data setelah kembali dari halaman AddBookPage
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
