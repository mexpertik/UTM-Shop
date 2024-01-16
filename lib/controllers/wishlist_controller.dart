import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Clasa WishlistProvider, care utilizează ChangeNotifier pentru a gestiona starea
class WishlistProvider with ChangeNotifier {
  // Set privat pentru stocarea ID-urilor produselor adăugate în lista de dorințe
  Set<int> _wishlist = {};

  // Getter pentru a obține lista de dorințe
  Set<int> get wishlist => _wishlist;

  // Metoda pentru adăugarea unui produs în lista de dorințe
  void add(int productId) {
    _wishlist.add(productId);
    notifyListeners(); // Notifică listenerii despre schimbarea stării
  }

  // Metoda pentru eliminarea unui produs din lista de dorințe
  void remove(int productId) {
    _wishlist.remove(productId);
    notifyListeners(); // Notifică listenerii despre schimbarea stării
  }

  // Metoda pentru verificarea dacă un produs se află în lista de dorințe
  bool isInWishlist(int productId) => _wishlist.contains(productId);
}
