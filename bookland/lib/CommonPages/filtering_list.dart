import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:io';
import 'package:bookland/AdminPages/bookview.dart';
import 'package:bookland/elements/appBar.dart';
import 'package:bookland/elements/bottomNavigatorBar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_paginator/flutter_paginator.dart';
import 'package:bookland/CustomerPages/customerBookView.dart';

int total = 0;
SplayTreeSet isbnSet = new SplayTreeSet();
var globalExploreContext;
int deletedBookId = -1;
String filter_param ="" ;
List<String> oldPriceList = [];

class Explore_FilteredStateless extends StatelessWidget {
  Explore_FilteredStateless(int bookId,String filter_paramters) {
    deletedBookId = bookId;
    filter_param = filter_paramters;
    if (isbnSet.contains(deletedBookId)) {
      isbnSet.remove(deletedBookId);
    }
  }

  @override
  Widget build(BuildContext context) {
    globalExploreContext = context;
    return Scaffold(
      body: Explore_FilteredPage(),
    );
  }
}

class Explore_FilteredPage extends StatefulWidget {
  //String url_count = "1";
  String url_list = filter_param;

  @override
  State<StatefulWidget> createState() {
    return Explore_FilteredState();
  }
}

class Explore_FilteredState extends State<Explore_FilteredPage> {
  GlobalKey<PaginatorState> paginatorGlobalKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(pageTitle: "Explore",
        loginIcon: false,
        back: false,
        filter_list: false,
        search: true, ),
      body: Paginator.listView(
        key: paginatorGlobalKey,
        pageLoadFuture: sendBooksDataRequest,
        pageItemsGetter: listBooksGetter,
        listItemBuilder: listBookBuilder,
        loadingWidgetBuilder: loadingWidgetMaker,
        errorWidgetBuilder: errorWidgetMaker,
        emptyListWidgetBuilder: emptyListWidgetMaker,
        totalItemsGetter: totalPagesGetter,
        pageErrorChecker: pageErrorChecker,
        scrollPhysics: BouncingScrollPhysics(),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          paginatorGlobalKey.currentState.changeState(
              pageLoadFuture: sendBooksDataRequest, resetState: true);
        },
        child: Icon(Icons.refresh),
      ),


      bottomNavigationBar: MyBottomNavigatorBar(),

    );
  }

  void getTotalCount() async {
    try {
      String username = 'Daryl';
      String password = 'WalkingDead';
      String basicAuth =
          'Basic ' + base64Encode(utf8.encode('$username:$password'));
      var urlBookCount = "http://10.0.2.2:8080/getBookCountByFilters?${widget.url_list}";

      String _urlBookCount = Uri.encodeFull(urlBookCount);
      http.Response responseCount = await http.get(
        _urlBookCount,
        headers: <String, String>{'authorization': basicAuth},
      );

      if (responseCount.statusCode == 200) {
        total = json.decode(responseCount.body);
        //total = 1; //TODO düzelince gidecek
        print(total);
      } else {
        print(responseCount.statusCode);
        throw Exception("Books are not retrieved!");
      }
    } catch (e) {
      print("SocketException");
      throw Exception(e);
    }
  }

  Future<BooksData> sendBooksDataRequest(int page) async {
    try {
      getTotalCount();
      var url = "http://10.0.2.2:8080/Filtering/${page}/10?${widget.url_list}";
      print(url);
      String username = 'Daryl';
      String password = 'WalkingDead';
      String basicAuth =
          'Basic ' + base64Encode(utf8.encode('$username:$password'));
      String _url = Uri.encodeFull(url);
      http.Response response = await http.get(
        _url,
        headers: <String, String>{'authorization': basicAuth},
      );
      return BooksData.fromResponse(response);
    } catch (e) {
      if (e is IOException) {
        return BooksData.withError("Please check your internet connection.");
      } else {
        print(e.toString());
        return BooksData.withError("Something went wrong.");
      }
    }
  }

  List<dynamic> listBooksGetter(BooksData booksData) {
    List<dynamic> bookNameList = [];
    List<int> isbnList = [];
    for (int i = 0; i < booksData.books.length; i++) {
      String val = "Book:\t" +
          booksData.books[i] +
          "\n" +
          "Author:\t" +
          booksData.authors[i] +
          "\n" +
          "Price:\t" +
          "|"+
          booksData.prices[i].toString() +
          "|" +
          (booksData.img_list[i].toString()) +
          "|" +
          booksData.isbn_list[i].toString();
      // String img_val = (booksData.img_list[i].toString());
      bookNameList.add(val);
    }

    return bookNameList;
  }

  Widget loadingWidgetMaker() {
    return Container(
      alignment: Alignment.center,
      height: 160.0,
      child: CircularProgressIndicator(),
    );
  }

  Widget listBookBuilder(value, int index) {
    var value_list = value.toString().split("|");
    String text_part = value_list[0];
    String last_price_part = value_list[1];
    String img_part = value_list[2];
    String bookid_send = value_list[3];
    String final_text = text_part;

    if(oldPriceList[index] == "0" ){
      final_text = final_text + last_price_part + "  \$";
      return ListTile(
        //leading:  Image.network("https://dictionary.cambridge.org/tr/images/thumb/book_noun_001_01679.jpg?version=5.0.75"),
          leading:  Image.network(img_part),
          title: Text(final_text ,style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),) ,
          onTap: () {
            Navigator.push(
                globalExploreContext,
                MaterialPageRoute(
                  builder: (context) =>
                  // new BookView(isbn: isbnSet.elementAt(index).toString()),
                  new CustomerBookView(isbn: bookid_send),
                ));
          });
    }else{
      final_text = final_text +last_price_part  + " \$";

      return ListTile(

        //leading:  Image.network("https://dictionary.cambridge.org/tr/images/thumb/book_noun_001_01679.jpg?version=5.0.75"),
          leading:  Image.network(img_part),
          title: Text(final_text ,style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),) ,
          subtitle: Text(oldPriceList[index] + " \$" ,style: TextStyle(
            decoration: TextDecoration.lineThrough,
            decorationThickness: 2.5,
            decorationColor: Colors.red,
            color: Color.fromARGB(140, 0, 0, 0),
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),),
          onTap: () {
            Navigator.push(
                globalExploreContext,
                MaterialPageRoute(
                  builder: (context) =>
                  // new BookView(isbn: isbnSet.elementAt(index).toString()),
                  new CustomerBookView(isbn: bookid_send),
                ));
          });
    }

  }

  Widget errorWidgetMaker(BooksData booksData, retryListener) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(booksData.errorMessage),
        ),
        FlatButton(
          onPressed: retryListener,
          child: Text("Retry"),
        )
      ],
    );
  }

  Widget emptyListWidgetMaker(BooksData booksData) {
    isbnSet.clear();
    booksData.books.clear();
    booksData.authors.clear();
    booksData.prices.clear();
    booksData.img_list.clear();
    booksData.isbn_list.clear();
    oldPriceList = [];
    return Center(
      child: Text("No books in the list"),
    );
  }

  int totalPagesGetter(BooksData booksData) {
    // TODO This should be fixed
    return total;
  }

  bool pageErrorChecker(BooksData booksData) {
    return booksData.statusCode != 200;
  }
}

