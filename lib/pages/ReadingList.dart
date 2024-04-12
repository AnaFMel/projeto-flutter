import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/book.dart';
import 'bookDetailScreen.dart';
import '../repositories/sqlite.dart';

class ReadingList extends StatefulWidget {
  const ReadingList({super.key});

  @override
  State<ReadingList> createState() => _ReadingListState();
}

class _ReadingListState extends State<ReadingList> {
  final SqliteService _sqliteService = SqliteService();

  List<Book> livros = [];
  bool _isLoading = true;

  Future<void> _loadBooks() async {
    setState(() {
      _isLoading = true;
    });

    List<Map<String, dynamic>> bookMaps = await _sqliteService.getAllBooks();

    List<Book> books = bookMaps.map((bookMap) => Book.fromMap(bookMap)).toList();

    setState(() {
      livros = books;
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadBooks();
  }

  Future<void> _deleteBook(String title) async {
    // Chama a função do SqliteService para excluir o livro pelo título
    await _sqliteService.deleteBookByTitle(title);

    // Atualiza a lista de livros após a exclusão
    await _loadBooks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        centerTitle: true,
        title: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: Icon(Icons.collections_bookmark_sharp),
            ),
            Text("Lista de Leitura",
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.vt323(
                  textStyle: TextStyle(
                      letterSpacing: .5, fontSize: 40, wordSpacing: -9),
                )),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: _isLoading
                ? Center(child: CircularProgressIndicator())
                : livros.isEmpty
                    ? Center(child: Text('Nenhum livro encontrado'))
                    : ListView.builder(
                        itemCount: livros.length,
                        itemBuilder: (context, index) {
                          Book book = livros[index];
                          return ListTile(
                            title: Text(book.title ?? ''),
                            subtitle: Text(book.author ?? ''),
                            leading: book.imageUrl != null && book.imageUrl!.isNotEmpty
                                ? CachedNetworkImage(
                                    imageUrl: book.imageUrl!,
                                    placeholder: (context, url) => CircularProgressIndicator(),
                                    errorWidget: (context, url, error) => Icon(Icons.error),
                                  )
                                : null,
                            trailing: IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () async {
                                // Chama a função de exclusão do livro
                                await _deleteBook(book.title ?? '');
                              },
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => BookDetailScreen(book: book),
                                ),
                              );
                            },
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}
