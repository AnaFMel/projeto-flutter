import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class SqliteService {
  Future<Database> initializeDB() async {
    String path = await getDatabasesPath();
  
    return openDatabase(
      join(path, 'database.db'),
      onCreate: (database, version) async {
        await database.execute(
          "CREATE TABLE Books("
          "id INTEGER PRIMARY KEY AUTOINCREMENT, "
          "title TEXT, "
          "author TEXT, "
          "description TEXT)"
        );
      },
      version: 1,
    );
  }

  Future<int> insertBook(String title, String author, String description) async {
    final Database db = await initializeDB();
    
    return await db.insert(
      'Books',
      {
        'title': title,
        'author': author,
        'description': description,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, dynamic>>> getAllBooks() async {
        // Obter a instância do banco de dados
        final Database db = await initializeDB();
        
        // Consulte todos os registros da tabela Books
        final List<Map<String, dynamic>> books = await db.query('Books');
        
        // Retorne a lista de mapas
        return books;
    }

    Future<int> deleteBookByTitle(String title) async {
    // Obter a instância do banco de dados
    final Database db = await initializeDB();

    // Excluir o livro com o título especificado
    int result = await db.delete(
      'Books',
      where: 'title = ?',
      whereArgs: [title],
    );

    // Retorna o número de linhas afetadas pela operação de exclusão
    return result;
  }
}

