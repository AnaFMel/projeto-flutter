import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/book.dart';

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