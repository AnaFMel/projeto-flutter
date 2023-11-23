import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Livraria Flutter',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BookListScreen(),
    );
  }
}

class BookListScreen extends StatefulWidget {
  @override
  _BookListScreenState createState() => _BookListScreenState();
}

class _BookListScreenState extends State<BookListScreen> {
  final String apiKey = 'AIzaSyDDKT2Yn7UkAk5rSIam95ZRxix6BI2aFOU';
  final String googleBooksApiUrl = 'https://www.googleapis.com/books/v1/volumes';
  final String query = 'inauthor:Stephen King';

  Future<List<Book>> fetchBooks() async {
    final response = await http.get(Uri.parse('$googleBooksApiUrl?q=$query&key=$apiKey'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> items = data['items'];

      List<Book> books = items.map((item) {
        final volumeInfo = item['volumeInfo'];

        // Verifica se 'imageLinks' e 'thumbnail' estão presentes e não são nulos
        final imageLinks = volumeInfo['imageLinks'];
        final thumbnail = imageLinks != null ? imageLinks['thumbnail'] : null;

        return Book(
          title: volumeInfo['title'],
          author: volumeInfo['authors'] != null ? volumeInfo['authors'][0] : 'Autor Desconhecido',
          description: volumeInfo['description'] ?? 'Sem descrição',
          imageUrl: thumbnail ?? '',
        );
      }).toList();

      return books;
    } else {
      throw Exception('Falha ao carregar dados da API');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Livros de Stephen King'),
      ),
      body: FutureBuilder(
        future: fetchBooks(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erro: ${snapshot.error}'));
          } else {
            List<Book> books = snapshot.data as List<Book>;

            return ListView.builder(
              itemCount: books.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(books[index].title),
                  subtitle: Text(books[index].author),
                  leading: CachedNetworkImage(
                    imageUrl: books[index].imageUrl,
                    placeholder: (context, url) => CircularProgressIndicator(),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BookDetailScreen(book: books[index]),
                      ),
                    );
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}

class BookDetailScreen extends StatelessWidget {
  final Book book;

  BookDetailScreen({required this.book});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(book.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Autor: ${book.author}'),
            SizedBox(height: 8),
            Text('Descrição: ${book.description}'),
            // Adicione mais detalhes conforme necessário
          ],
        ),
      ),
    );
  }
}

class Book {
  final String title;
  final String author;
  final String description;
  final String imageUrl;

  Book({required this.title, required this.author, required this.description, required this.imageUrl});
}
