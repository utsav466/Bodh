class Book {
  final String? id;
  final String title;
  final String subtitle;
  final String image;
  final String? author;
  final String? category;
  final double? price;

  Book({
    this.id,
    required this.title,
    required this.subtitle,
    required this.image,
    this.author,
    this.category,
    this.price,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: json['_id']?.toString(),
      title: (json['title'] ?? '').toString(),
      subtitle: (json['author'] ?? json['description'] ?? '').toString(),
      image: (json['coverUrl'] ?? '').toString(),
      author: json['author']?.toString(),
      category: json['category']?.toString(),
      price: json['price'] is num
          ? (json['price'] as num).toDouble()
          : double.tryParse(json['price']?.toString() ?? ''),
    );
  }

  bool get hasNetworkImage =>
      image.startsWith('http://') ||
      image.startsWith('https://') ||
      image.startsWith('/');
}