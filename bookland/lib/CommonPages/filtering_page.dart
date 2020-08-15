import 'package:flutter/material.dart';
import 'package:bookland/elements/appBar.dart';
import 'package:bookland/CommonPages/filtering_list.dart';

String category_god ="-1";
class FilterStatefulWidget extends StatelessWidget {
  FilterStatefulWidget(String title_category) {
    print("Filteropened");
    print(title_category);
    if(title_category != "Explore"){
      category_god = title_category;
    }else{
      category_god = "-1";
    }
  }

  String filter_author;
  String filter_category;
  String filter_price;


  String chosenCat;


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return

         Scaffold(
          appBar: MyAppBar(
            pageTitle: "Filter Book",
            loginIcon: false,
            back: false,
            filter_list: false,
            search: true,
          ),

          body: Container(

            width: double.infinity,
            padding: EdgeInsets.only(top: 10, bottom: 10),
      child: new SingleChildScrollView(
            child: new Column(
              children: <Widget>[
                new Image.asset('assets/booking/bookback.jpg'),
                new FlatButton(
                  //child: new Text('OK', style: new TextStyle(color: Colors.white)),
                  child: new Text("AUTHOR",style: new TextStyle(color: Colors.white)),
                  color: Colors.green,
                  onPressed:() {
                    _author_display(context);
                  },
                ),
                new FlatButton(

                  //child: new Text('OK', style: new TextStyle(color: Colors.white)),
                  child: new Text("CATEGORY",style: new TextStyle(color: Colors.white)),
                  color: Colors.green,
                  onPressed:() {
                    _category_display(context);
                    /*Navigator.push(


                    context,
                    new MaterialPageRoute(builder: (context) => new Category_Filter()),
                  );*/},
                ),
                new FlatButton(

                  //child: new Text('OK', style: new TextStyle(color: Colors.white)),
                  child: new Text("PRICE" ,style: new TextStyle(color: Colors.white)),
                  color: Colors.green,
                  onPressed:() {
                    _price_display(context);
                    /**Navigator.push(
                      context,
                      new MaterialPageRoute(builder: (context) => new Price_Filter()),
                    );*/
                  },
                ),
                new FlatButton(

                  //child: new Text('OK', style: new TextStyle(color: Colors.white)),
                  child: new Text("APPLY FILTERS" ,style: new TextStyle(color: Colors.white)),
                  color: Colors.purple,
                  onPressed:() { //TODO HTTPS CONNECTION SEND DATA PART
                    print("HTTTPPPP SENDDD");
                        print(filter_author);
                        print(filter_category);
                        print(filter_price);
                    print("HTTTPPPP SENDDD");

                    /*if(widget.filter_author == null){
                      widget.filter_author ="";
                    }if(widget.filter_category == null){
                      widget.filter_category ="";
                    }if(widget.filter_price == null){
                      widget.filter_price ="";
                    }*/
                    String filter_param = "";
                    List<String> selectedList = [filter_author,filter_category,filter_price];
                    for (int i=0;i<3;i++){
                      if(selectedList[i] != null){
                        filter_param =filter_param +"&" + selectedList[i];
                      }
                    }
                    if(filter_param !=""){
                      filter_param = filter_param.substring(1,filter_param.length);
                      filter_param = filter_param.replaceAll(' ', '');
                    }
                    print("SENNDDDDFILTERPARAM");
                    print(filter_param);
                    Navigator.push(
                    context,
                    new MaterialPageRoute(builder: (context) => new Explore_FilteredStateless(-1,filter_param)),
                    );
                    //Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        ));
  }_author_display(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Author_Filter()),
    );
    print("*********RESULT");
    print(result);
    filter_author = result;

  }_category_display(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Category_Filter()),
    );
    print("*********RESULT");
    print(result);
    filter_category = result;

  }_price_display(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Price_Filter()),
    );
    print("*********RESULT");
    print(result);
    filter_price= result;
  }
}


class Price_Filter extends StatefulWidget {
  @override
  Price_FilterState createState() => new Price_FilterState();
}
class Price_FilterState extends State<Price_Filter> {
  GlobalKey<Price_FilterState> paginatorGlobalKey = GlobalKey();
  List<String> selectedList = [];
  Map<String, bool> book_price_dictionary = {"0-10":false, "10-20":false,"20-30":false,"30-40":false,"40-50":false,"50-60":false,"60-70":false,"70-80":false,"80-90":false,"90-100":false,"100-125":false,"125-150":false,"150-175":false,"175-200":false,"200-300":false,"300-400":false,"400-500":false};

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new MyAppBar(pageTitle:  'Price Filter',loginIcon: false,
        back: false,
        filter_list: false,
        search: false,),
      body: new ListView(
        children: book_price_dictionary.keys.map((String key) {
          return new CheckboxListTile(
            title: new Text("\$"+ key),
            value: book_price_dictionary[key],
            onChanged: (bool value) {
              setState(() {
                book_price_dictionary[key] = value;
                if (value){
                  selectedList.add(key);
                  print(selectedList);
                }else{
                  selectedList.remove(key);
                  print(selectedList);
                }
              });
            },
          );
        }).toList(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          var price_list =["100","0"] ;
          String sendValue ="";
          for(int i=0;i<selectedList.length ; i++){
            var str_list =   selectedList[i].toString().split('-');
            if( int.parse(str_list[0]) <  int.parse(price_list[0])){
              //price_list.add( (str_list[0]));
              price_list.removeAt(0);
              price_list.insert(0, str_list[0]);
            } if( int.parse(str_list[1]) >  int.parse(price_list[1])){
              //price_list.add( (str_list[1]));
              price_list.removeAt(1);
              price_list.insert(1, str_list[1]);

            }
            print(price_list);
            sendValue = "minPrice="+ price_list[0] +"&"+"maxPrice=" +price_list[1];
            print(sendValue);
          }
         /** Navigator.push(
            context, new MaterialPageRoute(builder: (context) => new FilterStatefulWidget()),//TO
          );*/Navigator.pop(context,sendValue);
        },
        child: Icon(Icons.done_outline),
      ),
    );
  }
}
class Category_Filter extends StatefulWidget {
  @override
  Category_FilterState createState() => new Category_FilterState();
}

