import 'package:flutter/material.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'iShop Flutter',
      theme: new ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or press Run > Flutter Hot Reload in IntelliJ). Notice that the
        // counter didn't reset back to zero; the application is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: new ShoppingPage(),
    );
  }
}
class ShoppingPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _ShoppingState();
  }
}

class _ShoppingState extends State<ShoppingPage> {
  List<Food> foods = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadFood();
  }

  loadFood() async {
    setState(() {
      foods = (jsonResponse['foods'] as List<dynamic>)
          .map((item) => Food.fromJson(item))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: _buildAppBar(),
      body: foods.isEmpty
          ? Container(
        height: double.infinity,
        padding: EdgeInsets.all(24.0),
        alignment: Alignment.center,
        child: Text("Food is empty, refresh to reset the menu"),
      )
          : ListView(
        padding: EdgeInsets.all(16.0),
        children: foods.map((item) => _buildListItem(item)).toList(),
      ),
    );
  }

  Widget _buildListItem(Food item) {
    return Card(
      margin: EdgeInsets.only(bottom: 8.0),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0),
        width: double.infinity,
//        height: MediaQuery.of(context).size.width * 0.3,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(right: 24.0),
              child: Icon(
                Icons.restaurant_menu,
                size: 40.0,
                color: Colors.blue.shade700,
              ),
            ),
            Expanded(
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    item.foodName,
                    style: TextStyle(
                        color: Colors.black87,
                        fontSize: 16.5,
                        fontWeight: FontWeight.w500),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 4.0),
                  ),
                  Row(
                    children: <Widget>[
                      Text(
                        "Tersedia",
                        style: TextStyle(
                            color: Colors.grey.shade500,
                            fontSize: 14.5,
                            fontWeight: FontWeight.w500),
                      ),
                      Text(
                        " ${item.quantity}",
                        style: TextStyle(
                            color: Colors.green.shade900,
                            fontSize: 16.5,
                            fontWeight: FontWeight.w500),
                      ),
                      Text(
                        " pax",
                        style: TextStyle(
                            color: Colors.grey.shade500,
                            fontSize: 14.5,
                            fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 8.0),
                  ),
                  Row(
                    children: <Widget>[
                      Text(
                        "Rp ${item.price.toString()}.000,-",
                        style: TextStyle(
                            color: Colors.black87,
                            fontSize: 17.5,
                            fontWeight: FontWeight.w600),
                      ),
                      Text(
                        " /pax",
                        style: TextStyle(
                            color: Colors.grey.shade500,
                            fontSize: 14.5,
                            fontWeight: FontWeight.w500),
                      ),
                    ],
                  )
                ],
              ),
            ),
            InkWell(
              onTap: () {
                addToCart(item);
              },
              child: Icon(
                Icons.add_shopping_cart,
                size: 20.0,
                color: Colors.deepOrange.shade700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  addToCart(Food item) async {
    dummyShoppingCart.add(item);
    if (item.quantity == 1) {
      foods.removeWhere((f) => f.foodName == item.foodName);
    } else {
      var _selectedIndex = foods.indexWhere((f) => item.foodName == f.foodName);
      foods[_selectedIndex].quantity = foods[_selectedIndex].quantity - 1;
    }
    setState(() {});
  }

  Widget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.blue.shade800,
      title: Text("Food Menu"),
      actions: <Widget>[
        Container(
          padding: EdgeInsets.only(right: 16.0),
          child: InkWell(
            child: Icon(
              Icons.shopping_cart,
              color: Colors.white,
            ),
            onTap: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (_) => ShoppingCartPage()));
            },
          ),
        ),
        Container(
          padding: EdgeInsets.only(right: 16.0),
          child: InkWell(
            onTap: () {
              loadFood();
            },
            child: Icon(
              Icons.refresh,
              color: Colors.white,
            ),
          ),
        )
      ],
    );
  }
}

class ShoppingCartPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _ShoppingCartState();
  }
}

