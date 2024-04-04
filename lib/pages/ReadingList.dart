import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
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
            Text("Lista de Leitura"),
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
    );
  }
}
