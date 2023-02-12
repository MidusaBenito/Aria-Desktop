//import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:flutter_credit_card/credit_card_brand.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:ariaquickpay/bill_checkout.dart';
import 'package:ariaquickpay/card_options.dart';
import 'package:ariaquickpay/pay_via_aria_wallet.dart';
import 'package:ariaquickpay/stripe_new_card.dart';
//import 'package:ariaquickpay/stripe_web_view.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'dart:convert';
import 'package:ariaquickpay/bills_profile.dart';
import 'package:ariaquickpay/models/billers.dart';
import 'package:ariaquickpay/models/category.dart';
import 'package:ariaquickpay/models/models.dart';
import 'package:ariaquickpay/utils.dart';
import 'package:flutter/material.dart' hide Badge;
import 'package:http/http.dart';
import 'package:provider/provider.dart';
//import 'package:snippet_coder_utils/FormHelper.dart';
import 'aria_providers.dart';
import 'urls.dart' as myurls;
import 'colors.dart' as mycolor;
import 'package:badges/badges.dart';
import 'my_widgets.dart';
import 'dart:io';
import 'custom_rect_tween.dart';
import 'hero_dialog_route.dart';

class stripeCheckout extends StatefulWidget {
  const stripeCheckout({
    super.key,
    required this.client,
    required this.billerName,
    required this.billerId,
    required this.firstName,
    required this.lastName,
    required this.billingAccntNumber,
    required this.paidAmount,
  });
  final Client client;
  final String billerName;
  final String billerId;
  final String firstName;
  final String lastName;
  final String billingAccntNumber;
  final String paidAmount;

  @override
  State<stripeCheckout> createState() => _stripeCheckoutState();
}

