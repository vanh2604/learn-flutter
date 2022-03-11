import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

List<Product> parseProducts(String responseBody) {
  final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
  return parsed.map<Product>((json) => Product.fromMap(json)).toList();
}

Future<List<Product>> fetchProducts() async {
  final response = await http.get(Uri.parse("http://10.0.2.2:3000/products"));
  if (response.statusCode == 200) {
    return parseProducts(response.body);
  } else {
    throw Exception('Unable to fetch products from the REST API');
  }
}

class MyApp extends StatefulWidget {
  final Future<List<Product>> products;
  // This widget is the root of your application.
  const MyApp({Key? key, required this.products}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with SingleTickerProviderStateMixin {
  late Animation<double> animation;
  late AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    );
    animation = Tween<double>(begin: 0.0, end: 1.0).animate(controller);
    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    controller.forward();
    return MaterialApp(
      title: 'Hello World Demo Application',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: MyHomePage(
        title: 'Home page',
        animation: animation,
        products: widget.products,
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}

class MyAnimateWidget extends StatelessWidget {
  const MyAnimateWidget(
      {Key? key, required this.child, required this.animation})
      : super(key: key);
  final Widget child;
  final Animation<double> animation;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedBuilder(
        animation: animation,
        builder: (context, child) => Opacity(
          opacity: animation.value,
          child: child,
        ),
        child: child,
      ),
    );
  }
}

class Product {
  final String name;
  final String description;
  final int price;
  final String image;
  Product(this.name, this.description, this.price, this.image);

  factory Product.fromMap(Map<String, dynamic> json) {
    return Product(
      json['name'],
      json['description'],
      json['price'],
      json['image'],
    );
  }
}

class ProductBox extends StatelessWidget {
  const ProductBox({
    Key? key,
    required this.item,
  }) : super(key: key);
  final Product item;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(2),
      height: 150,
      child: Card(
          child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Image.asset("assets/appimages/" + item.image,
              width: 150, height: 150),
          Expanded(
              child: Container(
            padding: const EdgeInsets.all(5),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.bold),
                ),
                Text(
                  item.description,
                  style: const TextStyle(fontSize: 15),
                ),
                Text(
                  "price ${item.price.toString()}",
                  style: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.bold),
                ),
                const RatingBox(),
              ],
            ),
          ))
        ],
      )),
    );
  }
}

class RatingBox extends StatefulWidget {
  const RatingBox({Key? key}) : super(key: key);

  @override
  _RatingBoxState createState() => _RatingBoxState();
}

class _RatingBoxState extends State<RatingBox> {
  int _rating = 0;
  void _setRatingAsOne() {
    setState(() {
      _rating = 1;
    });
  }

  void _setRatingAsTwo() {
    setState(() {
      _rating = 2;
    });
  }

  void _setRatingAsThree() {
    setState(() {
      _rating = 3;
    });
  }

  @override
  Widget build(BuildContext context) {
    double _size = 20;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(2),
          child: IconButton(
            icon: (_rating >= 1
                ? Icon(Icons.star, size: _size)
                : Icon(Icons.star_border, size: _size)),
            onPressed: () {
              _setRatingAsOne();
            },
            iconSize: _size,
            color: Colors.yellow[500],
          ),
        ),
        Container(
          padding: const EdgeInsets.all(2),
          child: IconButton(
            icon: (_rating >= 2
                ? Icon(Icons.star, size: _size)
                : Icon(Icons.star_border, size: _size)),
            onPressed: () {
              _setRatingAsTwo();
            },
            iconSize: _size,
            color: Colors.yellow[500],
          ),
        ),
        Container(
          padding: const EdgeInsets.all(2),
          child: IconButton(
            icon: (_rating >= 3
                ? Icon(Icons.star, size: _size)
                : Icon(Icons.star_border, size: _size)),
            onPressed: () {
              _setRatingAsThree();
            },
            iconSize: _size,
            color: Colors.yellow[500],
          ),
        )
      ],
    );
  }
}

class ProductBoxList extends StatelessWidget {
  final List<Product> items;
  const ProductBoxList({Key? key, required this.items});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          child: ProductBox(item: items[index]),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProductPage(item: items[index]),
              ),
            );
          },
        );
      },
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage(
      {Key? key,
      required this.animation,
      required this.products,
      required this.title})
      : super(key: key);
  final String title;
  final Animation<double> animation;
  final Future<List<Product>> products;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("Product Navigation")),
        body: Center(
          child: FutureBuilder<List<Product>>(
            future: products,
            builder: (context, snapshot) {
              if (snapshot.hasError) print(snapshot.error);
              return snapshot.hasData
                  ? ProductBoxList(items: snapshot.data!)

                  // return the ListView widget :
                  : const Center(child: CircularProgressIndicator());
            },
          ),
        ));
  }
}

class ProductPage extends StatelessWidget {
  const ProductPage({Key? key, required this.item}) : super(key: key);
  final Product item;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(item.name),
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(10),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Image.asset(
                  "assets/appimages/" + item.image,
                  height: 200.0,
                  width: MediaQuery.of(context).size.width,
                ),
                Expanded(
                    child: Container(
                        padding: const EdgeInsets.all(1),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Text(item.name,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 20)),
                            Text(item.description),
                            Text("Price: " + item.price.toString(),
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 20)),
                            const RatingBox(),
                          ],
                        )))
              ]),
        ),
      ),
    );
  }
}
