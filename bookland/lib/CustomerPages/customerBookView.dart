import 'package:bookland/CustomerPages/comment_write.dart';
import 'package:bookland/elements/appBar.dart';
import 'package:bookland/elements/bottomNavigatorBar.dart';
import 'package:bookland/services/http_admin.dart';
import 'package:bookland/services/http_comment_vote.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:bookland/services/http_book.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:bookland/main.dart';
import 'package:bookland/login.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:bookland/CustomerPages/comment_view.dart';

import '../services/http_customer.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

/// This class contains the objects which is the same in GET allBooks method

String customerBookId;

class CustomerBookView extends StatelessWidget {
  String _bookName;
  int _quantity;
  final String isbn;

  CustomerBookView({Key key, @required this.isbn}) : super(key: key);

  final HttpBook httpBook = HttpBook();
  final HttpAdmin httpAdmin = HttpAdmin();
  static const String _title = 'BookView';
  var rating = 0.0;
  CommentVote commentVote = new CommentVote();

  @override
  Widget build(BuildContext context) {
    getTotalCommentCount(); // Fetch total comment before comment view page
    return Scaffold(
        appBar: MyAppBar(
          pageTitle: "Book",
          loginIcon: false,
          back: false,
          filter_list: false,
          search: false,
        ),
        body: FutureBuilder(
          future: httpBook.getBook(isbn),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              print("snapshot has data");
              if (snapshot.data.inWishlist.toString() == "1") {
                inWhistlist = true;
              } else {
                inWhistlist = false;
              }

              customerBookId = snapshot.data.details.bookId.toString();
              //return Text(snapshot.data.bookName);
              return Container(
                width: double.infinity,
                padding: EdgeInsets.only(top: 20, bottom: 20),
                child: new SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      real_isbn((snapshot.data.details.real_isbn).toString()),
                      Text("\n"),
                      name((snapshot.data.details.bookName).toString()),
                      Text("\n"),
                      imageBook((snapshot.data.details.bookImage).toString()),
                      Post(),
                      stars(snapshot.data.vote.toString()),
                      author((snapshot.data.details.author).toString()),
                      Text("\n"),
                      category((snapshot.data.details.category).toString()),
                      Text("\n"),
                      quantity((snapshot.data.details.quantity).toString()),
                      Text("\n"),
                      (snapshot.data.details.inDiscount == 1)
                          ? firstPrice(
                              (snapshot.data.details.firstPrice).toString())
                          : emptyWidget(),
                      priceBook((snapshot.data.details.price).toString()),
                      description(
                          (snapshot.data.details.description).toString()),
                      Text("\n"),
                      addBasketButton(context, customerID, isLogin),
                      commentField(context),
                      rateField(context),
                    ],
                  ),
                ),
              );
            } else if (snapshot.hasError) {
              print("Snapshot has error*");
              return Text("${snapshot.error}");
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ),
        bottomNavigationBar: MyBottomNavigatorBar());
  }

  Widget imageBook(String url) {
    return new Stack(
      children: <Widget>[
        /**Image.asset(
            'assets/booking/book1.jpg',
            height: 300,
            width: 200,
            ),**/
        Image.network(
          url,
          width: 300,
          height: 400,
        )
      ],
    );
  }

  Widget stars(String voteRatio) {
    double vote;
    if (voteRatio.toString() == "0.0") {
      vote = 0;
    } else {
      vote = double.parse(voteRatio);
    }
    print(vote);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconTheme(
          data: IconThemeData(
            color: Colors.amber,
            size: 48,
          ),
          child: StarRating(
            rating: vote,
            color: Colors.yellow,
          ), //StarDisplay(value: vote),
        ),
      ],
    );
  }

  Widget name(String text) {
    _bookName = text;
    return Text(
      text,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 30,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget author(String text) {
    return Text(
      '\nAuthor-' + text,
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget description(String text) {
    var title = Container(
        margin: EdgeInsets.only(top: 15.0),
        child: Text(
          "Description",
          style: TextStyle(fontSize: 22, decoration: TextDecoration.underline),
          textAlign: TextAlign.center,
        ));
    var description = Container(
        padding: EdgeInsets.all(10.0),
        child: Text(text, style: TextStyle(fontSize: 18)));

    return Column(
      children: <Widget>[title, description],
    );
  }

  Widget real_isbn(String text) {
    return Text(
      '\n\nISBN:' + text,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget quantity(String text) {
    _quantity = int.parse(text);
    return Text(
      'Quantity: ' + text,
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget category(String text) {
    return Text(
      'Category: ' + text,
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  //BU WIDGET'I SİLMEYİN, İNDİRİMİ KONTROL EDİYOR
  Widget emptyWidget() {
    mainAxisSize:
    MainAxisSize.min;
    return new Row(
      children: <Widget>[Text(" ")],
    );
  }

  //Discountsuz hali
  Widget firstPrice(String price) {
    String stringPrice;
    double realPrice = double.parse(
        price); //Convert to double the string price that comes from parameters
    stringPrice = realPrice
        .toStringAsFixed(2); //Convert to string with 2 digits fractional part.

    var fiyatNum = Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Text(
          stringPrice,
          style: TextStyle(
            decoration: TextDecoration.lineThrough,
            decorationThickness: 2.5,
            decorationColor: Colors.red,
            color: Color.fromARGB(140, 0, 0, 0),
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          '\$',
          style: TextStyle(
            color: Color.fromARGB(140, 0, 0, 0),
            decoration: TextDecoration.lineThrough,
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
    var fiyat = Text(
      '             ',
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    );

    return new Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
      fiyat,
      fiyatNum,
    ]);
  }

  //Discount varsa discount hali
  Widget priceBook(String price) {
    //price = '9.99';
    String stringPrice;
    double realPrice = double.parse(
        price); //Convert to double the string price that comes from parameters
    stringPrice = realPrice
        .toStringAsFixed(2); //Convert to string with 2 digits fractional part.

    var fiyatNum = Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Text(
          stringPrice,
          style: TextStyle(
            color: Colors.green,
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          '\$',
          style: TextStyle(
            color: Colors.green,
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
    var fiyat = Text(
      'Price : ',
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    );

    return new Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
      fiyat,
      fiyatNum,
    ]);
  }

  Widget addBasketButton(
      BuildContext context, String _customerId, bool _isLogin) {
    return RaisedButton(
      onPressed: () {
        // TODO Call Basket class
        print(_quantity);
        print(_bookName);
        print(isbn);
        // If customer log in the system
        if (_isLogin) {
          addBasketPref(_customerId, isbn);
          getBasket(_customerId);
          // TODO Show up dialog
          showDialog(
            context: context,
            builder: (BuildContext context) {
              // return object of type Dialog
              return AlertDialog(
                shape: new RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                title: new Text("Basket"),
                content: new Text("You've added to basket."),
                actions: <Widget>[
                  // usually buttons at the bottom of the dialog
                  new FlatButton(
                    shape: new RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    color: Colors.blue,
                    child: new Text("OK"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        } else {
          Navigator.push(
            context,
            new MaterialPageRoute(builder: (context) => new Login()),
          );
        }
      },
      textColor: Colors.white,
      padding: const EdgeInsets.all(0.0),
      child: Container(
        color: Colors.orangeAccent,
        padding: const EdgeInsets.all(10.0),
        child: const Text('Add Basket', style: TextStyle(fontSize: 20)),
      ),
    );
  }

  Widget commentField(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        writeCommentButton(context),
        viewCommentButton(context),
      ],
    );
  }

  Widget writeCommentButton(BuildContext context) {
    return RaisedButton(
      child: Text(
        "Write Comment",
        style: TextStyle(fontSize: 20, color: Colors.white),
      ),
      color: Colors.pinkAccent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      onPressed: () {
        // Control the user who is login or not
        if (isLogin) {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CommentWrite(isbn, customerID),
              ));
        } else {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Login(),
              ));
        }
      },
    );
  }

  // TODO This widget will be developed with better UI
  Widget viewCommentButton(BuildContext context) {
    return RaisedButton(
      child: Text(
        "View Comments",
        style: TextStyle(fontSize: 20, color: Colors.white),
      ),
      color: Colors.green,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      onPressed: () {
        Navigator.push(context,
            new MaterialPageRoute(builder: (context) => CommentView(isbn)));
      },
    );
  }

  /// This function fetches the total comment count
  /// And assigns to integer value
  void getTotalCommentCount() async {
    CommentVote commentVote = new CommentVote();
    commentCount = await commentVote.getCommentCount(isbn);
  }

  /// This widget keeps the rating starts and button in row
  Widget rateField(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        rate(),
        rateButton(context),
      ],
    );
  }

  /// This function builds a star votes
  /// Updates rating value at each rated
  Widget rate() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 25, 0, 0),
      child: SmoothStarRating(
          rating: rating,
          isReadOnly: false,
          size: 30,
          filledIconData: Icons.star,
          defaultIconData: Icons.star_border,
          starCount: 5,
          allowHalfRating: false,
          spacing: 2.0,
          onRated: (value) {
            print('rating value --> $value');
            rating = value;
          }),
    );
  }

  /// This function builds a button for giving vote
  Widget rateButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 25, 0, 0),
      child: RaisedButton(
        child: Text(
          "Vote!",
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
        color: Colors.red,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        onPressed: () {
          if (isLogin) {
            // Save rating on the database
            commentVote.giveRating(customerID, isbn, (rating).toInt());
            int vote = (rating).toInt();
            showDialog(
              context: context,
              builder: (BuildContext context) {
                // return object of type Dialog
                return AlertDialog(
                  shape: new RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  title: new Text("Vote"),
                  content: new Text("Your vote is $vote."),
                  actions: <Widget>[
                    // usually buttons at the bottom of the dialog
                    new FlatButton(
                      shape: new RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      color: Colors.blue,
                      child: new Text(
                        "OK",
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                );
              },
            );
          } else {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                // return object of type Dialog
                return AlertDialog(
                  shape: new RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  title: new Text("Vote Error"),
                  content: new Text(
                      "You cannot give vote! You did not login the system!"),
                  actions: <Widget>[
                    // usually buttons at the bottom of the dialog
                    new FlatButton(
                      shape: new RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      color: Colors.blue,
                      child: new Text(
                        "OK",
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                );
              },
            );
          }
        },
      ),
    );
  }

  void getBasket(String _customerId) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    for (int i = 0;
        i < sharedPreferences.getStringList(_customerId).length;
        i++) {
      print(sharedPreferences.getStringList(_customerId)[i]);
    }
  }

  /// @param _customerId represents the customer's id who is using the app
  /// @param _bookId represents the book id that we want to add on basket
  /// This function adds new book in the shared preferences
  void addBasketPref(String _customerId, String _bookId) async {
    // TODO quantity should be updated
    printSharedPref();
    // Create a shared preferences object
    SharedPreferences sharedPref = await SharedPreferences.getInstance();

    // Control user who is stored in shared preferences
    // If user is saved in shared preferences, go with if block
    if (sharedPref.containsKey(_customerId)) {
      print("IF START");
      List bookList = sharedPref.getStringList(_customerId); // Get book list
      print("BOOK LIST");
      print(bookList);
      if (bookList == null) {
        print("BOOK LIST IS NULL");
        bookList = [];
      } else {
        print("BOOK LIST IS NOT NULL");
      }
      int i = 0;
      while (i < bookList.length) {
        if (bookList[i] == _bookId) {
          // If book is already added into list
          // Get book quantity
          // Increment quantity by one
          // Update quantity with new value
          // Update shared preferences with new list
          int tempQuantity = int.parse(bookList[i + 1]);
          tempQuantity++;
          bookList[i + 1] = tempQuantity.toString();
          sharedPref.setStringList(_customerId, bookList);
          printSharedPref();
          return;
        }
        i += 2;
      }
      // If book is not stored in the list
      // Add book id and quantity(1)
      // Update shared preferences with new list
      bookList.add(_bookId);
      bookList.add("1");
      sharedPref.setStringList(_customerId, bookList);
    } else {
      // If user is not saved in the shared preferences
      // Create a new list to store book id and quantity
      // Add book id and quantity(1)
      // Add new customer with book list
      List<String> bookList = [];
      bookList.add(_bookId);
      bookList.add("1");
      sharedPref.setStringList(_customerId, bookList);
      printSharedPref();
    }
  }

  void printSharedPref() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    print("PRINT SHARED");
    print(sharedPreferences.getKeys());
    for (String s in sharedPreferences.getKeys()) {
      print(sharedPreferences.get(s));
    }
    print(sharedPreferences.getStringList("1"));
    print("PRINT SHARED");
  }
}

// Bu satırdan aşağısı kitabı beğenip wishlist'e eklemek için.
// Kalp oluşturabilmek için bir widget oluşturdum.
// Post methodunu da yukarda widget arrayinde 53.satır'da çağırdım.
// Backend'i yazıldıktan sonra eklemeler buraya yapılabilir.
bool inWhistlist;

class Post extends StatefulWidget {
  @override
  PostState createState() => new PostState();
}

class PostState extends State<Post> {
  final HttpCustomer httpCustomer = HttpCustomer();
  bool liked = inWhistlist;

  _pressedLikeButton() {
    setState(() {
      if (isLogin) {
        liked = !liked;
      } else {
        liked = liked;
      }

    });
    if (liked == true) {
      httpCustomer.addToWishList(customerID, customerBookId);
    } else if (liked == false) {
      httpCustomer.removeFromWishList(customerID, customerBookId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: IconButton(
      iconSize: 48,
      icon: Icon(liked ? Icons.favorite : Icons.favorite_border,
          color: liked ? Colors.red : Colors.grey),
      onPressed: () => _pressedLikeButton(),
    ));
  }
}

class PostHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {}
}

class StarRating extends StatelessWidget {
  final int starCount;
  final double rating;
  final Color color;

  StarRating({this.starCount = 5, this.rating = .0, this.color});

  Widget buildStar(BuildContext context, int index) {
    Icon icon;
    if (index >= rating) {
      icon = new Icon(
        Icons.star_border,
        color: Theme.of(context).buttonColor,
      );
    } else if (index > rating - 1 && index < rating) {
      icon = new Icon(
        Icons.star_half,
        color: color ?? Theme.of(context).primaryColor,
      );
    } else {
      icon = new Icon(
        Icons.star,
        color: color ?? Theme.of(context).primaryColor,
      );
    }
    return new InkResponse(
      child: icon,
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Row(
        children:
            new List.generate(starCount, (index) => buildStar(context, index)));
  }
}
