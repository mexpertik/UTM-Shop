import 'dart:convert';
import 'package:http/http.dart' as http;

// Clasa pentru a modela o recenzie
class Review {
  final int id;
  final String createdAt; // Data creării recenziei
  final Author author; // Autorul recenziei
  final int rate; // Ratingul recenziei
  final String text; // Textul recenziei
  final int productId; // ID-ul produsului asociat recenziei

  Review({
    required this.id,
    required this.createdAt,
    required this.author,
    required this.rate,
    required this.text,
    required this.productId,
  });

  // Factory constructor pentru a crea un obiect Review din JSON
  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id: json['id'],
      createdAt: json['created_at'] ?? 'Unknown date',
      author: Author.fromJson(json['author']),
      rate: json['rate'],
      text: json['text'],
      productId: json['product_id'],
    );
  }
}

// Clasa pentru a modela autorul unei recenzii
class Author {
  final int id;
  final String name; // Numele autorului
  final String avatar; // URL-ul avatarului autorului

  Author({
    required this.id,
    required this.name,
    required this.avatar,
  });

  // Factory constructor pentru a crea un obiect Author din JSON
  factory Author.fromJson(Map<String, dynamic> json) {
    return Author(
      id: json['id'],
      name: json['name'],
      avatar: json['avatar'],
    );
  }
}

// Funcție asincronă pentru a prelua recenziile unui produs
Future<List<Review>> fetchReviews(int productId) async {
  final response = await http.get(Uri.parse('https://api-ebs-mobile.devebs.net/reviews/$productId'));

  if (response.statusCode == 200) {
    List<dynamic> jsonResponse = json.decode(response.body);
    // Convertirea JSON-ului într-o listă de obiecte Review
    return jsonResponse.map((review) => Review.fromJson(review)).toList();
  } else {
    // Aruncarea unei excepții în cazul unui răspuns negativ de la server
    throw Exception('Failed to load reviews');
  }
}
