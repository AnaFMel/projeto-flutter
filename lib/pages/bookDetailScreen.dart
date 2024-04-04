import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:livraria_flutter/pages/ReadingList.dart';
import 'package:livraria_flutter/repositories/reading_list_repository.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';

import '../models/book.dart';

class BookDetailScreen extends StatelessWidget {
  final Book book;
  ReadingListRepository _readingListRepository = ReadingListRepository();

  BookDetailScreen({required this.book});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(book.title!),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                child: SizedBox(
                  height: 250,
                  child: CachedNetworkImage(
                    imageUrl: book.imageUrl!,
                    placeholder: (context, url) => CircularProgressIndicator(),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                ),
                alignment: Alignment.topCenter,
              ),
              SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.indigo, width: 5.5),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      iconSize: 56,
                      icon: Icon(Icons.bookmark_add_outlined,
                          color: Colors.indigo),
                      onPressed: () {
                        _readingListRepository.AdicionarLivroNaLista(book);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ReadingList()),
                        );
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Text(
                'Autor(a): ${book.author}',
              ),
              SizedBox(height: 8),
              Text('Descrição: ${book.description}'),
              SizedBox(height: 8),
              Text(
                  'Data de Publicação: ${
                      book.publishedDate
                      //DateFormat("dd/MM/yyyy").format(DateTime.parse(book.publishedDate))
                  }'),
              SizedBox(height: 8),
              Text('Número de Páginas: ${book.pageCount}'),
              SizedBox(height: 8),
              Text('Editora: ${book.publisher}'),
              SizedBox(height: 8),
              Text('Categoria(s): ${book.categories!.join(', ')}'),
              SizedBox(height: 16),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 75,
                    width: 150,
                    child: ElevatedButton(
                      onPressed: () {
                        _launchURL(book.buyLink!);
                      },
                      child: Text(
                        'COMPRAR',
                        style: TextStyle(fontSize: 20),
                      ),
                      style: ButtonStyle(
                        alignment: Alignment.center,
                      ),
                    ),
                  ),
                ],
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
