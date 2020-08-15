import 'dart:convert';
import 'dart:io';
import 'package:bookland/services/globalVariable.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http_auth/http_auth.dart' as http_auth;
import 'package:sprintf/sprintf.dart';
import 'package:bookland/model/error.dart';

import '../model/model_user.dart';

class HttpAdmin {
  Future<String> adminAddBook(String isbn, String book_name,
      String book_category, String book_sub_category, String book_author,
      String book_quantity, String book_hotlist, String book_img,
      String book_description, String book_price) async {
    var client = http.Client();
    var url = "http://10.0.2.2:8080";
    String username = 'Daryl';
    String password = 'WalkingDead';
    String basicAuth =
        'Basic ' + base64Encode(utf8.encode('$username:$password'));
    http.Response response;
    if (book_price == null) {
      response = await http.post('http://10.0.2.2:8080/addBook',
        headers: <String, String>{
          'Authorization': basicAuth,
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'realIsbn': isbn,
          "bookName": book_name,
          "bookImage": "https://dictionary.cambridge.org/tr/images/thumb/book_noun_001_01679.jpg?version=5.0.75",
          "author": book_author,
          "quantity": book_quantity,
          "inHotList": book_hotlist,
          "description": book_description,
          "category": book_category,
          "subCategory": book_sub_category,
        }
        ),
      );
    }
    else {
      response = await http.post('http://10.0.2.2:8080/addBook',
        headers: <String, String>{
          'Authorization': basicAuth,
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'realIsbn': isbn,
          "bookName": book_name,
          "bookImage": "https://dictionary.cambridge.org/tr/images/thumb/book_noun_001_01679.jpg?version=5.0.75",
          "author": book_author,
          "quantity": book_quantity,
          "inHotList": book_hotlist,
          "description": book_description,
          "category": book_category,
          "subCategory": book_sub_category,
          "priceList": [
            {
              "price": book_price
            },
          ],
        }
        ),
      );
    }

    if (response.statusCode < 400) {
      return "PERFECT";
    } else {
      Error msg = Error.fromJson(json.decode(response.body));
      errorControl = true;
      errorMessage = msg.errors[0].toString();
      print(response.body);
      print(msg.errors[0].toString());
      //throw Exception('Failed to load album');
      print("-----" + errorControl.toString());
      return "SORRRY";
    }
  }

  Future<String> adminDeleteBook(String isbn) async {
    var client = http.Client();
    var url = "http://10.0.2.2:8080";
    String username = 'Daryl';
    String password = 'WalkingDead';
    String basicAuth =
        'Basic ' + base64Encode(utf8.encode('$username:$password'));

    http.Response response = await http.delete(
      'http://10.0.2.2:8080/deleteBook/${isbn}',
      headers: <String, String>{
        'Authorization': basicAuth,
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode < 400) {
      return "PERFECT";
    } else {
      errorControl = true;
      errorMessage = "Deleting Book has Failed";
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      throw Exception('Failed to load album');
      return "SORRRY";
    }
  }

  Future<String> adminUpdateBook(String isbn, String book_name,
      String book_author, String book_category, String book_sub_category,
      String book_image, String book_hotlist, String book_quantity,
      String book_price, String book_description) async {
    var client = http.Client();
    var url = "http://10.0.2.2:8080";
    String username = 'Daryl';
    String password = 'WalkingDead';
    String basicAuth =
        'Basic ' + base64Encode(utf8.encode('$username:$password'));
    http.Response response;
    response = await http.put(
      'http://10.0.2.2:8080/updateBook/${isbn}',
      headers: <String, String>{
        'Authorization': basicAuth,
        'Content-Type': 'application/json; charset=UTF-8',
      },

      body: jsonEncode(<String, dynamic>{
        "bookName": book_name,
        "author": book_author,
        "category": book_category,
        "subCategory": book_sub_category,
        "inHotList": book_hotlist,
        "bookImage": book_image,
        "priceList": [
          {
            "price": book_price
          },
        ],
        "description": book_description,
        "quantity": book_quantity
      }
      ),
    );
    print(response.statusCode);
    if (response.statusCode < 400) {
      print(response.body);
      return "PERFECT";
    } else {
      errorControl = true;
      errorMessage = "Updating Book has Failed";
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      //throw Exception('Failed to load album');
      return "SORRRY";
    }
  }

  Future<String> adminDiscountBook(String isbn, String percentage) async {
    var client = http.Client();
    var url = "http://10.0.2.2:8080";
    String username = 'Daryl';
    String password = 'WalkingDead';
    String basicAuth =
        'Basic ' + base64Encode(utf8.encode('$username:$password'));

    /*int intPercentage = int.parse(percentage);
  int intIsbn = int.parse(isbn);*/

    http.Response response = await http.put(
      'http://10.0.2.2:8080/applyDiscount/$isbn/$percentage',
      headers: <String, String>{
        'Authorization': basicAuth,
        'Content-Type': 'application/json; charset=UTF-8',


      },
    );

    if (response.statusCode < 400) {
      errorControl = false;
      return "PERFECT";
    } else {
      errorControl = true;
      return "BADBADBAD";

      errorMessage = "Discounting Book has Failed";
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      throw Exception('Failed to load album');
      return "SORRRY";
    }
  }

  Future<User> adminGetCustomerDetails(String CustomerId) async {
    var client = http.Client();
    var url = "http://10.0.2.2:8080";
    String username = 'Daryl';
    String password = 'WalkingDead';
    String basicAuth =
        'Basic ' + base64Encode(utf8.encode('$username:$password'));
    http.Response response;
    response = await http.get(
        'http://10.0.2.2:8080/getCustomerDetails/$CustomerId',
        headers: <String, String>{
          'Authorization': basicAuth,
          'Content-Type': 'application/json; charset=UTF-8',
        });

    User obj = User.fromJson(json.decode(response.body));
    return obj;
    if (response.statusCode <= 200) {
      print("Müthişş");
    }
  }

  Future<String> adminMakeCampaign(String couponCode,
      String couponDiscount, String campaignName,
      String endDate, String quantity) async {
    var client = http.Client();
    var url = "http://10.0.2.2:8080";
    String username = 'Daryl';
    String password = 'WalkingDead';
    String basicAuth =  'Basic ' + base64Encode(utf8.encode('$username:$password'));
    http.Response response;
    response = await http.post('http://10.0.2.2:8080/addCampaign',
      headers: <String, String>{
        'Authorization': basicAuth,
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        "couponCode": couponCode,
        "couponDiscount": couponDiscount,
        "campaignName": campaignName,
        "endDate": endDate,
        "participantQuantity": quantity
      }


      ),
    );

   // print(response.body);
    if (response.statusCode < 400) {
     // print("Durum ne? İYİ");
      return "PERFECT";
    } else {
     // print("Durum ne? Kötü");
      return "BADBADBAD";
      errorControl = true;
      errorMessage = "Discounting Book has Failed";
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      throw Exception('Failed to load album');
      return "SORRRY";
    }
  }

  Future<String> deactivateCustomer(String customerId) async {
    print("Buralar" + customerId);
    var client = http.Client();
    var url = "http://10.0.2.2:8080";
    String username = 'Daryl';
    String password = 'WalkingDead';
    String basicAuth =  'Basic ' + base64Encode(utf8.encode('$username:$password'));
    http.Response response;
    response = await http.put('http://10.0.2.2:8080/deActivateAccount/$customerId',
      headers: <String, String>{
        'Authorization': basicAuth,
        'Content-Type': 'application/json; charset=UTF-8',
      },

      );

    print("response.body");
    if (response.statusCode < 400) {
      print("Durum ne? İYİ");
      return "PERFECT";
    } else {
      print("Durum ne? Kötü");
      return "BADBADBAD";

    }
  }

  Future<String> activateCustomer(String customerId) async {
    print("Buralar" + customerId);
    var client = http.Client();
    var url = "http://10.0.2.2:8080";
    String username = 'Daryl';
    String password = 'WalkingDead';
    String basicAuth =  'Basic ' + base64Encode(utf8.encode('$username:$password'));
    http.Response response;
    response = await http.put('http://10.0.2.2:8080/activateAccount/$customerId',
      headers: <String, String>{
        'Authorization': basicAuth,
        'Content-Type': 'application/json; charset=UTF-8',
      },

    );

    print("response.body");
    if (response.statusCode < 400) {
      print("Durum ne? İYİ");
      return "PERFECT";
    } else {
      print("Durum ne? Kötü");
      return "BADBADBAD";

    }
  }



}