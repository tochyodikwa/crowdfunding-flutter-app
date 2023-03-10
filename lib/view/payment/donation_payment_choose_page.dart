import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutterzilla_fixed_grid/flutterzilla_fixed_grid.dart';
import 'package:fundorex/service/donate_service.dart';
import 'package:fundorex/service/pay_services/bank_transfer_service.dart';
import 'package:fundorex/service/pay_services/payment_choose_service.dart';
import 'package:fundorex/service/profile_service.dart';
import 'package:fundorex/view/payment/components/donation_details.dart';
import 'package:fundorex/view/utils/common_helper.dart';
import 'package:fundorex/view/utils/constant_colors.dart';
import 'package:fundorex/view/utils/constant_styles.dart';
import 'package:fundorex/view/utils/custom_input.dart';
import 'package:fundorex/view/utils/others_helper.dart';
import 'package:provider/provider.dart';

import '../../service/pay_services/payment_constants.dart';

class DonationPaymentChoosePage extends StatefulWidget {
  const DonationPaymentChoosePage({Key? key, required this.campaignId})
      : super(key: key);

  final campaignId;

  @override
  _DonationPaymentChoosePageState createState() =>
      _DonationPaymentChoosePageState();
}

class _DonationPaymentChoosePageState extends State<DonationPaymentChoosePage> {
  @override
  void initState() {
    super.initState();

    nameController.text = Provider.of<ProfileService>(context, listen: false)
            .profileDetails
            .name ??
        '';
    emailController.text = Provider.of<ProfileService>(context, listen: false)
            .profileDetails
            .email ??
        '';
    customAmountController.text =
        Provider.of<DonateService>(context, listen: false)
                .defaultDonateAmount ??
            '';

    amountIndex = Provider.of<DonateService>(context, listen: false)
                .defaultDonateAmount !=
            null
        ? -1
        : 0;

    Provider.of<DonateService>(context, listen: false)
        .calculateInitialDonationAmount();
    Provider.of<DonateService>(context, listen: false).calculateTips();
  }

  int selectedMethod = -1;
  bool termsAgree = false;
  bool annonymusDonate = false;
  late int amountIndex;
  int amountToDonate = 0;

  TextEditingController customAmountController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    ConstantColors cc = ConstantColors();

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: CommonHelper().appbarCommon('Payment', context, () {
          Navigator.pop(context);
        }),
        body: SingleChildScrollView(
          physics: physicsCommon,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: screenPadding),
            child: Consumer<PaymentChooseService>(
              builder: (context, pgProvider, child) => pgProvider
                      .paymentList.isNotEmpty
                  ? Consumer<DonateService>(
                      builder: (context, dProvider, child) {
                        return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              dProvider.amounts.isNotEmpty
                                  ? Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        if (dProvider.minimumDonateAmount != 0)
                                          Container(
                                            margin: const EdgeInsets.only(
                                                bottom: 8),
                                            child: Text(
                                              'Minimum donation amount: ${dProvider.minimumDonateAmount}',
                                              textAlign: TextAlign.start,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                color: cc.secondaryColor,
                                                fontSize: 13,
                                              ),
                                            ),
                                          ),
                                        CommonHelper()
                                            .labelCommon("Pick an amount"),
                                        Container(
                                          margin: const EdgeInsets.only(top: 5),
                                          height: 55,
                                          child: ListView(
                                            scrollDirection: Axis.horizontal,
                                            shrinkWrap: true,
                                            clipBehavior: Clip.none,
                                            children: [
                                              for (int i = 0;
                                                  i < dProvider.amounts.length;
                                                  i++)
                                                InkWell(
                                                  splashColor:
                                                      Colors.transparent,
                                                  highlightColor:
                                                      Colors.transparent,
                                                  onTap: () {
                                                    if (amountIndex == i) {
                                                      return;
                                                    }

                                                    customAmountController
                                                        .clear();

                                                    // dProvider.calculateTips(
                                                    //     isAfterSelectingOrWritingNewAmount:
                                                    //         true);

                                                    dProvider.setDonationAmount(
                                                        dProvider.amounts[i]);

                                                    // Future.delayed(
                                                    //     Duration(seconds: 2),
                                                    //     () {
                                                    //   dProvider
                                                    //       .calculateTipsAfterSelectedOrRritten();
                                                    // });

                                                    setState(() {
                                                      amountIndex = i;
                                                    });
                                                  },
                                                  child: Container(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 18),
                                                    margin:
                                                        const EdgeInsets.only(
                                                            right: 20),
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              4),
                                                      color: amountIndex == i
                                                          ? cc.primaryColor
                                                          : cc.greySecondary,
                                                    ),
                                                    alignment: Alignment.center,
                                                    child: Text(
                                                      "\$${dProvider.amounts[i]}",
                                                      style: TextStyle(
                                                          color: amountIndex !=
                                                                  i
                                                              ? cc.greyFour
                                                              : Colors.white,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontSize: 18),
                                                    ),
                                                  ),
                                                ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    )
                                  : Container(),

                              sizedBoxCustom(20),
                              //Name ============>
                              CommonHelper().labelCommon("Or enter an amount"),

                              CustomInput(
                                controller: customAmountController,
                                hintText: "Amount",
                                textInputAction: TextInputAction.next,
                                isNumberField: true,
                                paddingHorizontal: 20,
                                onChanged: (v) {
                                  print(v);
                                  amountIndex = -1;
                                  if (v.isNotEmpty) {
                                    dProvider.setDonationAmount(v);
                                  } else {
                                    OthersHelper().showToast(
                                        'Amount must be greater than zero',
                                        cc.warningColor);
                                  }
                                },
                              ),
                              const SizedBox(
                                height: 8,
                              ),

                              //Name ============>
                              CommonHelper().labelCommon("Name"),

                              CustomInput(
                                controller: nameController,
                                validation: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your name';
                                  }
                                  return null;
                                },
                                hintText: "Name",
                                textInputAction: TextInputAction.next,
                                paddingHorizontal: 20,
                              ),
                              const SizedBox(
                                height: 8,
                              ),

