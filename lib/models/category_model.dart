import 'package:http/http.dart' as http;
import 'dart:convert';

// Funcție asincronă pentru a prelua categoriile de pe un server
Future<List<Category>> fetchCategories() async {
  // Efectuarea unei cereri GET la un URL specific
  final response = await http.get(Uri.parse('https://api-ebs-mobile.devebs.net/categories'));

  // Verificarea dacă răspunsul este pozitiv (cod de stare HTTP 200)
  if (response.statusCode == 200) {
    // Decodificarea răspunsului JSON într-o listă
    List jsonResponse = json.decode(response.body);
    // Transformarea fiecărui element din listă într-un obiect de tip Category
    return jsonResponse.map((data) => Category.fromJson(data)).toList();
  } else {
    // Aruncarea unei excepții în cazul unui răspuns negativ
    throw Exception('Unexpected error occured!');
  }
}

// Clasa Category pentru a modela datele unei categorii
class Category {
  final int id;
  final String title;
  final String image;

  // Constructor pentru inițializarea unui obiect de tip Category
  Category({
    required this.id,
    required this.title,
    required this.image,
  });

  // Factory constructor pentru a crea un obiect Category dintr-un map JSON
  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      title: json['title'],
      image: json['image'],
    );
  }
}
