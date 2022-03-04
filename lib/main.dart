import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  const MyApp({Key? key}) : super(key: key);

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

  static List<Product> getProducts() {
    List<Product> items = <Product>[];
    items.add(Product(
        "Pixel", "Pixel is the most featureful phone ever", 800, "pixel.jpeg"));
    items.add(Product("Laptop", "Laptop is most productive development tool",
        2000, "laptop.jpeg"));
    items.add(Product(
        "Tablet",
        "Tablet is the most useful device ever for meeting",
        1500,
        "tablet.jpg"));
    items.add(Product(
        "Pendrive", "iPhone is the stylist phone ever", 100, "pendrive.jpg"));
    items.add(Product("Floppy Drive", "iPhone is the stylist phone ever", 20,
        "floppydisk.png"));
    items.add(Product(
        "iPhone", "iPhone is the stylist phone ever", 1000, "iphone.jpg"));
    return items;
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

class MyHomePage extends StatelessWidget {
  MyHomePage({Key? key, required this.animation, required this.title})
      : super(key: key);
  final String title;
  final Animation<double> animation;
  final items = Product.getProducts();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(title),
        ),
        body: ListView.builder(
          itemCount: items.length,
          itemBuilder: (context, index) {
            if (index == 0) {
              return MyAnimateWidget(
                child: ProductBox(item: items[index]),
                animation: animation,
              );
            } else if (index == 1) {
              return FadeTransition(
                  opacity: animation, child: ProductBox(item: items[index]));
            } else {
              return GestureDetector(
                child: ProductBox(item: items[index]),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProductPage(
                        item: items[index],
                      ),
                    ),
                  );
                },
              );
            }
          },
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
          padding: const EdgeInsets.all(2),
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