class BooksData {
  List<dynamic> books = new List<dynamic>();
  List<dynamic> authors = new List<dynamic>();
  List<dynamic> prices = new List<dynamic>();
  List<dynamic> isbn = new List<dynamic>();
  List<dynamic> img_list = new List<dynamic>();
  List<dynamic> isbn_list = new List<dynamic>();
  List<dynamic> oldPrice_List = new List<dynamic>();

  int statusCode;
  String errorMessage;
  int nItems;

  int bookId;
  String bookName;
  String author;
  String description;
  String category;
  String subCategory;
  int inHotList;
  int status;
  int quantity;
  String bookImage;
  DateTime releasedTime;
  List<double> priceList;


  BooksData.fromResponse(http.Response response) {
    this.statusCode = response.statusCode;
    List jsonData = json.decode(response.body);
    print(jsonData);

    // isbnSet.clear();
    if (isbnSet.contains(deletedBookId)) {
      isbnSet.remove(deletedBookId);
    }

    for (int i = 0; i < jsonData.length; i++) {
      books.add(jsonData[i]["bookName"]);
      authors.add(jsonData[i]["author"]);

      isbnSet.add(jsonData[i]["bookId"]);
      int priceListLen = jsonData[i]["priceList"].length;
      double lastPrice = 0;
      lastPrice += jsonData[i]["priceList"][priceListLen - 1]["price"];
      bool moreThanOne = false;

      prices.add(lastPrice.toStringAsFixed(2));
      img_list.add(jsonData[i]["bookImage"]);
      isbn_list.add(jsonData[i]["bookId"]);
      String inDiscount = jsonData[i]["inDiscount"].toString();


      if (inDiscount =="1" ){
        oldPrice_List.add(jsonData[i]["priceList"][priceListLen - 2]["price"].toString());
        oldPriceList.add(double.parse(jsonData[i]["priceList"][priceListLen - 2]["price"].toString()).toStringAsFixed(2));
      }else{
        oldPrice_List.add("0");
        oldPriceList.add("0");
      }

    }
    //oldPriceList = oldPrice_List ;
    nItems = books.length;
  }

  BooksData.withError(String errorMessage) {
    this.errorMessage = errorMessage;
  }
}
