import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/book.dart';
import '../repositories/reading_list_repository.dart';
import 'bookDetailScreen.dart';

class ReadingList extends StatefulWidget {
  const ReadingList({super.key});

  @override
  State<ReadingList> createState() => _ReadingListState();
}

class _ReadingListState extends State<ReadingList> {
  TextEditingController LivroController = TextEditingController();

  ReadingListRepository _readingListRepository = ReadingListRepository();
  List<Book> livros = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _readingListRepository.ObterLista().then((dados) {
      setState(() {
        livros = dados;
      });
    });
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
            Expanded(
              child: _isLoading
                  ? Center(child: CircularProgressIndicator())
                  : livros.isEmpty
                      ? Center(
                          child: Text("Não encontramos nenhum livro...",
                              style: GoogleFonts.vt323(
                                textStyle:
                                    TextStyle(letterSpacing: .5, fontSize: 25),
                              )))
                      : ListView.builder(
                          itemCount: livros!.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              title: Text(livros![index].title!),
                              subtitle: Text(livros![index].author!),
                              leading: CachedNetworkImage(
                                imageUrl: livros![index].imageUrl!,
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
                                        BookDetailScreen(book: livros![index]),
                                  ),
                                );
                              },
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }
}
