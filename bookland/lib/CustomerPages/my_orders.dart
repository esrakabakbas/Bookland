import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:io';

import 'package:bookland/elements/appBar.dart';
import 'package:bookland/elements/bottomNavigatorBar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:bookland/CustomerPages/OrderView.dart';
import 'package:bookland/main.dart';

import 'package:flutter_paginator/flutter_paginator.dart';

Map<String, IconData> iconMapping = {
  'Shipped' : Icons.local_shipping,
  'Delivered' : Icons.done_outline,
  'Cancelled' : Icons.cancel,
  'Waiting Confirmation' : Icons.watch_later,
};

int total = 0;
SplayTreeSet orderIDset = new SplayTreeSet();
var globalExploreContext;
int deletedOrderId = -1;
List<String> choosenIcons = [];

String customerid = customerID;

class MyOrders extends StatelessWidget {
  MyOrdersStateless(int orderId) {
    deletedOrderId = orderId;
    if (orderIDset.contains(deletedOrderId)) {
      orderIDset.remove(deletedOrderId);
    }
  }

  @override
  Widget build(BuildContext context) {
    globalExploreContext = context;

  GlobalKey<PaginatorState> paginatorGlobalKey = GlobalKey();


    return Scaffold(
      appBar: MyAppBar(pageTitle: "My Orders",
        loginIcon: true,
        back: false,
        filter_list: false,
        search: true,),
      body: Paginator.listView(
        key: paginatorGlobalKey,
        pageLoadFuture: sendordersDataRequest,
        pageItemsGetter: listordersGetter,
        listItemBuilder: listorderBuilder,
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
              pageLoadFuture: sendordersDataRequest, resetState: true);
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
      var urlorderCount = "http://10.0.2.2:8080/getCustomerOrderCount/$customerid";

      String _urlorderCount = Uri.encodeFull(urlorderCount);
      http.Response responseCount = await http.get(
        _urlorderCount,
        headers: <String, String>{'authorization': basicAuth},
      );

      if (responseCount.statusCode == 200) {
        total = json.decode(responseCount.body);
        print(total);
      } else {
        print(responseCount.statusCode);
        throw Exception("orders are not retrieved!");
      }
    } catch (e) {
      print("SocketException");
      throw Exception(e);
    }
  }

  Future<OrderData> sendordersDataRequest(int page) async {
    try {
      getTotalCount();
      print("CustomerIDDDD");
      print(customerid);
      var url = "http://10.0.2.2:8080/myOrders/$page/10/$customerid";
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
      return OrderData.fromResponse(response);
    } catch (e) {
      if (e is IOException) {
        return OrderData.withError("Please check your internet connection.");
      } else {
        print(e.toString());
        return OrderData.withError("Something went wrong.");
      }
    }
  }

  List<dynamic> listordersGetter(OrderData ordersData) {
    List<dynamic> orderNameList = [];
    List<int> isbnList = [];
    for (int i = 0; i < ordersData.ordersList.length; i++) {
      String val = "Order Date:\t" +
          ordersData.orderdatesList[i] +
          "\n\n" +
          "Order ID:\t" +
          ordersData.ordersList[i].toString() +
          "\n\n" +
          "Total Cost:\t" +
          ordersData.orderpricesList[i] +
          "\n\n" +
          "Order Status:\t" +
          ordersData.orderStatusList[i] + '\n\n' + "|"+   ordersData.ordersList[i].toString() ;
      orderNameList.add(val);
      choosenIcons.add(ordersData.orderStatusList[i].toString());
    }


    return orderNameList;
  }

  Widget loadingWidgetMaker() {
    return Container(
      alignment: Alignment.center,
      height: 160.0,
      child: CircularProgressIndicator(),
    );
  }

  Widget listorderBuilder(value, int index) {
    String choseniconStr = choosenIcons[index].toString();
    print(choseniconStr.toString());
    var value_list = value.toString().split("|");
    String text_part = value_list[0];
    String orderidPar = value_list[1];

    return Card(
        child: ListTile(
        leading: new Icon(iconMapping [choseniconStr], color: Colors.indigo) ,
    title:  Text(text_part),
          onTap: (){
            Navigator.push(
                globalExploreContext,
                MaterialPageRoute(
                  builder: (context) =>new OrderView(orderid : orderidPar),
                ));
          }

    ));
    /*return ListTile(
      //  leading:  Image.network(img_part),

        title: Text(value),
        onTap: () {
          /*Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                // new orderView(isbn: isbnSet.elementAt(index).toString()),
                new orderView(isbn: orderid_send),
              ));*/
        });*/
  }

  Widget errorWidgetMaker(OrderData ordersData, retryListener) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(ordersData.errorMessage),
        ),
        FlatButton(
          onPressed: retryListener,
          child: Text("Retry"),
        )
      ],
    );
  }

  Widget emptyListWidgetMaker(OrderData ordersData) {
    orderIDset.clear();
    ordersData.ordersList.clear();
    ordersData.orderdatesList.clear();
    ordersData.orderpricesList.clear();
    ordersData.ordersadresstitleList.clear();
    ordersData.orderStatusList.clear();
    return Center(
      child: Text("No order"),
    );
  }

  int totalPagesGetter(OrderData ordersData) {
    // TODO This should be fixed
    return total  ;
  }

  bool pageErrorChecker(OrderData ordersData) {
    return ordersData.statusCode != 200;
  }
}

class OrderData {
  List<dynamic> ordersList = new List<dynamic>();
  List<dynamic> orderdatesList = new List<dynamic>();
  List<dynamic> orderpricesList = new List<dynamic>();
  List<dynamic> ordersadresstitleList = new List<dynamic>();
  List<dynamic> orderStatusList = new List<dynamic>();

  int statusCode;
  String errorMessage;
  int nItems;

  String orderId;
  String OrderId;
  String OrderDate;
  String OrderAddress;
  String Status;
  String TotalPrice;

  OrderData.fromResponse(http.Response response) {
    this.statusCode = response.statusCode;
    List jsonData = json.decode(response.body);
    print(jsonData);

    if (orderIDset.contains(deletedOrderId)) {
      orderIDset.remove(deletedOrderId);
    }

    for (int i = 0; i < jsonData.length; i++) {
      ordersList.add(jsonData[i]["orderId"].toString());
      orderdatesList.add(jsonData[i]["orderDate"].toString());
      orderpricesList.add(jsonData[i]["totalAmount"].toString());
      ordersadresstitleList.add(jsonData[i]["addressTitle"].toString());
      orderStatusList.add(jsonData[i]["status"]);
    }

    nItems = ordersList.length;
  }

  OrderData.withError(String errorMessage) {
    this.errorMessage = errorMessage;
  }
}

///////