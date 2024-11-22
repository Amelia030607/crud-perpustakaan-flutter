import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class BookListPage extends StatefulWidget {
  const BookListPage({super.key});

  @override
  _BookListPageState createState() => _BookListPageState();
}


class _BookListPageState extends State<BookListPage> {
  //Buat variabel untuk menyimpan data buku
  List<Map<String, dynamic>> Books = [];

@override
  void initState() {
    super.initState();
    fetchBooks(); // panggil fungsi untuk data buku
  }

  // Fungsi untuk mengambil buku mengambil data buku dari Supabase
  Future<void> fetchBooks() async {
    final response = await Supabase.instance.client
    .from('books')
    .select();

    setState(() {
      Books = List<Map<String, dynamic>>.from(response);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Buku'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: fetchBooks, // Tombol untuk refresh
          ),
        ],
      ),
      body: Books.isEmpty
      ? const Center(child: CircularProgressIndicator()) // Circular progress indicator digunakan untuk menampilkan "loading" indicator
       : ListView.builder( // ListView membuat list secara urut
         itemCount: Books.length,
         itemBuilder: (context, index) {
          final book = Books[index];
          return ListTile(
            title: Text(book['judul'] ?? 'No Title', style: const TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            )),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(book['penulis'] ?? 'No Author', style: TextStyle(
                  fontStyle: FontStyle.italic,
                  fontSize: 14.0,
                ),),
                Text(book['deskripsi'] ?? 'No Description', style: TextStyle(
                  fontSize: 12.0,
                ),),
              ],
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.blue),
                  onPressed: () {
                    // Arahkan ke editor Bookpage dengan mengirim 
                    // Navigator.push(
                    // //  context,
                    // //  MaterialPageRoute(
                    // //    builder: (context) => EditBookPage( book : book),
                    // //  );
                    // ).then((_) {
                    //   fetchBooks(); // refresh data setelah kembali dari 
                    // });
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    // Konfirmasi sebelum menghapus Buku
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Delete Book'),
                          content: const Text('Are you sure you want to delete this book?'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () async{
                                // await deletedBook(book['id']);
                                Navigator.of(context).pop();
                              },
                              child: const Text('Delete'),
                            )
                          ],
                        );
                      },
                    );
                  },
                )
              ],
            ),
          );
         },
       ),
    );
  }
 }