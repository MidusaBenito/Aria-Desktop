import 'package:ariaquickpay/aria_wallet_stripe_card_topup.dart';
import 'package:ariaquickpay/hero_dialog_route.dart';
import 'package:ariaquickpay/stripe_new_card.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'dart:convert';
import 'package:ariaquickpay/bills_profile.dart';
import 'package:ariaquickpay/models/billers.dart';
import 'package:ariaquickpay/models/category.dart';
import 'package:ariaquickpay/models/models.dart';
import 'package:ariaquickpay/utils.dart';
import 'package:flutter/material.dart' hide Badge;
import 'package:flutter_credit_card/credit_card_widget.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:provider/provider.dart';

import 'aria_providers.dart';
import 'custom_rect_tween.dart';
import 'urls.dart' as myurls;
import 'colors.dart' as mycolor;
import 'package:badges/badges.dart';
import 'my_widgets.dart';
import 'dart:io';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:flutter/src/material/card.dart' as myCard;

class ariaWallet extends StatelessWidget {
  ariaWallet({
    Key? key,
    required this.client,
  }) : super(key: key);
  final Client client;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        client: client,
      ),
      drawer: MyDrawer(
        client: client,
      ),
      bottomNavigationBar: MyBottomBar(
        client: client,
        typeOfB: "wallet",
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: double.infinity,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromRGBO(94, 167, 203, 1),
              Color.fromRGBO(94, 167, 203, 1),
            ],
          ),
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(30.0),
            topLeft: Radius.circular(30.0),
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Column(
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Container(
                        child: Text(
                          "Aria Wallet",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 17,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(),
                      ),
                      Container(
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Text(
                                  "Balance: ",
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                                walletBalance(
                                  client: client,
                                  colString: 'white',
                                ),
                              ],
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(HeroDialogRoute(
                                    builder: (context) {
                                      return enterAmountCard(
                                        client: client,
                                      );
                                    },
                                    settings: RouteSettings(
                                        arguments: "aria-wallet")));
                              },
                              child: Row(
                                children: [
                                  Icon(
                                    const IconData(0xe047,
                                        fontFamily: 'MaterialIcons'),
                                    color: Colors.white,
                                  ),
                                  Text(
                                    "Add Funds",
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
                child: Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color.fromRGBO(238, 236, 236, 1),
                    Color.fromRGBO(238, 236, 236, 1),
                  ],
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Column(
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Text(
                          "Add funds to your Aria Wallet to make payments \nsmooth and easy.",
                          style: TextStyle(fontWeight: FontWeight.w400),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    myCard.Card(
                      color: Colors.white,
                      elevation: 2.0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0)),
                      child: Container(
                        height: 165,
                        width: MediaQuery.of(context).size.width,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15.0),
                          child: Column(
                            children: [
                              SizedBox(
                                height: 20,
                              ),
                              Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("My Aria Wallet Balance",
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500)),
                                    Expanded(child: Container()),
                                    Icon(
                                      const IconData(0xe041,
                                          fontFamily: 'MaterialIcons'),
                                      color: Color.fromRGBO(94, 167, 203, 1),
                                    ),
                                  ]),
                              SizedBox(
                                height: 20,
                              ),
                              Row(
                                children: [
                                  Text(
                                    "Available:",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  walletBalance(
                                    client: client,
                                    colString: 'blue',
                                  ),
                                ],
                              ),
                              ElevatedButton(
                                  onPressed: () {
                                    Navigator.of(context).push(HeroDialogRoute(
                                        builder: (context) {
                                          return enterAmountCard(
                                            client: client,
                                          );
                                        },
                                        settings: RouteSettings(
                                            arguments: "aria-wallet")));
                                  },
                                  child: Text("Add Funds")),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ))
          ],
        ),
      ),
    );
  }
}

class enterAmountCard extends StatefulWidget {
  enterAmountCard({
    Key? key,
    required this.client,
  }) : super(key: key);
  final Client client;
  @override
  State<enterAmountCard> createState() => _enterAmountCardState();
}

class _enterAmountCardState extends State<enterAmountCard> {
  String paymentAmount = '';

  final _myformKey = GlobalKey<FormState>();
  //final String SECRET_KEY =
  //"sk_test_51KhALyCldFfAXs7m9rWzmtbH4Eoz4dQDoUj7aJFp8dOgTNcR5IwOf8UnH8j4SAAPm6rbUn7Tw6YNg835GbquFTZt00k7WxXoBe";
  Map<String, dynamic>? paymentIntent;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Hero(
            tag: 'Payment PopUp',
            createRectTween: (begin, end) {
              return CustomRectTween(begin: begin!, end: end!);
            },
            child: Material(
              color: Colors.white,
              elevation: 2,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(32)),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Please Enter Amount to Pay",
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.w500),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Form(
                        key: _myformKey,
                        child: Column(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: Color.fromARGB(30, 121, 120, 120),
                                borderRadius: new BorderRadius.circular(10.0),
                              ),
                              child: Padding(
                                padding: EdgeInsets.only(
                                    left: 15, right: 15, top: 5),
                                child: TextFormField(
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    labelText: '\$',
                                  ),
                                  //maxLength: 20,
                                  validator: (value) {
                                    if (value != null && value.isNotEmpty) {
                                      value = value.replaceAll(',', '');
                                      value = value.replaceAll('-', '');
                                      value = value.replaceAll(' ', '');
                                      try {
                                        paymentAmount = value;
                                        //print(paymentAmount);
                                      } catch (err) {
                                        //print(err);
                                      }
                                    }
                                  },
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.blueAccent,
                          ),
                          onPressed: () {
                            if (_myformKey.currentState!.validate()) {
                              if (double.parse(paymentAmount) > 0) {
                                //print('okay!!');
                                //makePayment(context);

                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return walletStripeCheckout(
                                        client: widget.client,
                                        paidAmount: paymentAmount,
                                      );
                                    },
                                  ),
                                );
                              } //end if

                            }
                          },
                          child: Text(
                            'Top Up Aria Wallet',
                            style: TextStyle(color: Colors.white),
                          ))
                    ],
                  ),
                ),
              ),
            )),
      ),
    );
  }

  //Future<void> makePayment(context) async {}
}
