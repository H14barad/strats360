import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DATA extends StatefulWidget {

   DATA(this.Opration, {Key? key}) : super(key: key);
   String Opration = '';
  @override
  State<DATA> createState() => _DATAState();
}
final ReadfireStore = FirebaseFirestore.instance.collection("Data").snapshots();
class _DATAState extends State<DATA> {
  TextEditingController _emailcontroller = TextEditingController();
  TextEditingController _firstcontroller = TextEditingController();
  TextEditingController _lastcontroller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: widget.Opration=="edit"?widget.Opration=="delete"?Text("Added Data",style: TextStyle(
          fontStyle: FontStyle.italic
        ),):Text("Update",style: TextStyle(
          fontStyle: FontStyle.italic
      ),):Text("Delete",style: TextStyle(
            fontStyle: FontStyle.italic
        ),)
      ),
      body:   StreamBuilder<QuerySnapshot>(
          stream: ReadfireStore,
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
            if(snapshot.connectionState == ConnectionState.waiting)
              return CircularProgressIndicator();
            if(snapshot.hasError)
              return Text("having some error!!!");

            return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index){
                  //print("Chequed----------->"+snapshot.data!.docs[index].get('email').toString());
                  print("Chequed----------->"+snapshot.data!.docs[index]['firstname'].toString());
                  var D = snapshot.data!.docs[index];
                  return
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 40,
                                backgroundImage: NetworkImage(D["img"]),
                              ),
                            ],
                          ),
                          SizedBox(width: 10,),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 25.0),
                                child: Text(D["firstname"].toString() +" "+ D["lastname"].toString(),style: TextStyle(fontSize: 18,fontStyle: FontStyle.normal,fontWeight: FontWeight.w500,color: Colors.black),),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 5.0),
                                child: Text(D["email"],style: TextStyle(fontSize: 18,fontStyle: FontStyle.normal,fontWeight: FontWeight.w300,color: Colors.black),),
                              ),
                            ],
                          ),
                          Spacer(),
                          Row(
                            children: [
                              InkWell(
                                  onTap: (){
                                    Delete(D["id"]);
                                  },
                                  child: widget.Opration=="delete"?Icon(Icons.delete):Container()),
                              InkWell(
                                  onTap: (){
                                    _lastcontroller.text="";
                                    _firstcontroller.text="";
                                    _emailcontroller.text="";
                                    GetUsertDataForUpdate(D["id"]);
                                  },
                                  child: widget.Opration=="edit"?Icon(Icons.edit):Container()),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                });
          }
      ),
    );
  }
  Delete(id){
    //_dbref.child("user_data").remove().;
    FirebaseFirestore.instance.collection("Data").doc(id).delete();
  }
  void Update(id) {
    FirebaseFirestore.instance.collection("Data").doc(id).update({
      "email": _emailcontroller.text,
      "firstname":_firstcontroller.text,
      "lastname":_lastcontroller.text
    });
  }
  Future<void> GetUsertDataForUpdate(String id) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Userdata'),
          content: Column(
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
              TextFormField(
                controller: _firstcontroller,
                decoration: InputDecoration(labelText: "First Name",
                ),
              ),
              SizedBox(height: 8,),
              TextFormField(
                controller: _lastcontroller,
                decoration: InputDecoration(labelText: "Last Name",
                ),
              ),
            ],
          ),
          actions: <Widget>[
            Center(
              child: TextButton(
                style: TextButton.styleFrom(
                  textStyle: Theme.of(context).textTheme.labelLarge,
                ),
                child: const Text('ok',style: TextStyle(fontSize: 20,color: Colors.black,fontWeight: FontWeight.w600),),
                onPressed: () {
                  Update(id);
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        );
      },
    );
  }
}

