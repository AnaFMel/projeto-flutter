import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';

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
      debugShowCheckedModeBanner: false,
    );
  }
}

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
          author: volumeInfo['authors'] != null ? volumeInfo['authors'][0] : '(Autor Desconhecido)',
          description: volumeInfo['description'] ?? '(Descrição não encontrada)',
          imageUrl: thumbnail ?? '',
          publishedDate: volumeInfo['publishedDate'] ?? '(Data Desconhecida)',
          pageCount: volumeInfo['pageCount'] ?? 0,
          publisher: volumeInfo['publisher'] ?? '(Editora Desconhecida)',
          categories: volumeInfo['categories'] != null ? List<String>.from(volumeInfo['categories']) : [],
          buyLink: buyLink ?? '',
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
        title: Text('Livraria Flutter'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Buscar Livros',
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
                ? Center(child: Text('Nenhum livro encontrado'))
                : ListView.builder(
              itemCount: _books.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_books[index].title),
                  subtitle: Text(_books[index].author),
                  leading: CachedNetworkImage(
                    imageUrl: _books[index].imageUrl,
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
                );
              },
            ),
          ),
        ],
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                child: CachedNetworkImage(
                  imageUrl: book.imageUrl,
                  placeholder: (context, url) =>
                      CircularProgressIndicator(),
                  errorWidget: (context, url, error) =>
                      Icon(Icons.error),
                ),
                alignment: Alignment.topCenter,
              ),
              SizedBox(height: 8),
              Text('Autor: ${book.author}',),
              SizedBox(height: 8),
              Text('Descrição: ${book.description}'),
              SizedBox(height: 8),
              Text('Data de Publicação: ${book.publishedDate}'),
              SizedBox(height: 8),
              Text('Número de Páginas: ${book.pageCount}'),
              SizedBox(height: 8),
              Text('Editora: ${book.publisher}'),
              SizedBox(height: 8),
              Text('Categorias: ${book.categories.join(', ')}'),
              SizedBox(height: 16),
              SizedBox(height: 16),
              Container(
                child: ElevatedButton(
                  onPressed: () {
                    _launchURL(book.buyLink);
                  },
                  child: Text('Comprar Agora'),
                ),
                alignment: Alignment.bottomCenter,
              ),
              // Adicione mais detalhes conforme necessário
            ],
          ),
        ),
      ),
    );
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Não foi possível abrir o link: $url';
    }
  }
}


class Book {
  final String title;
  final String author;
  final String description;
  final String imageUrl;
  final String publishedDate; // Adicionando a data de publicação
  final int pageCount; // Adicionando o número de páginas
  final String publisher; // Adicionando a editora
  final List<String> categories; // Adicionando categorias do livro
  final String buyLink;

  Book({
    required this.title,
    required this.author,
    required this.description,
    required this.imageUrl,
    required this.publishedDate,
    required this.pageCount,
    required this.publisher,
    required this.categories,
    required this.buyLink,
  });
}
