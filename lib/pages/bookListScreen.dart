import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:livraria_flutter/pages/ReadingList.dart';
import '../models/book.dart';
import 'bookDetailScreen.dart';
import 'package:google_fonts/google_fonts.dart';

class BookListScreen extends StatefulWidget {
  @override
  _BookListScreenState createState() => _BookListScreenState();
}

class _BookListScreenState extends State<BookListScreen> {
  final String apiKey = 'AIzaSyDDKT2Yn7UkAk5rSIam95ZRxix6BI2aFOU';
  final String googleBooksApiUrl =
      'https://www.googleapis.com/books/v1/volumes';

  final TextEditingController _searchController = TextEditingController();
  List<Book> _books = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _searchBooks();
  }

  Future<void> _searchBooks() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final List<Book> books = await fetchBooks(_searchController.text);
      setState(() {
        _books = books;
      });
    } catch (e) {
      // Handle error
      print('Error: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<List<Book>> fetchBooks(String query) async {
    final response =
        await http.get(Uri.parse('$googleBooksApiUrl?q=$query&key=$apiKey'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> items = data['items'];

      List<Book> books = items.map((item) {
        final volumeInfo = item['volumeInfo'];

        final imageLinks = volumeInfo['imageLinks'];
        final thumbnail = imageLinks != null ? imageLinks['thumbnail'] : null;

        final saleInfo = item['saleInfo'];
        final buyLink = saleInfo != null ? saleInfo['buyLink'] : null;

        return Book(
          title: volumeInfo['title'],
          author: volumeInfo['authors'] != null
              ? volumeInfo['authors'][0]
              : '(Autor Desconhecido)',
          description:
              volumeInfo['description'] ?? '(Descrição não encontrada)',
          imageUrl: thumbnail ?? '',
          publishedDate: volumeInfo['publishedDate'] ?? '(Data Desconhecida)',
          pageCount: volumeInfo['pageCount'] ?? 0,
          publisher: volumeInfo['publisher'] ?? '(Editora Desconhecida)',
          categories: volumeInfo['categories'] != null
              ? List<String>.from(volumeInfo['categories'])
              : [],
          buyLink: buyLink ?? '',
        );
      }).toList();

      return books;
    } else {
      throw Exception('Nenhum livro encontrado');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('CRUELO',
                style: GoogleFonts.vt323(
                  textStyle: TextStyle(
                      letterSpacing: .5, fontSize: 50, wordSpacing: -9),
                )),
            Padding(
              padding: const EdgeInsets.only(right: 20, left: 20),
              child: Image(
                image: AssetImage("assets/images/logo.png"),
                width: 40,
                height: 40,
              ),
            ),
            Text('LIVROS',
                style: GoogleFonts.vt323(
                  textStyle: TextStyle(
                      letterSpacing: .5, fontSize: 50, wordSpacing: -9),
                )),
          ],
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/images/empty-home.png"),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.65), BlendMode.darken)),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _searchController,
                style: GoogleFonts.vt323(
                    textStyle: TextStyle(
                        letterSpacing: .15,
                        fontSize: 40,
                        fontWeight: FontWeight.w500)),
                decoration: InputDecoration(
                  labelText: 'Buscar Livros',
                  labelStyle: GoogleFonts.vt323(
                      textStyle: TextStyle(
                          letterSpacing: .15,
                          fontSize: 30,
                          fontWeight: FontWeight.w500)),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.search),
                    onPressed: _searchBooks,
                  ),
                ),
              ),
            ),
            Expanded(
              child: _isLoading
                  ? Center(child: CircularProgressIndicator())
                  : _books.isEmpty
                      ? Center(
                          child: Text("Não encontramos nenhum livro...",
                              style: GoogleFonts.vt323(
                                textStyle:
                                    TextStyle(letterSpacing: .5, fontSize: 25),
                              )))
                      : ListView.builder(
                          itemCount: _books.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.all(3.0),
                              child: ListTile(
                                title: Text(
                                  _books[index].title!,
                                  style: GoogleFonts.vt323(
                                      textStyle: TextStyle(
                                          letterSpacing: .15,
                                          fontSize: 22,
                                          fontWeight: FontWeight.w500)),
                                ),
                                subtitle: Text(
                                  _books[index].author!,
                                  style: GoogleFonts.vt323(
                                      textStyle: TextStyle(
                                          letterSpacing: .15,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500)),
                                ),
                                leading: CachedNetworkImage(
                                  imageUrl: _books[index].imageUrl!,
                                  fit: BoxFit.fill,
                                  placeholder: (context, url) =>
                                      CircularProgressIndicator(),
                                  errorWidget: (context, url, error) =>
                                      Icon(Icons.error),
                                ),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          BookDetailScreen(book: _books[index]),
                                    ),
                                  );
                                },
                              ),
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ReadingList()),
            );
          },
          child: Icon(Icons.collections_bookmark),
          backgroundColor: Colors.black,
          foregroundColor: Colors.white),
    );
  }
}
