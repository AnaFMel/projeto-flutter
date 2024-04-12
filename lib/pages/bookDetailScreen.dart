import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:livraria_flutter/pages/ReadingList.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../repositories/sqlite.dart';
import '../models/book.dart';

class BookDetailScreen extends StatelessWidget {
  final Book book;
  final sqliteService = SqliteService();

  BookDetailScreen({required this.book});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(book.title!,
            style: GoogleFonts.vt323(
              textStyle: TextStyle(letterSpacing: .15, fontSize: 40),
            )),
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Colors.brown,
          image: DecorationImage(
              image: AssetImage("assets/images/paw-print.png"),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.68), BlendMode.darken)),
        ),
        child: SingleChildScrollView(
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
                      placeholder: (context, url) =>
                          CircularProgressIndicator(),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    ),
                  ),
                  alignment: Alignment.topCenter,
                ),
                SizedBox(height: 16),
                Text('Autor(a): ${book.author}',
                    style: GoogleFonts.vt323(
                      textStyle: TextStyle(letterSpacing: .15, fontSize: 24),
                    )),
                SizedBox(height: 16),
                Text(
                  'Descrição: ${book.description}',
                  style: GoogleFonts.vt323(
                    textStyle: TextStyle(
                        letterSpacing: .15,
                        wordSpacing: -8,
                        fontSize: 24,
                        fontWeight: FontWeight.w100),
                  ),
                  textAlign: TextAlign.justify,
                ),
                SizedBox(height: 16),
                Text(
                    'Data de Publicação: ${book.publishedDate
                    }',
                    style: GoogleFonts.vt323(
                      textStyle: TextStyle(letterSpacing: .15, fontSize: 24),
                    )),
                SizedBox(height: 16),
                Text('Número de Páginas: ${book.pageCount}',
                    style: GoogleFonts.vt323(
                      textStyle: TextStyle(letterSpacing: .15, fontSize: 24),
                    )),
                SizedBox(height: 16),
                Text('Editora: ${book.publisher}',
                    style: GoogleFonts.vt323(
                      textStyle: TextStyle(letterSpacing: .15, fontSize: 24),
                    )),
                SizedBox(height: 16),
                Text('Categoria(s): ${book.categories!.join(', ')}',
                    style: GoogleFonts.vt323(
                      textStyle: TextStyle(letterSpacing: .15, fontSize: 24),
                    )),
                SizedBox(height: 32),
                Stack(
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: Image(
                          image: AssetImage("assets/images/cruelo-plain.png")),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 65),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            iconSize: 56,
                            icon: Icon(Icons.bookmark_add_outlined,
                                color: Colors.black),
                            onPressed: () async{
                               int id = await sqliteService.insertBook(
                                  book.title ?? '',
                                  book.author ?? '',
                                  book.description ?? '',
                                );

                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text('Livro adicionado à lista de leitura!'),
                                        ),
                                  );

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ReadingList()),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
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
