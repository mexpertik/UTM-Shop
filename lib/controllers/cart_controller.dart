// cart.dart
class Cart {
  // Implementarea pattern-ului Singleton
  Cart._privateConstructor();
  static final Cart _instance = Cart._privateConstructor();
  // Factory constructor pentru a asigura o singură instanță a clasei Cart
  factory Cart() {
    return _instance;
  }

  // Mapă pentru stocarea ID-urilor produselor și a cantității lor în coș
  final Map<int, int> _items = {};

  // Metodă pentru adăugarea unui produs în coș
  void addToCart(int productId) {
    if (_items.containsKey(productId)) {
      // Dacă produsul există deja în coș, incrementăm cantitatea
      _items[productId] = _items[productId]! + 1;
    } else {
      // Altfel, adăugăm produsul cu cantitatea 1
      _items[productId] = 1;
    }
  }

  // Metodă pentru incrementarea cantității unui produs
  void incrementQuantity(int productId) {
    if (_items.containsKey(productId)) {
      // Incrementăm cantitatea produsului specific
      _items[productId] = _items[productId]! + 1;
    }
  }

  // Metodă pentru decrementarea cantității unui produs
  void decrementQuantity(int productId) {
    if (_items.containsKey(productId) && _items[productId]! > 1) {
      // Dacă cantitatea este mai mare decât 1, o decrementăm
      _items[productId] = _items[productId]! - 1;
    } else {
      // Altfel, eliminăm produsul din coș
      removeFromCart(productId);
    }
  }

  // Metodă pentru eliminarea unui produs din coș
  void removeFromCart(int productId) {
    _items.remove(productId);
  }

  // Metodă pentru obținerea mapei de produse
  Map<int, int> get items => Map.unmodifiable(_items);

  // Obținerea numărului total de produse unice din coș
  int get itemCount => _items.length;

  // Obținerea numărului total de toate produsele din coș
  int get totalItemsCount => _items.values.fold(0, (sum, quantity) => sum + quantity);
}
