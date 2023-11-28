class Book {
  final String title;
  final String author;
  final String description;
  final String imageUrl;
  final String publishedDate;
  final int pageCount;
  final String publisher;
  final List<String> categories;
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