import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:serficon/Bottom_nav/room_owner_profile_to_visit.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

// ignore: deprecated_member_use
String idFromRoomOwnerList = '';

class _HomeState extends State<Home> {
  late Query _ref;
  var url;


   getProfileImage(String id)  {
     var image;
     FirebaseDatabase.instance
        // ignore: deprecated_member_use
        .reference()
        .child(
        'Users/room_owners/$id/profile_image')
        .once()
        .then((value) {
      setState(() {
        url = value.snapshot.value;
         if(url==null)
           {
             image= AssetImage('assets/images/profile_png.jpg');
           }
         else
           {
             image= NetworkImage(url);
           }
      });
    });

     return image;
  }
  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    // ignore: deprecated_member_use
    //getProfileImage();
    _ref = FirebaseDatabase.instance.reference().child('Users/room_owners');
  }

  Widget _buildListView(Map owners) {
    return owners.isNotEmpty
        ? Card(
            elevation: 2,
            child: Container(
              margin: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: Colors.blueAccent.withOpacity(0.2),
                  border: Border.all(color: Colors.black, width: 1),
                  borderRadius: BorderRadius.circular(10)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    margin: const EdgeInsets.all(10),
                    child: ListTile(
                      title: Text(
                          '${owners['first_name']} ${owners['last_name']}'),
                      leading: CircleAvatar(
                        radius: 30,
                        backgroundImage:
                            getProfileImage(owners['id'])
                      ),
                      trailing: Container(
                        margin: const EdgeInsets.only(right: 10, bottom: 2),
                        child: ElevatedButton(
                          onPressed: () {
                            print(owners.keys);
                            setState(() {
                              idFromRoomOwnerList = owners['id'];
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const OwnerProfileToVisit()));
                            });
                          },
                          child: const Text('View this'),
                        ),
                      ),
                    ),
                  ),
                  ListTile(
                    leading: const Icon(
                      Icons.location_on_rounded,
                      color: Colors.red,
                    ),
                    title: Text(
                      owners['location'],
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ),
                ],
              ),
            ),
          )
        : Container(
            margin: const EdgeInsets.only(left: 10),
            child: const Center(
              child: Text(
                'Soory for the inconvenience\n but no owner has provided the information yet...',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey, fontSize: 25),
              ),
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: Colors.orangeAccent.withOpacity(.4),
        title: Text(
          'Available room owners',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: buildHome(),
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
