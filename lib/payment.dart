import 'package:flutter/material.dart';
import 'package:flutter_rave/flutter_rave.dart';

final GlobalKey<FormState> _formkey = GlobalKey<FormState>();


class App extends StatelessWidget {

// This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      color: Colors.red[600],
      theme: ThemeData(primaryColor: Colors.redAccent),
      title: 'Payment',
      debugShowCheckedModeBanner: false,
      home: payment(title: 'Payment', key: null,),
    );
  }
}

class payment extends StatefulWidget {

  payment({required Key key, required this.title}) : super(key: key);
  final String title;

  @override
  _paymentState createState() => _paymentState();
}


class _paymentState extends State<payment> {

  late double amount ;
  late String email;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Payment',style: TextStyle(color: Colors.brown[400],),),
          centerTitle: true,
        ),
        body: Center(
          child:
          ListView(
            children: <Widget>[
              SizedBox(height:10.0),

              Form(
                  key: _formkey,
                  child:
                  Column(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0),
                        child:
                        TextFormField(
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.numberWithOptions(),
                          maxLength: 10,
                          validator: (input){
                            if (input!.isEmpty) {
                              return 'Please Enter an amount ';
                            }
                          },
                          onSaved: (input) => amount = double.parse(input!),
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.attach_money,color: Colors.brown,),
                            labelText: 'amount',
                            hintText: '2000',
                            labelStyle: TextStyle(
                                fontSize: 17.0,
                                fontStyle: FontStyle.normal
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0),
                        child:
                        TextFormField(
                          maxLines: 1,
                          validator: (input){
                            if (input!.isEmpty) {
                              return 'Please enter your email';
                            }
                          },
                          onSaved: (input) => email = input! ,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.email,color: Colors.brown,),
                            labelText: 'email',
                            hintText: 'example19@yahoo.com',
                            hintMaxLines: 1,

                            labelStyle: TextStyle(
                                fontSize: 17.0,
                                fontStyle: FontStyle.normal
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height:300.0),
                      ElevatedButton(
                        onPressed: (){
                          setState(() {
                            var  _validate = true;
                          });

                          final formState = _formkey.currentState;
                          if (formState!.validate()) {
                            formState.save();
                            _pay(context);
                          }
                          // Navigator.of(context).pop();
                        },

                        child: Text('Proceed'),
                      ),
                    ],
                  )
              )

            ],
          ),
        )
    );
  }
  _pay(BuildContext context) {
    final snackBar_onFailure = SnackBar(content: Text('Transaction failed'));
    final snackBar_onClosed = SnackBar(content: Text('Transaction closed'));

    final _rave = RaveCardPayment(
      isDemo: false,
      encKey: "122d7bc0ea5958bf9b8d8a0a",
      publicKey: "FLWPUBK-d7fd8f82f6365d8e0396abcf41de9efe-X",
      transactionRef: "SCH${DateTime.now().millisecondsSinceEpoch}",
      amount: amount ,
      email: email,
      onSuccess: (response) {
        print("$response");
        print("Transaction Successful");
        if (mounted) {
          Scaffold.of(context).showSnackBar(
            SnackBar(
              content: Text("Transaction Sucessful!"),
              backgroundColor: Colors.green,
              duration: Duration(
                seconds: 5,
              ),
            ),
          );
        }
      },
      onFailure: (err) {
        print("$err");
        print("Transaction failed");
        Scaffold.of(context).showSnackBar(snackBar_onFailure);
      },
      onClosed: () {
        print("Transaction closed");
        Scaffold.of(context).showSnackBar(snackBar_onClosed);
      },
      context: context,
    );
    _rave.process();
  }
}