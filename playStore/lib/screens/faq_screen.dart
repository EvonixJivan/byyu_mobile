import 'package:byyu/constants/color_constants.dart';
import 'package:byyu/models/businessLayer/global.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:flutter_html/flutter_html.dart';
//import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:byyu/models/aboutUsModel.dart';
import 'package:byyu/models/businessLayer/baseRoute.dart';
import 'package:byyu/models/termsOfServicesModel.dart';
import 'package:byyu/models/businessLayer/global.dart' as global;

class FrequentlyQuestionsScreen extends BaseRoute {
  FrequentlyQuestionsScreen({a, o})
      : super(a: a, o: o, r: 'FrequentlyQuestionsScreen');
  @override
  _FrequentlyQuestionsScreenState createState() =>
      new _FrequentlyQuestionsScreenState();
}

class _FrequentlyQuestionsScreenState extends BaseRouteState {
  GlobalKey<ScaffoldState>? _scaffoldKey;

  TextStyle ansTextStyle = TextStyle(
      fontFamily: global.fontRailwayRegular,
      fontSize: 14,
      height: 1.2,
      fontWeight: FontWeight.w200,
      color: ColorConstants.pureBlack);
  TextStyle queTextStyle = TextStyle(
      fontFamily: global.fontMontserratLight,
      fontSize: 12,
      fontWeight: FontWeight.w200,
      color: ColorConstants.pureBlack);
  TextStyle sectionTextStyle = TextStyle(
      fontFamily: global.fontMontserratLight,
      fontSize: 14,
      fontWeight: FontWeight.w200,
      color: ColorConstants.pureBlack);
  int? parent;
  int? deliveryIndex, orderIndex, voucherIndex, paymentIndex;
  List<String> deliveryQuestion = [];
  List<String> deliveryAnswer = [];
  List<String> orderQuestion = [];
  List<String> orderAnswer = [];
  List<String> vouchersQuestion = [];
  List<String> vouchersAnswer = [];
  List<String> paymentQuestion = [];
  List<String> paymentAnswer = [];
  

