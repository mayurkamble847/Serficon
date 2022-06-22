import 'package:expandable/expandable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import '../Modal Classes/ristrictions_model.dart';

class About_Facilities extends StatefulWidget {
  const About_Facilities({Key? key}) : super(key: key);

  @override
  State<About_Facilities> createState() => _About_FacilitiesState();
}

class _About_FacilitiesState extends State<About_Facilities> {
  final titlecontroller = TextEditingController();
  final facilityController = TextEditingController();
  // ignore: deprecated_member_use
  final DatabaseReference reference=FirebaseDatabase.instance.reference();
  late Query _ref;

  void dispose() {
    titlecontroller.dispose();
    facilityController.dispose();
    super.dispose();
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // ignore: deprecated_member_use
    _ref = FirebaseDatabase.instance.reference().child('Users/all_users/${FirebaseAuth.instance.currentUser!.uid}/facilities');
  }

  Future openDialoge() => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Enter Facility'),
          content: SizedBox(
              height: 260,
              child: Column(
                children: [
                  TextField(
                    decoration: const InputDecoration(
                      hintText: "Facility name",
                    ),
                    controller: titlecontroller,
                  ),
                  TextField(
                    decoration:
                        const InputDecoration(hintText: "Facility discription"),
                    controller: facilityController,
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  const Text('For example:-'),
                  const SizedBox(
                    height: 20,
                  ),
                  Card(
                    child: ListTile(
                      title: ExpandablePanel(
                        header: const Text(
                          'Electricity',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        collapsed: const Text(""),
                        expanded: const Text(
                          'We provide free electricity to students.',
                          style: TextStyle(fontSize: 15, color: Colors.grey),
                        ),
                      ),
                    ),
                  )
                ],
              )),
          actions: [
            TextButton(
                onPressed: () {

                  if (facilityController.text.isEmpty ||
                      titlecontroller.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text(
                          'Fill both ....',
                          style: TextStyle(fontSize: 20),
                        ),
                        backgroundColor: Colors.redAccent,
                        elevation: 2,
                        behavior: SnackBarBehavior.floating));
                  } else {
                    var r=Random();
                    var n1=r.nextInt(16);
                    var n2=r.nextInt(15);
                    if(n2>=n1)
                      {
                        n2=n2+1;
                      }
                    Map<String,dynamic> map={'title':titlecontroller.text.toString(),'facility':facilityController.text.toString()};
                    reference.child('Users/all_users/${FirebaseAuth.instance.currentUser!.uid}/facilities').child('facility$n2').update(map).then((value) {
                      reference.child('Users/room_owners/${FirebaseAuth.instance.currentUser!.uid}/facilities').child('facility$n2').update(map);
                    });

                        Navigator.pop(context,false);
                  }
                },
                child: const Text('ADD'))
          ],
        ),
      );

  Widget _buildListView(Map facility) {
    return Card(
        elevation: 2,
        margin: const EdgeInsets.all(12),
        child: ListTile(
            title: ExpandablePanel(
                header: Text(
                  facility['title'],
                  style: const TextStyle(
                      fontSize: 25, color: Colors.black),
                ),
                collapsed: const Text(''),
                expanded: Text(
                  facility['facility'],
                  style: const TextStyle(
                      fontSize: 20, color: Colors.grey),
                ))));
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.green.withOpacity(0.6),
          elevation: 1,
          title: const Text(
            'Facilities',
            style: TextStyle(color: Colors.black, fontSize: 25),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            openDialoge();
          },
        ),
        body: buildHome()

      //],
    );
  }


  Widget buildHome() {
    return FirebaseAnimatedList(
        query: _ref,
        itemBuilder: (BuildContext cotext, DataSnapshot snapshot,
            Animation<double> animation, int index) {
          Map<dynamic, dynamic>? owners = snapshot.value as Map?;
          return _buildListView(owners!);
        });
  }

}