class Category_FilterState extends State<Category_Filter> {
  GlobalKey<Category_FilterState> paginatorGlobalKey = GlobalKey();

  List<String> selectedList = [];
  Map<String, bool> book_dictionary = {
    "Classic Books": false," Crime": false,"Thriller": false,"Fiction": false,"Fantasy": false,"Horror": false,"Romance": false,"Sport": false,"Health": false,"Religion": false,"Biography": false,"Art": false,"Children": false,"Science Fiction": false,"History": false};

  Map<String, bool> control_category(Map<String, bool> book_dictionary){
    if(category_god != "-1"){
      print("CATEGORY vaaar");
      print(category_god);
      book_dictionary[category_god] = true;
    }else{
      print("CATEGORY YOOK");
    }
    return book_dictionary;
  }
  List<String> control_list( List<String> selectedlist,Map<String, bool> book_dictionary ){
    if(category_god != "-1"){

      int control = 0;
      if(book_dictionary[category_god] == true){
       for (int i = 0 ; i< selectedlist.length ; i++){
         if (category_god.toLowerCase() == selectedlist[i]){
           control =1;
         }
       }if(control == 0){
         selectedlist.add(category_god.toLowerCase().replaceAll(" ", ""));
       }
      }
    }return selectedlist;
  }


  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new MyAppBar(pageTitle:  'Category Filter',loginIcon: false,
      back: false,
      filter_list: false,
      search: false,),
      body: new ListView(

        children: (control_category(book_dictionary)).keys.map((String key) {
          return new CheckboxListTile(
            title: new Text(key),
            value: book_dictionary[key],
            onChanged: (bool value) {
              setState(() {
                print("LOOK DICTT ");
                print(book_dictionary);
                book_dictionary[key] = value;
                if (value){
                  selectedList.add(key);
                  print(selectedList);
                }else{
                  selectedList.remove(key);
                  print(selectedList);
                }
              });
            },
          );
        }).toList(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {

         String sendValue = 'categories=';
         selectedList = control_list(selectedList,book_dictionary);
         print("SELECETEDLIST");
         print(selectedList);
         for(int i=0;i<selectedList.length ; i++){
           sendValue = sendValue + selectedList[i].toLowerCase() +",";
           print(sendValue);
         }category_god ="-1";
         sendValue = sendValue.substring(0,(sendValue.length-1));
        /** Navigator.push(
           context, new MaterialPageRoute(builder: (context) => new FilterStatefulWidget(2,sendValue)),//TO
         );*/ Navigator.pop(context,sendValue);
        },
        child: Icon(Icons.done_outline),
      ),
    );

  }
}

class Author_Filter extends StatefulWidget {
  @override
  Author_FilterState createState() => new Author_FilterState();
}

class Author_FilterState extends State<Author_Filter> {
  GlobalKey<Category_FilterState> paginatorGlobalKey = GlobalKey();

  List<String> selectedList = [];
  Map<String, bool> book_dictionary = {
    "J. R. R. Tolkien": false,"Umberto Eco": false,"Alex North": false," David Baldacci": false,"Toshikazu Kawaguchi": false,"J. K. Rowling ": false,"Stephen King": false,"E. L. James": false,"Liane Moriarty": false,"Kobe Bryant": false,"Johann Hari": false,"Christine Watkins": false,"Val Kilmer": false,"Shelley Klein": false,"Giles Andreae": false,"Pablo Hidalgo": false,"George R. R. Martin": false,"Brian Izzard": false,"Kim Hjardar": false,"Brian Izzard": false};

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new MyAppBar(pageTitle:  'Category Filter',loginIcon: false,
      back: false,
      filter_list: false,
      search: false,),
      body: new ListView(
        children: book_dictionary.keys.map((String key) {
          return new CheckboxListTile(
            title: new Text(key),
            value: book_dictionary[key],
            onChanged: (bool value) {
              setState(() {
                book_dictionary[key] = value;
                if (value){
                  selectedList.add(key);
                  print(selectedList);
                }else{
                  selectedList.remove(key);
                  print(selectedList);
                }
              });
            },
          );
        }).toList(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          String sendValue = 'author=';
          for(int i=0;i< selectedList.length ; i++){
            sendValue = sendValue + selectedList[i].toLowerCase().split(" ")[(selectedList[i].toLowerCase().split(" ").length)-1] +","; //TODO .replaceAll(" ", "")
            print(sendValue);
          }
          sendValue = sendValue.substring(0,(sendValue.length-1));
          /** Navigator.push(
              context, new MaterialPageRoute(builder: (context) => new FilterStatefulWidget(2,sendValue)),//TO
              );*/ Navigator.pop(context,sendValue);
        },
        child: Icon(Icons.done_outline),
      ),
    );

  }
}

