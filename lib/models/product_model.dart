import 'package:flutter/material.dart';
import 'package:utm_app/services/products.dart';
import 'package:utm_app/views/product_details.dart';
import 'package:utm_app/models/review_model.dart';
import 'package:intl/intl.dart';
import 'package:utm_app/controllers/cart_controller.dart';
import 'package:utm_app/views/shopping_cart.dart';

const Color gold = Color(0xFFFFD700);

class ProductDetailsPage extends StatefulWidget {
  final Products product;

  const ProductDetailsPage({Key? key, required this.product}) : super(key: key);

  @override
  ProductDetailsPageState createState() => ProductDetailsPageState();
}


class ReviewWidget extends StatelessWidget {
  final Review review;


  String formatDate(String dateStr) {
    final inputFormat = DateFormat("yyyy-MM-dd HH:mm:ss.SSSSSS");
    final outputFormat = DateFormat("d MMM, y");

    DateTime date = inputFormat.parse(dateStr);
    return outputFormat.format(date);
  }

  const ReviewWidget({Key? key, required this.review}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(review.author.avatar),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    review.author.name,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.access_time, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(formatDate(review.createdAt)),
                    ],
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  "${review.rate} Rating",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Row(  // Звезды
                  children: List.generate(5, (index) => Icon(
                    index < review.rate ? Icons.star_rate : Icons.star_rate_outlined,
                    color: gold,
                  )),
                ),
              ],
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Text(
            review.text,
            overflow: TextOverflow.ellipsis,
            maxLines: 3,
          ),
        ),
      ],
    );
  }
}






class ProductDetailsPageState extends State<ProductDetailsPage> {
  late Future<ProductDetails> futureProduct;
  int currentImageIndex = 0;
  bool showFullDescription = false;
  bool showAllReviews = false;
  int cartCount = 0;
  final Cart cart = Cart();


  void addToCart() {
    setState(() {
      cart.addToCart(widget.product.id);
    });
  }


  double computeAverageRating(List<Review> reviews) {
    if (reviews.isEmpty) return 0;
    double total = reviews.fold(0, (prev, review) => prev + review.rate);
    return total / reviews.length;
  }

  @override
  void initState() {
    super.initState();
    futureProduct = fetchProductDetails(widget.product.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<ProductDetails>(
        future: futureProduct,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            final productDetails = snapshot.data;
            final pageController = PageController();

            return LayoutBuilder(
              builder: (context, constraints) {
            return SingleChildScrollView(

              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),

              child: Column(
                children: <Widget>[
                SizedBox(
                height: 300,
                child: Stack(
                  children: [

                    PageView(
                      controller: pageController,
                      children: productDetails!.images.map((url) => Image.network(url)).toList(),
                    ),

                    Positioned(
                      top: 20.0,
                      left: 10.0,
                      child: CircleAvatar(
                        radius: 25,
                        backgroundColor: Colors.grey[200],
                        child: const BackButton(color: Colors.grey),
                      ),
                    ),
                    Positioned(
                      top: 20.0,
                      right: 10.0,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          CircleAvatar(
                            radius: 25,
                            backgroundColor: Colors.grey[200],
                            child: IconButton(
                              icon: const Icon(Icons.shopping_cart, color: Colors.grey),
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => const CartPage(),
                                ));
                              },
                            ),
                          ),
                          if (cart.itemCount > 0)
                            Positioned(
                              bottom: 0, right: 0,
                              child: CircleAvatar(
                                radius: 10.0,
                                backgroundColor: Colors.red,
                                child: Text(
                                  '${cart.itemCount}',
                                  style: const TextStyle(
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
                ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          productDetails.category.title,
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.grey,
                          ),
                        ),
                        const Text(
                          "Price",
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                productDetails.title,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 3,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              '\$${productDetails.price.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 100,
                    child: Center(
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        itemCount: productDetails.images.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                currentImageIndex = index;
                                pageController.jumpToPage(index);
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: Image.network(
                                  productDetails.images[index],
                                  width: 80,
                                  height: 80,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Size",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        for (var size in ['S', 'M', 'L', 'XL', '2XL'])
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              elevation: 0,
                            ),
                            onPressed: () {

                            },
                            child: Text(size),
                          ),
                      ],
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Description",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          showFullDescription
                              ? productDetails.description
                              : productDetails.description.length > 100
                              ? '${productDetails.description.substring(0, 100)}...'
                              : productDetails.description,
                          maxLines: showFullDescription ? null : 3,
                          overflow: showFullDescription ? null : TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 16),
                        ),
                        if (productDetails.description.length > 100 && !showFullDescription)
                          InkWell(
                            onTap: () {
                              setState(() {
                                showFullDescription = true;
                              });
                            },
                            child: const Text(
                              'Read More',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.blue,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        const Text(
                          "Reviews",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            setState(() {
                              showAllReviews = true;
                            });
                          },
                          child: const Text(
                            "View all",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                Column(
                    children: [
                FutureBuilder<List<Review>>(
                future: fetchReviews(widget.product.id),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    }
                    final reviews = snapshot.data!;
                    return Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "${reviews.length} Reviews",
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        computeAverageRating(reviews).toStringAsFixed(1),
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(width: 4),
                                      Row(
                                        children: List.generate(5, (index) => Icon(
                                          index < computeAverageRating(reviews) ? Icons.star : Icons.star_border,
                                          color: gold,
                                        )),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  //
                                },
                                child: const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.edit),
                                    SizedBox(width: 4),
                                    Text("Add Review"),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        ListView.builder(
                          shrinkWrap: true,
                          itemCount: showAllReviews ? reviews.length : 3,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                              child: Column(
                                children: [
                                  ReviewWidget(review: reviews[index]),
                                  const Divider(),
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                    );
                  } else {
                          return const CircularProgressIndicator();
                        }
                      },
                    ),
                ],
                ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Total Price",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        Text(
                          '\$${productDetails.price.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    child: ElevatedButton(
                      onPressed: addToCart,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        minimumSize: const Size(double.infinity, 50),
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                      ),
                      child: const Text(
                        "Add to Cart",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            );
    },
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