                              //Name ============>
                              CommonHelper().labelCommon("Email"),

                              CustomInput(
                                controller: emailController,
                                validation: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your email';
                                  }
                                  return null;
                                },
                                hintText: "Email",
                                textInputAction: TextInputAction.next,
                                paddingHorizontal: 20,
                                marginBottom: 10,
                              ),

                              CheckboxListTile(
                                checkColor: Colors.white,
                                activeColor: ConstantColors().primaryColor,
                                contentPadding: const EdgeInsets.all(0),
                                title: Container(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 5),
                                  child: Text(
                                    'Donate anonymously',
                                    style: TextStyle(
                                        color: ConstantColors().greyFour,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 14),
                                  ),
                                ),
                                value: annonymusDonate,
                                onChanged: (newValue) {
                                  setState(() {
                                    annonymusDonate = !annonymusDonate;
                                  });
                                },
                                controlAffinity:
                                    ListTileControlAffinity.leading,
                              ),

                              const DonationDetails(),

                              //border
                              sizedBoxCustom(30),
                              CommonHelper()
                                  .titleCommon('Choose payment method'),

                              //payment method card
                              GridView.builder(
                                gridDelegate: const FlutterzillaFixedGridView(
                                    crossAxisCount: 3,
                                    mainAxisSpacing: 15,
                                    crossAxisSpacing: 15,
                                    height: 60),
                                padding: const EdgeInsets.only(top: 30),
                                itemCount: pgProvider.paymentList.length,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                clipBehavior: Clip.none,
                                itemBuilder: (context, index) {
                                  return InkWell(
                                    onTap: () {
                                      setState(() {
                                        selectedMethod = index;
                                      });

                                      //set key
                                      pgProvider.setKey(
                                          pgProvider.paymentList[selectedMethod]
                                              ['name'],
                                          index);

                                      //save selected payment method name
                                      // Provider.of<BookService>(context,
                                      //         listen: false)
                                      //     .setSelectedPayment(pgProvider
                                      //             .paymentList[selectedMethod]
                                      //         ['name']);
                                    },
                                    child: Stack(
                                      clipBehavior: Clip.none,
                                      children: [
                                        Container(
                                          width: double.infinity,
                                          height: 60,
                                          padding: const EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            border: Border.all(
                                                color: selectedMethod == index
                                                    ? cc.primaryColor
                                                    : cc.borderColor),
                                          ),
                                          child: CachedNetworkImage(
                                            imageUrl:
                                                pgProvider.paymentList[index]
                                                    ['logo_link'],
                                            placeholder: (context, url) {
                                              return Image.asset(
                                                  'assets/images/placeholder.png');
                                            },
                                            // fit: BoxFit.fitWidth,
                                          ),
                                        ),
                                        selectedMethod == index
                                            ? Positioned(
                                                right: -7,
                                                top: -9,
                                                child: CommonHelper()
                                                    .checkCircle())
                                            : Container()
                                      ],
                                    ),
                                  );
                                },
                              ),

                              selectedMethod != -1
                                  ? pgProvider.paymentList[selectedMethod]
                                              ['name'] ==
                                          'manual_payment'
                                      ?
                                      //pick image ==========>
                                      Consumer<BankTransferService>(
                                          builder:
                                              (context, btProvider, child) =>
                                                  Column(
                                                    children: [
                                                      //pick image button =====>
                                                      Column(
                                                        children: [
                                                          const SizedBox(
                                                            height: 30,
                                                          ),
                                                          CommonHelper()
                                                              .buttonPrimary(
                                                                  'Choose images',
                                                                  () {
                                                            btProvider
                                                                .pickImage(
                                                                    context);
                                                          }),
                                                        ],
                                                      ),
                                                      btProvider.pickedImage !=
                                                              null
                                                          ? Column(
                                                              children: [
                                                                const SizedBox(
                                                                  height: 30,
                                                                ),
                                                                SizedBox(
                                                                  height: 80,
                                                                  child:
                                                                      ListView(
                                                                    clipBehavior:
                                                                        Clip.none,
                                                                    scrollDirection:
                                                                        Axis.horizontal,
                                                                    shrinkWrap:
                                                                        true,
                                                                    children: [
                                                                      // for (int i = 0;
                                                                      //     i <
                                                                      //         btProvider
                                                                      //             .images!.length;
                                                                      //     i++)
                                                                      InkWell(
                                                                        onTap:
                                                                            () {},
                                                                        child:
                                                                            Column(
                                                                          children: [
                                                                            Container(
                                                                              margin: const EdgeInsets.only(right: 10),
                                                                              child: Image.file(
                                                                                // File(provider.images[i].path),
                                                                                File(btProvider.pickedImage.path),
                                                                                height: 80,
                                                                                width: 80,
                                                                                fit: BoxFit.cover,
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ],
                                                            )
                                                          : Container(),
                                                    ],
                                                  ))
                                      : Container()
                                  : Container(),

                              //Agreement checkbox ===========>
                              const SizedBox(
                                height: 20,
                              ),
                              CheckboxListTile(
                                checkColor: Colors.white,
                                activeColor: ConstantColors().primaryColor,
                                contentPadding: const EdgeInsets.all(0),
                                title: Container(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 5),
                                  child: Text(
                                    'I agree with terms and conditions',
                                    style: TextStyle(
                                        color: ConstantColors().greyFour,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 14),
                                  ),
                                ),
                                value: termsAgree,
                                onChanged: (newValue) {
                                  setState(() {
                                    termsAgree = !termsAgree;
                                  });
                                },
                                controlAffinity:
                                    ListTileControlAffinity.leading,
                              ),

                              //pay button =============>
                              const SizedBox(
                                height: 14,
                              ),

                              CommonHelper().buttonPrimary('Pay & Confirm', () {
                                if (selectedMethod == -1) {
                                  OthersHelper().showSnackBar(
                                      context,
                                      'Please select a payment method',
                                      Colors.red);

                                  return;
                                }

                                if (customAmountController.text.isEmpty &&
                                    amountIndex < 0) {
                                  OthersHelper().showSnackBar(
                                      context,
                                      'Please enter or select an amount',
                                      Colors.red);

                                  return;
                                }

                                if (dProvider.minimumDonateAmount != 0 &&
                                    (int.parse(customAmountController.text) <
                                        dProvider.minimumDonateAmount)) {
                                  OthersHelper().showSnackBar(
                                      context,
                                      'Amount must be greater than ${dProvider.minimumDonateAmount}',
                                      Colors.red);

                                  return;
                                }

                                if (termsAgree == false) {
                                  OthersHelper().showToast(
                                      'You must agree with the terms and conditions',
                                      Colors.black);
                                }
                                if (dProvider.isloading == true) {
                                  return;
                                } else {
                                  dProvider.setUserEnteredNameEmail(
                                      nameController.text,
                                      emailController.text);
                                  payAction(
                                      pgProvider.paymentList[selectedMethod]
                                          ['name'],
                                      context,
                                      //if user selected bank transfer
                                      pgProvider.paymentList[selectedMethod]
                                                  ['name'] ==
                                              'manual_payment'
                                          ? Provider.of<BankTransferService>(
                                                  context,
                                                  listen: false)
                                              .pickedImage
                                          : null,
                                      campaignId: widget.campaignId,
                                      name: nameController.text.trim(),
                                      email: emailController.text.trim(),
                                      anonymousDonate: annonymusDonate);
                                }
                              },
                                  isloading: dProvider.isloading == false
                                      ? false
                                      : true),

                              sizedBoxCustom(40)
                            ]);
                      },
                    )
                  : Container(
                      margin: const EdgeInsets.only(top: 60),
                      child: OthersHelper().showLoading(cc.primaryColor),
                    ),
            ),
          ),
        ));
  }
}
