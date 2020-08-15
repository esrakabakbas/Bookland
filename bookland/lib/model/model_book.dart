import 'dart:convert';
import 'dart:ffi';
import 'package:flutter/foundation.dart';

class Book {
  final int bookId;
  final int real_isbn;
  final String bookName;
  final String author;
  String description;
  String category;
  String subCategory;
  int inHotList;
  int status;
  int quantity;
  String bookImage;
  DateTime releasedTime;
  String price ;
  String firstPrice;
  int inDiscount;

  Book({
    this.bookId,
    this.real_isbn,
    this.bookName,
    this.author,
    this.description,
    this.category,
    this.subCategory,
    this.quantity,
    this.inHotList,
    this.status,
    this.bookImage,
    this.releasedTime,
    this.price,
    this.firstPrice,
    this.inDiscount
  });



  factory Book.fromJson(Map<String, dynamic> json) {
    print(json['priceList']);
    int lenOfList =  '{'.allMatches(json['priceList'].toString()).length  ;
    print(lenOfList);
    String real_price = json['priceList'][lenOfList-1]['price'].toString();
    print(real_price);
    String first_price = json['priceList'][0]['price'].toString();
    print(first_price);
    String discountTest = json['inDiscount'].toString();
    print("******");
    print(real_price);
    print(first_price);
    print("******");
    return Book(
        bookId: json['bookId'],
        real_isbn: json['realIsbn'],
        bookName: json['bookName'],
        author: json['author'],
        description: json['description'],
        category: json['category'],
        subCategory: json['subCategory'],
        quantity: json['quantity'],
        inHotList: json['inHotList'],
        status: json['status'],
        bookImage: json['bookImage'],
        price: real_price,
        firstPrice: first_price, //İndirimsiz fiyatı
        inDiscount: json['inDiscount']
    );

  }
}
class Customer_Book_Model {

  final String vote;
  final String inWishlist;
  final Book details;



  Customer_Book_Model({
    this.vote,
    this.inWishlist,
    this.details,
  });


  factory Customer_Book_Model.fromJson(Map<String, dynamic> json) {
    return Customer_Book_Model(
      vote: json['voteRatio'].toString(),
      inWishlist: json['inWishlist'].toString(),
      details : Book.fromJson(json['details'])

    );

  }
}