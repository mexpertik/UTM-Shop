import 'package:flutter/material.dart';
import 'package:utm_app/controllers/cart_controller.dart';
import 'package:utm_app/views/product_details.dart';

// Clasa pentru pagina coșului de cumpărături
class CartPage extends StatefulWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  CartPageState createState() => CartPageState();
}

class CartPageState extends State<CartPage> {
  final Cart cart = Cart(); // Instanța coșului de cumpărături
  late Future<List<ProductDetails>> futureCartProducts;

  // Metoda pentru incrementarea cantității unui produs
  void _incrementQuantity(int productId) {
    setState(() {
      cart.incrementQuantity(productId);
    });
  }

  // Metoda pentru decrementarea cantității unui produs
  void _decrementQuantity(int productId) {
    setState(() {
      cart.decrementQuantity(productId);
    });
  }

  @override
  void initState() {
    super.initState();
    // Încărcarea produselor din coș
    futureCartProducts = fetchCartProducts();
  }

  // Funcția pentru preluarea detaliilor produselor din coș
  Future<List<ProductDetails>> fetchCartProducts() async {
    List<ProductDetails> products = [];
    for (var productId in cart.items.keys) {
      var productDetail = await fetchProductDetails(productId);
      products.add(productDetail);
    }
    return products;
  }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
          appBar: AppBar(
          title: const Text('Your Cart'), // Titlul paginii
      ),
      body: FutureBuilder<List<ProductDetails>>(
      future: futureCartProducts,
      builder: (context, snapshot) {
      if (snapshot.connectionState != ConnectionState.done) {
      return const Center(child: CircularProgressIndicator());
      } else if (snapshot.hasError) {
      return Center(child: Text('Error: ${snapshot.error}')); // Afișare eroare
      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
      return const Center(child: Text('Your cart is empty')); // Mesaj pentru coș gol
      }  else {
        List<ProductDetails> cartProducts = snapshot.data!;

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            columns: const <DataColumn>[
              DataColumn(label: Text('Photo')),
              DataColumn(label: Text('Product')),
              DataColumn(label: Text('Quantity')),
              DataColumn(label: Text('Price')),
            ],
            rows: cart.items.entries.map<DataRow>((entry) {
              final product = entry.key;
              final quantity = entry.value;
              final productDetail = cartProducts.firstWhere(
                    (p) => p.id == product,
                orElse: () => ProductDetails(
                  id: 0, // Default value for an integer ID
                  mainImage: 'default_image.png',
                  title: 'Unavailable Product',
                  price: 0.0, // Default value for a double price
                  description: 'No description available', // Default description
                  category: Category(id: 0, title: 'Default Category', image: 'default_image.png'),
                  attributes: [Attribute(id: 0, title: 'Default Attribute', values: ['Default'])],
                  images: ['default_image.png'], // Default list of image URLs
                  totalReviews: 0, // Default number of reviews
                  reviewAverage: 0.0, // Default review average
                ),
              );

              return DataRow(
                cells: <DataCell>[
                  DataCell(Image.network(productDetail.mainImage, width: 50, height: 50)),
                  DataCell(Text(productDetail.title)),
                  DataCell(Row(
                    children: <Widget>[
                      IconButton(
                        icon: const Icon(Icons.remove),
                        onPressed: () => _decrementQuantity(product),
                      ),
                      Text('$quantity'),
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () => _incrementQuantity(product),
                      ),
                    ],
                  )),
                  DataCell(Text('\$${(productDetail.price * quantity).toStringAsFixed(2)}')),
                ],
              );
            }).toList(),
          ),
        );
      }
      },
      ),
        bottomNavigationBar: BottomAppBar(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                FutureBuilder<List<ProductDetails>>(
                  future: futureCartProducts,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      double totalPrice = 0;
                      for (var product in snapshot.data!) {
                        final quantity = cart.items[product.id] ?? 0;
                        totalPrice += product.price * quantity;
                      }
                      return Text(
                        'Total: \$${totalPrice.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    } else {
                      return const Text('Calculating...',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    }
                  },
                ),
                ElevatedButton(
                  onPressed: () {
                    // Here you should add the logic for the checkout process
                  },
                  child: const Text('Checkout'),
                ),
              ],
            ),
          ),
        ),
      );
    }
}
