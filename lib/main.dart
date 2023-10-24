import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:irunerrands_user/payment.dart';
import 'package:irunerrands_user/rejectederruser.dart';

import  'Add_Errands.dart' ;
import 'Added_Errands.dart';
import 'Profile.dart';
import 'authscreens/User_info.dart';
import 'authscreens/Welcome.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MyApp());
}

User? status;
class MyApp extends StatefulWidget {

  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    super.initState();
    signInStatus().whenComplete((){
     setState(() {

     });

    });
  }

  signInStatus() async{
    try{
      FirebaseAuth.instance.authStateChanges().listen((User? user) {status = user;}) ;
    }
    catch(e){
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      theme:  ThemeData(
        primaryColor: Colors.black,
      ),
      home:
      StreamBuilder(
      builder:  (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
    if(status == null){
    return WelcomePage();
    }
    else return HomePage('title');
    }, stream: null,
      ),
      routes: <String, WidgetBuilder>{

      "/a": (BuildContext context) =>  Profile("new page"),
      "/b": (BuildContext context) => HomePage("new page"),
      "/c": (BuildContext context) => Add_Errands("new page"),
      "/d": (BuildContext context) => Added_Errands("title", title: '',),
      "/g":(BuildContext context) =>  payment(),
    },
    );
  }

}


late String userInfoId;

class HomePage extends StatefulWidget {


  final String title;
  HomePage(this.title);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final FirebaseAuth _auth = FirebaseAuth.instance;
  User user;

  final FirebaseMessaging _fcm = FirebaseMessaging.instance;

  String? get title => null;

