import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class GetDataFromFirebase extends StatefulWidget {
  const GetDataFromFirebase({super.key});

  @override
  State<GetDataFromFirebase> createState() => _GetDataFromFirebaseState();
}

class _GetDataFromFirebaseState extends State<GetDataFromFirebase> {
  late FirebaseFirestore firestore;
  List<Map<String, dynamic>> mylist = [];

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    firestore = FirebaseFirestore.instance;
  }

  @override
  Widget build(BuildContext context) {
    return _mainBody();
  }

  Widget _mainBody() {
    return SafeArea(
      child: Scaffold(
        body: Container(
          width: double.maxFinite,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                child: Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () async {
                          print("get data call");

                          isLoading=true;
                          setState(() {

                          });


                          QuerySnapshot<Map<String, dynamic>> data =
                              await firestore.collection("students").get();
                          mylist.clear();

                          for (int i = 0; i < data.docs.length; i++) {
                            QueryDocumentSnapshot d = data.docs[i];
                            Map<String, dynamic> mydata =
                                d.data() as Map<String, dynamic>;
                            mylist.add(mydata);

                            print("my data : $mydata");
                          }

                          isLoading=false;
                          setState(() {});
                          print("get data done");
                        },
                        child: Expanded(
                          child: Container(
                            child: Text("Get Data Normal"),
                            padding: EdgeInsets.all(20),
                            color: Colors.blueAccent,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: InkWell(
                        onTap: () async {
                          print("get data call for listen");

                          firestore
                              .collection("students")
                              .snapshots(includeMetadataChanges: true)
                              .listen((data) {
                            mylist.clear();
                            for (int i = 0; i < data.docs.length; i++) {
                              QueryDocumentSnapshot d = data.docs[i];
                              Map<String, dynamic> mydata =
                                  d.data() as Map<String, dynamic>;
                              mylist.add(mydata);
                            }
                            setState(() {});
                          });

                          //
                          // QuerySnapshot<Map<String,dynamic>> data=await firestore.collection("students").get();
                          // for(int i=0;i<data.docs.length;i++)
                          // {
                          //   QueryDocumentSnapshot d= data.docs[i];
                          //   Map mydata=d.data() as Map;
                          //   print("my data : $mydata");
                          // }
                          // print("get data done");
                        },
                        child: Container(
                          child: Text("Get Data Listen"),
                          padding: EdgeInsets.all(20),
                          color: Colors.blueGrey,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                  child: isLoading
                      ? SpinKitCircle(
                          color: Colors.blueGrey,
                          size: 30,
                        )
                      : ListView.builder(
                          itemCount: mylist.length,
                          itemBuilder: (ctx, index) {
                            return myItem(mylist[index]);
                          }))
            ],
          ),
        ),
      ),
    );
  }

  Widget myItem(Map<String, dynamic> map) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.grey,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            map["name"],
            style: TextStyle(fontSize: 25),
          ),
          Text(map["field"]),
          Text(map["sem"]),
        ],
      ),
    );
  }
}
