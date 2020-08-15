import 'package:bookland/elements/appBar.dart';
import 'package:bookland/elements/bottomNavigatorBar.dart';
import 'package:bookland/services/http_admin.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';


import 'customerProfileUpdate.dart';


class customerPersonalInfo extends StatelessWidget {

  final String customerId;
  customerPersonalInfo({Key key, @required this.customerId}) : super(key: key);

  final HttpAdmin httpAdmin = HttpAdmin();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: MyAppBar(
          pageTitle: "Personal Info",
          loginIcon: false,
          back: false,
          filter_list: false,
          search: false,
        ),
        body: FutureBuilder(
          future: httpAdmin.adminGetCustomerDetails(customerId),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {

              print(snapshot.data.toString());
              return Container(
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                        colors: [Colors.blue.shade400, Colors.white,Colors.blue.shade400])),
                width: double.infinity,
                padding: EdgeInsets.only(top: 20, bottom: 61),
                child: new SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      fullName((snapshot.data.FirstName).toString(),
                          (snapshot.data.customerSurname).toString()),
                      Text("\n"),
                      customerPhotoWidget(),
                      Text("\n"),
                      customerEmail((snapshot.data.customerEmail).toString()),
                      customerPhone((snapshot.data.customerPhone).toString()),
                      customerDoB((snapshot.data.customerDoB).toString()),
                      //customerPassword((snapshot.data.Password).toString()),
                      updateProfileButton(context, snapshot),
                    ],

                  ),
                ),
              );
            } else if (snapshot.hasError) {
              print("Snapshot has error*");
              return Text("${snapshot.error}");
            } else {
              print("datam yok error de yok");
              print(snapshot.data.toString());
              return Center(child: CircularProgressIndicator());
            }
          },
        ),
        bottomNavigationBar: MyBottomNavigatorBar());
  }


  Widget customerPhotoWidget() {
    return Container(
        child: Image.asset(
          'assets/logo.png',
          width: 200,
          height: 200,
        )
    );
  }


  Widget fullName(String text1, String text2) {
    String _customerName = text1;
    String _customerSurname = text2;
    String fullName = text1 + " " + text2;
    return Text(
      fullName,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 30,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget customerIdWidget(String text) {
    return Text(
      '\nID: ' + text,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget customerEmail(String text) {
    return Text(
      'E-mail: ' + text,
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget customerPhone(String text) {
    return Text(
      'Phone: ' + text,
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget customerDoB(String text) {
    return Text(
      'Date Of Birth: ' + text,
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  /*Widget customerPassword(String text) {
    return Text(
      'Password: ' + text,
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    );
  }*/


  Widget updateProfileButton(BuildContext context, AsyncSnapshot snapshot) {
    return new Container(
        margin: EdgeInsets.only(top: 56.0),
        child: new RaisedButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => new CustomerProfileUpdate(snapshot: snapshot),
                ));
          },
          padding: const EdgeInsets.fromLTRB(10.0, 12.0, 10.0, 12.0),
          textColor: Colors.white,
          color: Colors.orange,
          child: const Text('Update Profile', style: TextStyle(fontSize: 20)),
        )
    );
  }
}