  @override
  void initState() {
    super.initState();
    _fcm.configure(
      onMessage:(Map<String, dynamic>message) async{
        print('onMessage: $message');
        showDialog(context: context,
            builder: (context) => AlertDialog(
              content: ListTile(
                title: Text(message['notification']['title'],
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(message['notification']['body']),
              ),
              actions: <Widget>[
                Row(
                  children: <Widget>[
                    ElevatedButton(onPressed: onPressed, child: child)Button(onPressed: ()=> Navigator.of(context).pop(),
                        child:Text('OK')
                    ),
                    SizedBox(height: 35.0,)
                  ],
                ),
              ],
            )
        );
      },
      onResume:(Map<String, dynamic>message) async{
        print('onResume: $message');
        Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => Added_Errands(title!, title: '',)));

      },

      onLaunch:(Map<String, dynamic>message) async{
        print('onLaunch: $message');
        Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => Added_Errands(title!, title: '',)));
      },
    );
    initUser();
  }
  initUser() async{
    user = await _auth.currentUser!;
  }

 late String userID,uid;


  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Color(0xFF5D4037),
        appBar: AppBar(
          title:
          Text("iRunErrands", style: TextStyle(fontSize: 13.0,color:  Colors.brown[400])),
          centerTitle: true,
        ),

        drawer: Drawer(

          child: ListView(
            children: <Widget>[
              UserAccountsDrawerHeader(
                currentAccountPicture: CircleAvatar(
                  backgroundColor: Color(0xff8D6E63),
                  child: Icon(Icons.person),
                ),
                accountEmail: Text('${user?.email}'),
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: <Color>[
                    Colors.brown,
                    Colors.brown,
                  ]
                  ),
                ), accountName: null,
              ),
              ListTile(
                leading: Icon(Icons.home,
                  color: Colors.brown,
                ),
                title: Text('Home', style: TextStyle(
                    fontSize: 17.0, fontStyle: FontStyle.normal),),
                onTap: () => Navigator.of(context).pushNamed('/b'),
              ),
              ListTile(
                title: Text('Profile', style: TextStyle(
                    fontSize: 17.0, fontStyle: FontStyle.normal),),
                leading: Icon(Icons.person,
                  color: Colors.brown,),
                onTap: () => Navigator.of(context).pushNamed('/a'),
              ),
              ListTile(
                title: Text('My Errands', style: TextStyle(
                    fontSize: 17.0, fontStyle: FontStyle.normal),),
                leading: Icon(Icons.border_color, color: Colors.brown,),
                onTap: () => Navigator.of(context).pushNamed('/d'),

              ),
              ListTile(
                title: Text('Add Errands', style: TextStyle(
                    fontSize: 17.0, fontStyle: FontStyle.normal),),
                leading: Icon(Icons.add, color: Colors.brown,),
                onTap: () => Navigator.of(context).pushNamed('/c'),
              ),
              ListTile(
                title: Text('Payment', style: TextStyle(
                    fontSize: 17.0, fontStyle: FontStyle.normal),),
                leading: Icon(Icons.payment, color: Colors.brown,),
                onTap: () => Navigator.of(context).pushNamed('/g'),
              ),
              ListTile(
                  title: Text('Close', style: TextStyle(
                      fontSize: 17.0, fontStyle: FontStyle.normal),),
                  leading: Icon(Icons.close, color: Colors.brown,),
                  onTap: () => Navigator.of(context).pop()
              ),
              Divider(
                height: 20.0,
              ),

              ListTile(
                title: Text('Sign out', style: TextStyle(
                    fontSize: 17.0, fontStyle: FontStyle.normal),),
                onTap: _signOut,
              ),


            ],
          ),
        ),
        body: ListView(
            children: <Widget>[

              Container(
                child: FutureBuilder(
                    future: FirebaseAuth.instance.currentUser!,
                    builder: (context,AsyncSnapshot<FirebaseUser> snapshot){
                      if (snapshot.connectionState==ConnectionState.done) {
                        userID = snapshot.data.uid;
                        _userDetails(userID);
                        if (userID != null) {
                          return  StreamBuilder(
                              stream: Firestore.instance.collection('User_information').where('userId', isEqualTo: userID)
                                  .snapshots(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return Center(
                                      child: CircularProgressIndicator(
                                        backgroundColor: Colors.brown,
                                      )
                                  );
                                }
                                else
                                  var documents;
                                  return ListView.builder(
                                      itemCount: snapshot.data?.documents.length,
                                      itemBuilder: (context, index) {
                                        return ListTile(
                                            title:
                                            Row(
                                                children: <Widget>[
                                                  Padding(
                                                    padding: EdgeInsets.only(left: 15.0,right: 5.0,top: 57.0,bottom: 1.0),
                                                    child: Text('Hello',style: TextStyle(fontSize: 25.0,),
                                                    ),
                                                  ),
                                                  Padding(
                                                      padding: EdgeInsets.only(left: 3.0,right: 5.0,top: 57.0,bottom: 1.0),
                                                      child: Text(snapshot.data.documents[index]['Name'] + ',',
                                                        style: TextStyle(
                                                            fontWeight: FontWeight.bold,
                                                            fontSize: 25.0
                                                        ),
                                                      )
                                                  )
                                                ]
                                            ),
                                            subtitle:
                                            Padding(
                                              padding: EdgeInsets.only(left:15.0),
                                              child: Text('we are at your service. ',
                                                style: TextStyle(
                                                    fontSize: 17,
                                                    fontWeight: FontWeight.w400,
                                                    fontStyle: FontStyle.italic
                                                ),),
                                            )
                                        );

                                      }
                                  );
                              }
                          );
                        }
                      }
                    }
                ),
                decoration: BoxDecoration(
                    image: DecorationImage(
                        fit: BoxFit.contain,
                        colorFilter: ColorFilter.mode(Colors.transparent.withOpacity(0.2), BlendMode.dstATop),
                        image:
                        AssetImage('assets/icons/3750360.jpg')
                    ),
                    shape: BoxShape.rectangle,
                    color: const Color(0xff7c94b6),
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(90.0),
                      bottomRight: Radius.circular(10.0),
                      bottomLeft: Radius.circular(90.0),
                    ),
                    border: Border(
                    )
                ),
                height: 200.0,
              ),
              SizedBox(height:50.0),
              Container
                (
                padding: EdgeInsets.only(right: 15.0,left: 15),
                width: MediaQuery.of(context).size.width - 30.0,
                height: MediaQuery.of(context).size.height - 100.0,
                child: GridView.count(crossAxisCount: 2,
                    primary: false,
                    crossAxisSpacing: 10.0,
                    mainAxisSpacing: 15.0,
                    childAspectRatio: 0.7,
                    children: <Widget>[
                      InkWell(
                        onTap: () =>  Navigator.push(
                            context, MaterialPageRoute(builder: (context) =>Added_Errands(title))),
                        child:
                        _buildCard('errands',
                            'assets/icons/3411092.jpg',
                            context),
                      ),
                      InkWell(
                        onTap: () =>  Navigator.push(
                            context, MaterialPageRoute(builder: (context) =>accepterrd_user(title))),
                        child:
                        _buildCard('active errands',
                            'assets/icons/Delivery-Cristina.jpg',
                            context),
                      ),
                      InkWell(
                        onTap: () =>  Navigator.push(
                            context, MaterialPageRoute(builder: (context) =>rejected_user(title))),
                        child:
                        _buildCard('rejected errands',
                            'assets/icons/4003625.jpg',
                            context),
                      ),
                      InkWell(
                          onTap: () =>  Navigator.push(
                              context, MaterialPageRoute(builder: (context) =>completed_user(title))),
                          child:
                          _buildCard('completed errands',
                              'assets/icons/completed.jpg',
                              context)
                      )
                    ]

                ),
              )
            ]
        )
    );
  }

  Future<void> _signOut() async{
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => WelcomePage()));
    } catch (e) {
      print(e); // TODO: show dialog with error
    }
  }

  void openAdmin() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => admin_Home(title)));
  }

  Widget _buildCard(String name,String imgPath, context) {
    return Padding(
        padding: EdgeInsets.only(top: 5.0, bottom: 5.0, left: 5.0, right: 5.0),
        child:
        Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30.0),
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 3.0,
                      blurRadius: 3.0)
                ],
                color: Colors.white),
            child: Column(
                children: [
                  Hero(
                      tag: imgPath,
                      child: Container(
                          height: 183.0,
                          width: 140.0,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage(imgPath),
                                  fit: BoxFit.contain)))),
                  SizedBox(height: 6.0),
                  Text(name, style: TextStyle(
                      color: Colors.black,
                      fontSize: 14.0)),
                ]
            )
        )

    );
  }
}

