import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:full_screen_image/full_screen_image.dart';
import 'package:http/http.dart' as http;
import 'package:strats360/Screens/single_user.dart';

class USER_LISTING extends StatefulWidget {
  const USER_LISTING({Key? key}) : super(key: key);
  @override
  State<USER_LISTING> createState() => _USER_LISTINGState();
}

class _USER_LISTINGState extends State<USER_LISTING> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getdata();
  }
  List<int> id = [];
  List<String> Email = [];
  List<String> FirstName = [];
  List<String> LastName = [];
  List<String> IMG = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("User Listing")),
      body: ListView.builder(
          itemCount: id.length,
          itemBuilder: (BuildContext context, int index) {
            return InkWell(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>Single_User(id[index])));
              },
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Row(
                      //   children: [
                      //     FullScreenWidget(
                      //       child: CircleAvatar(
                      //       radius: 57,
                      //       backgroundColor: Colors.black26,
                      //       child: CircleAvatar(
                      //       radius: 55,
                      //       backgroundColor: Colors.white,
                      //       child: CircleAvatar(
                      //       radius: 50,
                      //       backgroundImage: NetworkImage(IMG[index]),
                      //       ),
                      //       ),
                      //       ),
                      //     ),
                      //   ],
                      // ),
                      Row(
                        children: [
                          InkWell(
                            onTap: (){
                              _dialogBuilder(IMG[index]);
                            },
                            child: CircleAvatar(
                              radius: 57,
                              backgroundColor: Colors.black26,
                              child: CircleAvatar(
                                radius: 55,
                                backgroundColor: Colors.white,
                                child: CircleAvatar(
                                  radius: 50,
                                  backgroundImage: NetworkImage(IMG[index]),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(width: 10,),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 25.0),
                            child: Text(FirstName[index]+" "+LastName[index],style: TextStyle(fontSize: 18,fontStyle: FontStyle.normal,fontWeight: FontWeight.w500,color: Colors.black),),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 5.0),
                            child: Text(Email[index],style: TextStyle(fontSize: 18,fontStyle: FontStyle.normal,fontWeight: FontWeight.w300,color: Colors.black),),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
    );
  }

  getdata() async {
    String url = "https://reqres.in/api/users?page=2";
    print("URL----->"+url);
    final response = await http.get(Uri.parse(url));
    var DATA = json.decode(response.body);
    var Records = DATA["data"].toString();
    print("recoreds====>"+Records.toString());
    if (response.statusCode == 200) {
      print("SuccessFULLY");
      for(int i=0; i<=Records.toString().length; i++)
        {
          setState(() {
            id.add(DATA["data"][i]["id"]);
            Email.add(DATA["data"][i]["email"]);
            FirstName.add(DATA["data"][i]["first_name"]);
            LastName.add(DATA["data"][i]["last_name"]);
            IMG.add(DATA["data"][i]["avatar"]);
          });
          print("id--->"+id[i].toString());
          print("Email--->"+Email[i].toString());
          print("First--->"+FirstName[i].toString());
          print("Last--->"+LastName[i].toString());
          print("IMG--->"+IMG[i].toString());
        }
      // If the server did return a 200 OK response,
      // then parse the JSON.
     // return Album.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }

  Future<void> _dialogBuilder(String img) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Profile'),
          content: Image.network(img,height: 400,width: 300,fit: BoxFit.cover,),
          actions: <Widget>[
            // TextButton(
            //   style: TextButton.styleFrom(
            //     textStyle: Theme.of(context).textTheme.labelLarge,
            //   ),
            //   child: const Text('Disable'),
            //   onPressed: () {
            //     Navigator.of(context).pop();
            //   },
            // ),
            Center(
              child: TextButton(
                style: TextButton.styleFrom(
                  textStyle: Theme.of(context).textTheme.labelLarge,
                ),
                child: const Text('ok',style: TextStyle(fontSize: 20,color: Colors.black,fontWeight: FontWeight.w600),),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
          ],
        );
      },
    );
  }
}


