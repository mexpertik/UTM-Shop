import 'dart:convert';
import 'package:http/http.dart' as http;

// Funcție asincronă pentru preluarea detaliilor unui produs de la un API
Future<ProductDetails> fetchProductDetails(int id) async {
  final response = await http.get(Uri.parse('https://api-ebs-mobile.devebs.net/product/$id'));

  if (response.statusCode == 200) {
    // Dacă răspunsul este pozitiv, decodifică JSON-ul și returnează detaliile produsului
    return ProductDetails.fromJson(json.decode(response.body));
  } else {
    // Dacă răspunsul nu este pozitiv, aruncă o excepție
    throw Exception('Failed to load product details');
  }
}

// Clasa pentru a modela detaliile unui produs
class ProductDetails {
  final int id;
  final String title;
  final double price;
  final String description;
  final Category category;
  final String mainImage;
  final List<Attribute> attributes;
  final List<String> images;
  final int totalReviews;
  final double reviewAverage;

  ProductDetails({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.category,
    required this.mainImage,
    required this.attributes,
    required this.images,
    required this.totalReviews,
    required this.reviewAverage,
  });

  // Constructor pentru a crea un obiect ProductDetails din JSON
  factory ProductDetails.fromJson(Map<String, dynamic> json) {
    return ProductDetails(
      id: json['id'],
      title: json['title'],
      price: (json['price'] is int) ? (json['price'] as int).toDouble() : json['price'],
      description: json['description'],
      category: Category.fromJson(json['category']),
      mainImage: json['main_image'],
      attributes: (json['attributes'] as List).map((e) => Attribute.fromJson(e)).toList(),
      images: List<String>.from(json['images']),
      totalReviews: json['total_reviews'],
      reviewAverage: json['review_average'],
    );
  }
}

// Clasa pentru a modela categoria unui produs
class Category {
  final int id;
  final String title;
  final String image;

  Category({required this.id, required this.title, required this.image});

  // Constructor pentru a crea un obiect Category din JSON
  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      title: json['title'],
      image: json['image'],
    );
  }
}

// Clasa pentru a modela atributele unui produs
class Attribute {
  final int id;
  final String title;
  final List<String> values;

  Attribute({required this.id, required this.title, required this.values});

  // Constructor pentru a crea un obiect Attribute din JSON
  factory Attribute.fromJson(Map<String, dynamic> json) {
    return Attribute(
        id: json['id'],
      title: json['title'],
      values: List<String>.from(json['values']), // Convertirea listei de valori din JSON într-o listă de stringuri
    );
  }
}