class _stripeCheckoutState extends State<stripeCheckout> {
  String cardNumber = '';
  String expiryDate = '';
  String cardHolderName = '';
  String cvvCode = '';
  bool isCvvFocused = false;
  bool useGlassMorphism = false;
  bool useBackgroundImage = false;
  OutlineInputBorder? border;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    border = OutlineInputBorder(
      borderSide: BorderSide(
        color: Colors.grey.withOpacity(0.7),
        width: 2.0,
      ),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: double.infinity,
            alignment: Alignment.center,
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color.fromRGBO(94, 167, 203, 1),
                        Color.fromRGBO(94, 167, 203, 1),
                      ],
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            BackButton(
                              color: Colors.white,
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return BillsProfile(
                                          client: widget.client);
                                    },
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            SizedBox(
                              width: 15,
                            ),
                            Text(
                              'Pay ${widget.billerName}',
                              overflow: TextOverflow.ellipsis,
                            ),
                            Expanded(child: Container()),
                            //Text('Bill Due On: '),
                            SizedBox(
                              width: 15,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                    child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color.fromRGBO(238, 236, 236, 1),
                        Color.fromRGBO(238, 236, 236, 1),
                      ],
                    ),
                  ),
                  width: double.infinity,
                  alignment: Alignment.topCenter,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: Column(
                      children: [
                        //SizedBox(
                        //height: 10,
                        //),
                        SizedBox(
                          width: 600,
                          child: Container(
                            child: Column(
                              children: [
                                const SizedBox(
                                  height: 10,
                                ),
                                CreditCardWidget(
                                  textStyle: TextStyle(
                                      fontSize: 12, color: Colors.white),
                                  height: 150,
                                  width: 350,
                                  //glassmorphismConfig: useGlassMorphism
                                  //? Glassmorphism.defaultConfig()
                                  // : null,
                                  cardNumber: cardNumber,
                                  expiryDate: expiryDate,
                                  cardHolderName: cardHolderName.toUpperCase(),
                                  cvvCode: cvvCode,
                                  //bankName: 'Axis Bank',
                                  showBackView: isCvvFocused,
                                  obscureCardNumber: true,
                                  obscureCardCvv: true,
                                  isHolderNameVisible: true,
                                  cardBgColor: Color.fromARGB(255, 134, 43, 37),
                                  //backgroundImage: useBackgroundImage
                                  //? 'assets/card_bg.png'
                                  // : null,
                                  isSwipeGestureEnabled: true,
                                  onCreditCardWidgetChange:
                                      (CreditCardBrand creditCardBrand) {},
                                  customCardTypeIcons: <CustomCardTypeIcon>[
                                    CustomCardTypeIcon(
                                      cardType: CardType.mastercard,
                                      cardImage: Image.asset(
                                        'assets/images/mastercard.png',
                                        height: 48,
                                        width: 48,
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    CreditCardForm(
                                      formKey: formKey,
                                      obscureCvv: true,
                                      obscureNumber: true,
                                      cardNumber: cardNumber,
                                      cvvCode: cvvCode,
                                      isHolderNameVisible: true,
                                      isCardNumberVisible: true,
                                      isExpiryDateVisible: true,
                                      cardHolderName: cardHolderName,
                                      expiryDate: expiryDate,
                                      themeColor: Colors.blue,
                                      textColor: Colors.black,
                                      cardNumberDecoration: InputDecoration(
                                        labelText: 'Card Number',
                                        hintText: 'XXXX XXXX XXXX XXXX',
                                        hintStyle:
                                            const TextStyle(color: Colors.grey),
                                        labelStyle: const TextStyle(
                                            color: Colors.black),
                                        focusedBorder: border,
                                        enabledBorder: border,
                                      ),
                                      expiryDateDecoration: InputDecoration(
                                        hintStyle:
                                            const TextStyle(color: Colors.grey),
                                        labelStyle: const TextStyle(
                                            color: Colors.black),
                                        focusedBorder: border,
                                        enabledBorder: border,
                                        labelText: 'Expired Date',
                                        hintText: 'XX/XX',
                                      ),
                                      cvvCodeDecoration: InputDecoration(
                                        hintStyle:
                                            const TextStyle(color: Colors.grey),
                                        labelStyle: const TextStyle(
                                            color: Colors.black),
                                        focusedBorder: border,
                                        enabledBorder: border,
                                        labelText: 'CVV',
                                        hintText: 'XXX',
                                      ),
                                      cardHolderDecoration: InputDecoration(
                                        hintStyle:
                                            const TextStyle(color: Colors.grey),
                                        labelStyle: const TextStyle(
                                            color: Colors.black),
                                        focusedBorder: border,
                                        enabledBorder: border,
                                        labelText: 'Card Holder',
                                      ),
                                      onCreditCardModelChange:
                                          onCreditCardModelChange,
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                        ),
                                        backgroundColor:
                                            const Color(0xff1b447b),
                                      ),
                                      child: Container(
                                        margin: const EdgeInsets.all(12),
                                        child: Text(
                                          'Pay \$${widget.paidAmount}',
                                          style: TextStyle(
                                            color: Colors.white,
                                            //fontFamily: 'halter',
                                            fontSize: 13,
                                            package: 'flutter_credit_card',
                                          ),
                                        ),
                                      ),
                                      onPressed: () async {
                                        if (formKey.currentState!.validate()) {
                                          cardNumber =
                                              cardNumber.replaceAll(' ', '');
                                          //print(cardNumber);
                                          List<String> expiryList =
                                              expiryDate.split("/");
                                          //print(expiryList[1]);
                                          //print(cvvCode);
                                          String cardCharge =
                                              await payViaCardDesktop(
                                                  widget.billerId,
                                                  widget.lastName,
                                                  widget.firstName,
                                                  widget.billingAccntNumber,
                                                  widget.paidAmount,
                                                  cardNumber,
                                                  expiryList[0],
                                                  expiryList[1],
                                                  cvvCode);
                                          if (cardCharge == 'succeeded') {
                                            //print(cardCharge);
                                            Navigator.of(context,
                                                    rootNavigator: true)
                                                .pop();
                                            showDialog(
                                                barrierDismissible: true,
                                                context: context,
                                                builder: (_) => AlertDialog(
                                                      content: Column(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: [
                                                          Row(
                                                            children: [
                                                              Text(
                                                                  "${widget.billerName} Payment Successful",
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .green,
                                                                      fontSize:
                                                                          11)),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    )).then((val) {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) {
                                                    return BillsProfile(
                                                        client: widget.client);
                                                  },
                                                ),
                                              );
                                            });
                                          } else {
                                            //print(cardCharge);
                                            Navigator.of(context,
                                                    rootNavigator: true)
                                                .pop();
                                            showDialog(
                                                barrierDismissible: true,
                                                context: context,
                                                builder: (_) => AlertDialog(
                                                      content: Column(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: [
                                                          Row(
                                                            children: [
                                                              Text(
                                                                  "Payment unsuccessful, please try again!",
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .redAccent,
                                                                      fontSize:
                                                                          11)),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ));
                                          }
                                        } else {
                                          //print('invalid!');
                                        }
                                      },
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                  ],
                                ),
                              ],
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
        ),
      ),
    );
  }

  void onCreditCardModelChange(CreditCardModel? creditCardModel) {
    setState(() {
      cardNumber = creditCardModel!.cardNumber;
      expiryDate = creditCardModel.expiryDate;
      cardHolderName = creditCardModel.cardHolderName;
      cvvCode = creditCardModel.cvvCode;
      isCvvFocused = creditCardModel.isCvvFocused;
    });
  }

  Future<String> payViaCardDesktop(
      String billId,
      String lastName,
      String firstName,
      String billingAccnt,
      String paidAmount,
      String cardNumber,
      String expiryMonth,
      String expiryYear,
      String cardCVC) async {
    List<stripeCard> get_charge_response = [];
    final url = myurls.AriaApiEndpoints.stripeCardDesktopApi;
    final userToken = UserSimplePreferences.getUserToken() ?? '';
    if (userToken != '') {
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (_) => AlertDialog(
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: const [
                        SizedBox(
                          child: CircularProgressIndicator(
                            strokeWidth: 3.0,
                          ),
                          width: 10,
                          height: 10,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text("Processing payment ...",
                            style: TextStyle(fontSize: 11)),
                      ],
                    ),
                  ],
                ),
              ));
      //print("working");
      var stripeCardPayResponse = await widget.client.post(
        Uri.parse(url),
        headers: {
          HttpHeaders.authorizationHeader: 'Token $userToken',
        },
        body: {
          'billId': billId,
          //'billId': billId
          'lastName': lastName,
          'firstName': firstName,
          'billingAccnt': billingAccnt,
          'paidAmount': paidAmount,
          'cardNumber': cardNumber,
          'expiryMonth': expiryMonth,
          'expiryYear': expiryYear,
          'cardCVC': cvvCode,
        },
      );
      if (stripeCardPayResponse.statusCode == 200) {
        var stripeCardPayResponseJsons =
            json.decode(stripeCardPayResponse.body);
        get_charge_response
            .add(stripeCard.fromJson(stripeCardPayResponseJsons));
        String charge_result = get_charge_response[0].chargeResponse;
        //print("$charge_result hey");
        return charge_result;
      } else {
        //print('here ${stripeCardPayResponse.statusCode}');
        return 'charge failed';
      }
    }

    return 'charge failed';
  }
}
