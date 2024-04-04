import 'package:flutter/material.dart';
import 'package:livraria_flutter/repositories/sqlite.dart';

import '../models/book.dart';

class ReadingListRepository {
  ReadingListRepository();

 /* Future<void> RegistrarLista(List<Book> livros) async {
    var db = await SQLite().GetDatabase();
    await db.rawQuery('DELETE from tarefas');
    for (Book livro in livros){
      await db.rawInsert('INSERT INTO lista_leitura (titulo_livro) VALUES (?,?)',[livro.title]);
    }
  }*/

  Future<List<Book>> ObterLista() async {
    List<Book> livros = [];
    var db = await SQLite().GetDatabase();
    var lista = await db.rawQuery('SELECT * FROM lista_leitura');
    for (var item in lista) {
      livros.add(Book(title:
      item["titulo_livro"].toString()
      ));
    }
    return livros;
  }

  Future<void> AdicionarLivroNaLista(Book livro) async {
    var db = await SQLite().GetDatabase();
    await db.rawInsert('INSERT INTO lista_leitura (titulo_livro) VALUES (?,?)',[livro.title]);
  }
}