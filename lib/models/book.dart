class Book {
    final String? title;
    final String? author;
    final String? description;
    final String? imageUrl; // Certifique-se de incluir os campos apropriados
    final String? publishedDate;
    final int? pageCount;
    final String? publisher;
    final List<String>? categories;
    final String? buyLink;

    Book({
        this.title,
        this.author,
        this.description,
        this.imageUrl,
        this.publishedDate,
        this.pageCount,
        this.publisher,
        this.categories,
        this.buyLink,
    });

    // Método para converter um mapa em um objeto Book
    factory Book.fromMap(Map<String, dynamic> map) {
        return Book(
            title: map['title'],
            author: map['author'],
            description: map['description'],
            imageUrl: map['imageUrl'],
            publishedDate: map['publishedDate'],
            pageCount: map['pageCount'],
            publisher: map['publisher'],
            categories: map['categories']?.split(','), // Exemplo para converter a string em uma lista
        );
    }

    // Outras definições e métodos da classe Book, se necessário
}
