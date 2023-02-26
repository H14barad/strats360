// ignore_for_file: deprecated_member_use

import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:strats360/Screens/show_data.dart';

class Single_User extends StatefulWidget {
   Single_User(this.Pass_id, {Key? key}) : super(key: key);
   int Pass_id;
  @override
  State<Single_User> createState() => _Single_UserState();
}

class _Single_UserState extends State<Single_User> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getdata_SingleUSer();
  }

  late int id;
  String FirstName = "", LastName = "", Email = "", IMG = "";
  TextEditingController _emailcontroller = TextEditingController();
  TextEditingController _firstcontroller = TextEditingController();
  TextEditingController _lastcontroller = TextEditingController();

  late final fireStore = FirebaseFirestore.instance.collection("Data");


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Single User")),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 10,),
            // CircleAvatar(
            //   radius: 57,
            //   backgroundColor: Colors.black26,
            //   child: CircleAvatar(
            //     radius: 55,
            //     backgroundColor: Colors.white,
            //     child: CircleAvatar(
            //       radius: 50,
            //       backgroundImage: NetworkImage(IMG),
            //     ),
            //   ),
            // ),
            CachedNetworkImage(imageUrl: IMG,
              placeholder: (context, url) => CircularProgressIndicator(),
              errorWidget: (context, url, error) => Icon(Icons.error),
              imageBuilder: (context, imageProvider) => Container(
                height: 125,
                width: 125,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.black26,width: 3),
                    borderRadius: BorderRadius.circular(125 ),
                    image: DecorationImage(
                        image: imageProvider,
                        fit: BoxFit.fill
                    )

                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 15.0),
              child: Text(
                FirstName + " " + LastName,
                style: TextStyle(fontSize: 18,
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.w500,
                    color: Colors.black),),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 5.0),
              child: Text(Email, style: TextStyle(
                  fontSize: 18,
                  fontStyle: FontStyle.normal,
                  fontWeight: FontWeight.w300,
                  color: Colors.black),),
            ),
            SizedBox(height: 20,),
            Divider(color: Colors.grey,thickness: 1,),
            SizedBox(height: 100,),
            Text("Enter details for Add data",style: TextStyle(fontSize: 21),),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  TextFormField(
                    controller: _emailcontroller,
                    decoration: InputDecoration(labelText: "Email",
                      // enabledBorder: OutlineInputBorder(
                      //   borderSide: BorderSide(
                      //       width: 3, color: Colors.black26), //<-- SEE HERE
                      // ),
                    ),
                  ),
                  SizedBox(height: 8,),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _firstcontroller,
                          decoration: InputDecoration(labelText: "First Name",
                          ),
                        ),
                      ),
                      SizedBox(width: 10,),
                      Expanded(
                        child: TextFormField(
                          controller: _lastcontroller,
                          decoration: InputDecoration(labelText: "Last Name",
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 10,),
            Padding(
             padding: const EdgeInsets.only(left: 20.0,right: 20.0),
             child: Row(
               mainAxisAlignment: MainAxisAlignment.spaceBetween,
               children: [
                 OutlinedButton(
                  child: Text("Add data"),
                  style: OutlinedButton.styleFrom(
                    primary: Colors.green,
                    side: BorderSide(
                      color: Colors.green,
                    ),
                  ),
                  onPressed: () {
                    Create_DB();
                    Navigator.push(context, MaterialPageRoute(builder: (context)=> DATA("add")));
                    final snackBar = SnackBar(
                    content: const Text('Success data insert...'),
                      backgroundColor: (Colors.black12),
                      action: SnackBarAction(
                      label: 'ok',
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      ),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      },),
                 OutlinedButton(
                  child: Text("Go to Edit data"),
                  style: OutlinedButton.styleFrom(
                    primary: Colors.brown,
                    side: BorderSide(
                      color: Colors.brown,
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>DATA("edit")));
                    //final snackBar = SnackBar(
                    // content: const Text('Data Update Successfully...'),
                    // backgroundColor: (Colors.black12),
                    // action: SnackBarAction(
                    // label: 'ok',
                    // onPressed: () {
                    // Navigator.pop(context);
                    // },
                    // ),
                    // );
                    // ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    },),

                 OutlinedButton(
                  child: Text("Go to Delete data"),
                  style: OutlinedButton.styleFrom(
                    primary: Colors.red,
                    side: BorderSide(
                      color: Colors.red,
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>DATA("delete")));
                    _firstcontroller.text = "";
                    // final snackBar = SnackBar(
                    //   content: const Text('Data Deleted Successfully...'),
                    //   backgroundColor: (Colors.black12),
                    //   action: SnackBarAction(
                    //     label: 'ok',
                    //     onPressed: () {
                    //       Navigator.pop(context);
                    //     },
                    //   ),
                    // );
                    // ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  },
                 ),
               ],
             ),
           ),
          ],
        ),
      ),
    );

  }

  Create_DB(){
    // _dbref.child("Data").set({"firstname": _firstcontroller.text, "lastname":_lastcontroller.text,"email":_emailcontroller.text,"img":IMG});

     String id = DateTime.now().millisecondsSinceEpoch.toString();
    fireStore.doc(id).set({
      "id": id,
      "email": _emailcontroller.text,
      "firstname": _firstcontroller.text,
      "lastname": _lastcontroller.text,
      //"img": IMG
      "img": "https://pbs.twimg.com/media/FJ96vOQWUAwbIah.jpg:large"
    }).then((value){
      _emailcontroller.text = "";
      _firstcontroller.text = "";
      _lastcontroller.text = "";
      print("---------------success-----------------");
    }).onError((error, stackTrace){ print("---------------ERROR-----------------"); });
  }

  getdata_SingleUSer() async {
    String url = "https://reqres.in/api/users/" + widget.Pass_id.toString();
    print("URL_SINGLEUSER----->" + url);
    final response = await http.get(Uri.parse(url));
    var DATA = json.decode(response.body);
    var Records = DATA["data"].toString();
    print("recoreds====>" + Records.toString());
    if (response.statusCode == 200) {
      print("SuccessFULLY");

      setState(() {
        id = DATA["data"]["id"];
        Email = DATA["data"]["email"];
        FirstName = DATA["data"]["first_name"];
        LastName = DATA["data"]["last_name"];
        IMG = DATA["data"]["avatar"];
        _emailcontroller.text = Email;
        _firstcontroller.text = FirstName;
        _lastcontroller.text = LastName;
      });
      print("id--->" + id.toString());
      print("Email--->" + Email.toString());
      print("First--->" + FirstName.toString());
      print("Last--->" + LastName.toString());
      print("IMG--->" + IMG.toString());
      // If the server did return a 200 OK response,
      // then parse the JSON.
      // return Album.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }

}