class _ShoppingCartState extends State<ShoppingCartPage> {
  List<Food> foods = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadFood();
  }

  loadFood() async {
    if (dummyShoppingCart.isEmpty) {
      foods = [];
      setState(() {});
      return;
    }
    List.generate(dummyShoppingCart.length, (index) {
      var item = dummyShoppingCart[index];
      if (foods.where((i) => i.foodName == item.foodName).toList().isEmpty) {
        var _f = item;
        item.quantity = 1;
        foods.add(_f);
      } else {
        var _index = foods.indexWhere((f) => item.foodName == f.foodName);
        foods[_index].quantity = foods[_index].quantity + 1;
      }
    });
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: _buildAppBar(),
      body: foods.isEmpty
          ? Container(
        width: double.infinity,
        height: double.infinity,
        padding: EdgeInsets.all(24.0),
        alignment: Alignment.center,
        child: Text("Shopping Cart Is Empty"),
      )
          : Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: ListView(
              padding: EdgeInsets.all(16.0),
              children:
              foods.map((item) => _buildListItem(item)).toList(),
            ),
          ),
          Container(
            child: SafeArea(
                child: Card(
                  child: Container(
                    margin: EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          "Total",
                          style: TextStyle(
                              color: Colors.green.shade900,
                              fontSize: 16.5,
                              fontWeight: FontWeight.w500),
                        ),
                        Text(
                          foods.isEmpty
                              ? "Rp 0,-"
                              : "Rp ${foods.map((item) {
                            return item.quantity * item.price;
                          }).reduce((val, element) => val + element)}.000,-",
                          style: TextStyle(
                              color: Colors.green.shade900,
                              fontSize: 19.5,
                              fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                )),
            color: Colors.white,
            margin: EdgeInsets.all(8.0),
          )
        ],
      ),
    );
  }

  Widget _buildListItem(Food item) {
    return Card(
      margin: EdgeInsets.only(bottom: 8.0),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0),
        width: double.infinity,
//        height: MediaQuery.of(context).size.width * 0.3,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(right: 24.0),
              child: Icon(
                Icons.restaurant_menu,
                size: 40.0,
                color: Colors.blue.shade700,
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    item.foodName,
                    style: TextStyle(
                        color: Colors.black87,
                        fontSize: 16.5,
                        fontWeight: FontWeight.w500),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 4.0),
                  ),
                  Row(
                    children: <Widget>[
                      Text(
                        "Pesan",
                        style: TextStyle(
                            color: Colors.grey.shade500,
                            fontSize: 14.5,
                            fontWeight: FontWeight.w500),
                      ),
                      Text(
                        " ${item.quantity}",
                        style: TextStyle(
                            color: Colors.green.shade900,
                            fontSize: 16.5,
                            fontWeight: FontWeight.w500),
                      ),
                      Text(
                        " pax",
                        style: TextStyle(
                            color: Colors.grey.shade500,
                            fontSize: 14.5,
                            fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 4.0),
                  ),
                  Row(
                    children: <Widget>[
                      Text(
                        "Rp ${item.price.toString()}.000,-",
                        style: TextStyle(
                            color: Colors.grey.shade700,
                            fontSize: 15.5,
                            fontWeight: FontWeight.w500),
                      ),
                      Text(
                        " /pax",
                        style: TextStyle(
                            color: Colors.grey.shade500,
                            fontSize: 14.5,
                            fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 8.0),
                  ),
                  Row(
                    children: <Widget>[
                      Text(
                        "Rp ${(item.price * item.quantity).toString()}.000,-",
                        style: TextStyle(
                            color: Colors.black87,
                            fontSize: 18.5,
                            fontWeight: FontWeight.w600),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.blue.shade800,
      title: Text("Shopping Cart"),
      actions: <Widget>[
        Container(
          padding: EdgeInsets.only(right: 16.0),
          child: InkWell(
            onTap: () {
              dummyShoppingCart = [];
              loadFood();
            },
            child: Icon(
              Icons.remove_shopping_cart,
              color: Colors.white,
            ),
          ),
        )
      ],
    );
  }
}

List<Food> dummyShoppingCart = [];

class Food {
  String foodName;
  int price;
  int quantity;

  Food(this.foodName, this.price, this.quantity);

  Food.fromJson(Map<String, dynamic> item)
      : foodName = item['foodName'],
        price = item['price'],
        quantity = item['quantity'];

  Map<String, dynamic> toJson() => {
    'foodName': foodName,
    'price': price,
    'quantity': quantity,
  };
}

Map<String, dynamic> get jsonResponse {
  return {
    "foods": [
      {"foodName": "Ayam Goreng Dada", "price": 10, "quantity": 5},
      {"foodName": "Ayam Goreng Paha", "price": 8, "quantity": 6},
      {"foodName": "Nasi Goreng", "price": 15, "quantity": 5},
      {"foodName": "Mie Goreng", "price": 14, "quantity": 3},
      {"foodName": "Kwetiau Goreng", "price": 12, "quantity": 2},
      {"foodName": "Bihun Goreng", "price": 12, "quantity": 1},
      {"foodName": "Mie Rebus", "price": 14, "quantity": 1},
      {"foodName": "Kwetiau Rebus", "price": 12, "quantity": 2},
      {"foodName": "Bihun Rebus", "price": 11, "quantity": 3},
    ]
  };
}