  _FrequentlyQuestionsScreenState() : super();
  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return SafeArea(
      child: Scaffold(
        backgroundColor: ColorConstants.colorPageBackground,
        key: _scaffoldKey,
        appBar: AppBar(
          backgroundColor: ColorConstants.appBarColorWhite,
          title: Text(
            "FAQ",
            // '${AppLocalizations.of(context).tle_term_of_service}',
            style: TextStyle(
                color: ColorConstants.pureBlack,
                fontFamily: fontRailwayRegular,
                fontWeight: FontWeight.w200), //textTheme.titleLarge,
          ),
          centerTitle: false,
          leading: BackButton(
              onPressed: () {
                Navigator.pop(context);
              },
              color: ColorConstants.pureBlack),
        ),
        body: Container(
            color: ColorConstants.colorPageBackground,
            padding: const EdgeInsets.only(left: 1.0, right: 1.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  ExpansionTile(
                    key: Key('section0 ${parent.toString()}'),
                    childrenPadding: EdgeInsets.only(left: 10),
                    title: Text(
                      "Delivery",
                      style: sectionTextStyle,
                    ),
                    initiallyExpanded: parent == 0,
                    textColor: ColorConstants.appColor,
                    collapsedTextColor: ColorConstants.pureBlack,
                    iconColor: ColorConstants.appColor,
                    collapsedIconColor: ColorConstants.pureBlack,
                    onExpansionChanged: (value) {
                      
                      if (value) {
                        Duration(seconds: 20000);
                        parent = 0;
                      } else {
                        parent = -1;
                      }
                      
                      setState(() {
                      });
                    },
                    children: [
                      ListView.builder(
                        key: Key('builder1 ${deliveryIndex.toString()}'),
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        itemCount: deliveryQuestion.length,
                        itemBuilder: (context, index) {
                          return ExpansionTile(
                            key: Key(index.toString()),
                            childrenPadding:
                                EdgeInsets.only(left: 25, right: 5),
                            title: Text(
                              deliveryQuestion[index],
                              style: queTextStyle,
                            ),
                            iconColor: ColorConstants.appColor,
                            
                            initiallyExpanded:
                                deliveryIndex==index ,
                            onExpansionChanged: (value) {
                             if (value) {
                                Duration(seconds: 20000);
                                deliveryIndex = index;
                              } else {
                                deliveryIndex = -1;
                              }
                              setState(() {
                              });
                            },
                            collapsedIconColor: ColorConstants.pureBlack,
                            children: [
                              Container(
                                margin: EdgeInsets.only(left: 10, right: 10),
                                height: 2,
                                width: MediaQuery.of(context).size.width,
                                color: ColorConstants.greyDull,
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              Text(
                                deliveryAnswer[index],
                                style: ansTextStyle,
                              ),
                              SizedBox(
                                height: 5,
                              )
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 10, right: 10),
                    height: 2,
                    width: MediaQuery.of(context).size.width,
                    color: ColorConstants.greyDull,
                  ),
                  //#######################################################################
                  ExpansionTile(
                    key: Key('section1 ${parent.toString()}'),
                    title: Text(
                      "Orders",
                      style: TextStyle(
                          fontFamily: global.fontMontserratLight,
                          fontSize: 14,
                          fontWeight: FontWeight.w200,
                          color: ColorConstants.pureBlack),
                    ),
                    iconColor: ColorConstants.appColor,
                    collapsedIconColor: ColorConstants.pureBlack,
                    initiallyExpanded: parent==1,
                    onExpansionChanged: (value) {
                      if (value) {
                        setState(() {Duration(seconds: 20000);
                        parent = 1;});
                        
                      } else {

                         setState(() {Duration(seconds: 20000);
                        parent = -1;});
                      }
                      print("nikhilllllllllll parent${parent}");
                      
                    },
                    childrenPadding: EdgeInsets.only(left: 10),
                    children: [
                      ListView.builder(
                        key: Key('builder2 ${orderIndex.toString()}'),
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        itemCount: orderQuestion.length,
                        itemBuilder: (context, index) {
                          return ExpansionTile(
                            key: Key(index.toString()),
                            childrenPadding:
                                EdgeInsets.only(left: 25, right: 5),
                            title: Text(
                              orderQuestion[index],
                              style: queTextStyle,
                            ),
                            iconColor: ColorConstants.appColor,
                            initiallyExpanded:
                                orderIndex == index ,
                            onExpansionChanged: (value) {
                              if (value) {
                                Duration(seconds: 20000);
                                orderIndex = index;
                              } else {
                                orderIndex = -1;
                              }
                              setState(() {
                              });
                            },
                            collapsedIconColor: ColorConstants.pureBlack,
                            children: [
                              Container(
                                margin: EdgeInsets.only(left: 10, right: 10),
                                height: 2,
                                width: MediaQuery.of(context).size.width,
                                color: ColorConstants.greyDull,
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              Text(
                                orderAnswer[index],
                                style: ansTextStyle,
                              ),
                              SizedBox(
                                height: 5,
                              )
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 10, right: 10),
                    height: 2,
                    width: MediaQuery.of(context).size.width,
                    color: ColorConstants.greyDull,
                  ),
                  //#######################################################################
                  ExpansionTile(
                    key: Key('section2 ${parent.toString()}'),
                    title: Text(
                      "Vouchers/Discount",
                      style: TextStyle(
                          fontFamily: global.fontMontserratLight,
                          fontSize: 14,
                          fontWeight: FontWeight.w200,
                          color: ColorConstants.pureBlack),
                    ),
                    iconColor: ColorConstants.appColor,
                    collapsedIconColor: ColorConstants.pureBlack,
                    initiallyExpanded: parent==2,
                    onExpansionChanged: (value) {
                      if (value) {
                        Duration(seconds: 20000);
                        parent = 2;
                      } else {
                        parent = -1;
                      }
                      setState(() {});
                    },
                    childrenPadding: EdgeInsets.only(left: 10),
                    children: [
                      ListView.builder(
                        key: Key('builder3 ${voucherIndex.toString()}'),
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        itemCount: vouchersQuestion.length,
                        itemBuilder: (context, index) {
                          return ExpansionTile(
                            childrenPadding:
                                EdgeInsets.only(left: 25, right: 5),
                            title: Text(
                              vouchersQuestion[index],
                              style: queTextStyle,
                            ),
                            iconColor: ColorConstants.appColor,
                            initiallyExpanded:
                                voucherIndex == index,
                            onExpansionChanged: (value) {
                              if (value) {
                                Duration(seconds: 20000);
                                voucherIndex = index;
                              } else {
                                voucherIndex = -1;
                              }
                              setState(() {});
                            },
                            collapsedIconColor: ColorConstants.pureBlack,
                            children: [
                              Container(
                                margin: EdgeInsets.only(left: 10, right: 10),
                                height: 2,
                                width: MediaQuery.of(context).size.width,
                                color: ColorConstants.greyDull,
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              Text(
                                vouchersAnswer[index],
                                style: ansTextStyle,
                              ),
                              SizedBox(
                                height: 5,
                              )
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 10, right: 10),
                    height: 2,
                    width: MediaQuery.of(context).size.width,
                    color: ColorConstants.greyDull,
                  ),
                  //#######################################################################
                  ExpansionTile(
                    key: Key('section3 ${parent.toString()}'),
                    title: Text(
                      "Payment Modes",
                      style: TextStyle(
                          fontFamily: global.fontMontserratLight,
                          fontSize: 14,
                          fontWeight: FontWeight.w200,
                          color: ColorConstants.pureBlack),
                    ),
                    iconColor: ColorConstants.appColor,
                    collapsedIconColor: ColorConstants.pureBlack,
                    initiallyExpanded: parent==3,
                    onExpansionChanged: (value) {
                      if (value) {
                        Duration(seconds: 20000);
                        parent = 3;
                      } else {
                        parent = -1;
                      }
                      setState(() {});
                    },
                    childrenPadding: EdgeInsets.only(left: 10),
                    children: [
                      ListView.builder(
                        key: Key('builder4 ${paymentIndex.toString()}'),
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        itemCount: paymentQuestion.length,
                        itemBuilder: (context, index) {
                          return ExpansionTile(
                            childrenPadding:
                                EdgeInsets.only(left: 25, right: 5),
                            title: Text(
                              paymentQuestion[index],
                              style: queTextStyle,
                            ),
                            iconColor: ColorConstants.appColor,
                            initiallyExpanded:
                                paymentIndex == index ,
                            onExpansionChanged: (value) {
                              if (value) {
                                Duration(seconds: 20000);
                                paymentIndex = index;
                                
                              } else {
                                paymentIndex = -1;
                              }
                              setState(() {});
                            },
                            collapsedIconColor: ColorConstants.pureBlack,
                            children: [
                              Container(
                                margin: EdgeInsets.only(left: 10, right: 10),
                                height: 2,
                                width: MediaQuery.of(context).size.width,
                                color: ColorConstants.greyDull,
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              Text(
                                paymentAnswer[index],
                                style: ansTextStyle,
                              ),
                              SizedBox(
                                height: 5,
                              )
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 10, right: 10),
                    height: 2,
                    width: MediaQuery.of(context).size.width,
                    color: ColorConstants.greyDull,
                  ),
                ],
              ),
            )),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    initStaticList();
  }

  void initStaticList() {
    // deliveryQuestion.add(new FAQExpansionModel( "Where do you Deliver to?",false));
    // deliveryQuestion.add(new FAQExpansionModel("Do you deliver only within India or overseas?",false));
    // deliveryQuestion.add(new FAQExpansionModel("Are there any delivery costs attached?",false));
    // deliveryQuestion.add(new FAQExpansionModel("Can I choose the delivery time?",false));
    // deliveryQuestion.add(new FAQExpansionModel("Do you provide same day deliveries?",false));
    // deliveryQuestion.add(new FAQExpansionModel("Can I request a specific delivery date for my gift?",false));
    // deliveryQuestion.add(new FAQExpansionModel("When will my order be delivered?",false));
    // deliveryQuestion.add(new FAQExpansionModel("Will you call the recipient before delivering?",false));
    // deliveryQuestion.add(new FAQExpansionModel("What are the different modes of delivery?",false));
    // deliveryQuestion.add(new FAQExpansionModel("How can I ensure timely delivery of gifts in Dubai?",false));

    deliveryQuestion.add( "Where do you Deliver to?");
    deliveryQuestion.add("Do you deliver only within India or overseas?");
    deliveryQuestion.add("Are there any delivery costs attached?");
    deliveryQuestion.add("Can I choose the delivery time?");
    deliveryQuestion.add("Do you provide same day deliveries?");
    deliveryQuestion.add("Can I request a specific delivery date for my gift?");
    deliveryQuestion.add("When will my order be delivered?");
    deliveryQuestion.add("Will you call the recipient before delivering?");
    deliveryQuestion.add("What are the different modes of delivery?");
    deliveryQuestion.add("How can I ensure timely delivery of gifts in Dubai?");
    
    deliveryAnswer.add(
        "We currently deliver to all locations across Dubai. Whether you are sending a gift to a friend, family member, or colleague, you can rest assured that we will deliver it anywhere within the city.");
    deliveryAnswer.add(
        "No, at this time, we do not offer delivery services in India or other countries. Our delivery services are exclusively available within Dubai, ensuring we provide timely and reliable service within this region.");
    deliveryAnswer.add(
        "Yes, delivery charges are applicable under certain conditions. If your cart value is below 100 AED, a delivery fee will be added to your order. For orders exceeding 100 AED, we offer free delivery as part of our commitment to providing value to our customers.");
    deliveryAnswer.add(
        "Absolutely! We understand that timing is crucial when sending a gift. You can select from our available delivery slots to ensure your order arrives at the most convenient time for you or the recipient. The available time slots are: \n 8:00 AM – 12:00 PM: Morning Deliveries \n12:00 PM – 4:00 PM: Midday Deliveries \n4:00 PM – 8:00 PM: Evening Deliveries \n8:00 PM – 12:00 AM: Late-night Deliveries");
    deliveryAnswer.add(
        "Yes, we do offer same-day delivery services. If you place your order by 4:00 PM, we’ll ensure your gift is delivered the same day. This option is perfect for last-minute surprises or urgent occasions, allowing you to send a thoughtful gift even at short notice.");
    deliveryAnswer.add(
        "  Yes, you can. When placing your order, you can select a specific delivery date. ");
    deliveryAnswer.add(
        "The order will be delivered within the time slot you have chosen, you can track your order status on the app. ");
    deliveryAnswer.add(
        "Yes, in some cases, we may contact the recipient before delivering the order. This usually happens if there is an issue with the delivery address or if we need to confirm any details to ensure a smooth delivery experience.");
    deliveryAnswer.add(
        "We offer three flexible delivery options to cater to your needs:\n Express Delivery: Get your order delivered within 120 minutes for those urgent needs. \nSame-Day Delivery: Receive your order within 3 hours when time is of the essence.\nScheduled Delivery: Choose a specific date and time slot that works best for you or the recipient.");
    deliveryAnswer.add(
        "To ensure your gifts are delivered on time, please make sure to provide complete and accurate delivery information when placing your order. Selecting the appropriate delivery mode (Express, Same-Day, or Scheduled) based on your needs will also help. Additionally, by tracking your order through our app, you can stay informed about the delivery status and make any necessary adjustments if needed.");

    orderQuestion.add("How do I track my order?");
    orderQuestion.add("Can I change or Cancel my order I have just placed?");
    orderQuestion.add("How do I know my order has been delivered?");
    orderQuestion.add("If I cancel my order do I get a full refund?");
    orderQuestion.add("What if i am unhappy with my order ?");
    orderAnswer.add(
        "You can easily track your order through our app or website. Simply go to the 'Orders' section in your profile, where you can view real-time updates on your order status.");
    orderAnswer.add(
        "Unfortunately, once an order is placed, it cannot be changed or canceled.");
    orderAnswer.add(
        "You will receive a notification via SMS and email once your order has been successfully delivered. You can also check the delivery status in the 'Orders' section of your profile.");
    orderAnswer.add(
        "Orders cannot be canceled once they have been placed. Therefore, refunds are not applicable.");
    orderAnswer.add(
        "We are sorry to hear that you are not satisfied with your order. Please reach out to us at contact@byyu.com and let us know how we can address your concerns. Your feedback is important to us, and we are committed to resolving any issues.");

    vouchersQuestion.add("How do i reedem my gift voucher ?");
    vouchersQuestion.add("Where can i apply discount coupon ?");
    vouchersAnswer.add(
        "You can redeem your voucher easily through our app or website. Simply go to the 'Gift Voucher' section during checkout, enter your voucher code, and apply it to your purchase.");
    vouchersAnswer.add(
        "You can apply your discount coupon during the checkout process. There will be a designated field where you can enter your coupon code to receive the discount on your order.");

    paymentQuestion.add("Is cash on delivery available? ");
    paymentQuestion.add("What payment modes are available?");
    paymentQuestion.add("Is it safe to use cards online? ");
    paymentAnswer.add(
        "No, currently we do not offer Cash on Delivery (COD) as a payment option. We have several other convenient and secure payment methods available for you.");
    paymentAnswer.add(
        "We offer a variety of payment options to cater to your needs: \nCard Payments: All major credit and debit cards \nCareem Pay \nApple Pay \nGoogle Pay \nPayPal: For transactions in USD \nKnet: For transactions in KWD (Kuwaiti Dinar) \nBenefit Pay: For transactions in BHD (Bahraini Dinar)");
    paymentAnswer.add(
        "Yes, it is completely safe to use cards for online payments with us. We take your security seriously and ensure that none of your card data is stored on our servers. Our payment processes are encrypted and adhere to the highest security standards to protect your information.");
  }
}
