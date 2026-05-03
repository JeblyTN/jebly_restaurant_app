import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:restaurant/app/Home_screen/order_details_screen.dart';
import 'package:restaurant/constant/collection_name.dart';
import 'package:restaurant/constant/constant.dart';
import 'package:restaurant/constant/show_toast_dialog.dart';
import 'package:restaurant/controller/wallet_controller.dart';
import 'package:restaurant/models/user_model.dart';
import 'package:restaurant/models/wallet_transaction_model.dart';
import 'package:restaurant/models/withdrawal_model.dart';
import 'package:restaurant/themes/app_them_data.dart';
import 'package:restaurant/themes/responsive.dart';
import 'package:restaurant/themes/round_button_fill.dart';
import 'package:restaurant/themes/text_field_widget.dart';
import 'package:restaurant/utils/dark_theme_provider.dart';
import 'package:restaurant/utils/fire_store_utils.dart';
import 'package:restaurant/widget/my_separator.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class WalletScreen extends StatelessWidget {
  const WalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX(
        init: WalletController(),
        builder: (controller) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: AppThemeData.secondary300,
              centerTitle: false,
              iconTheme: IconThemeData(color: AppThemeData.grey50, size: 20),
              title: Text(
                "Wallet".tr,
                style: TextStyle(color: AppThemeData.grey50, fontSize: 18, fontFamily: AppThemeData.medium),
              ),
            ),
            body: controller.isLoading.value
                ? Constant.loader()
                : Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        child: Container(
                          width: Responsive.width(100, context),
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            image: DecorationImage(
                              image: AssetImage("assets/images/wallet.png"),
                              fit: BoxFit.fill,
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                            child: Column(
                              children: [
                                Text(
                                  "Total Wallet amount".tr,
                                  maxLines: 1,
                                  style: TextStyle(
                                    color: themeChange.getThem() ? AppThemeData.grey900 : AppThemeData.grey900,
                                    fontSize: 16,
                                    overflow: TextOverflow.ellipsis,
                                    fontFamily: AppThemeData.regular,
                                  ),
                                ),
                                Text(
                                  Constant.amountShow(amount: controller.userModel.value.walletAmount.toString()),
                                  maxLines: 1,
                                  style: TextStyle(
                                    color: themeChange.getThem() ? AppThemeData.grey900 : AppThemeData.grey900,
                                    fontSize: 22,
                                    overflow: TextOverflow.ellipsis,
                                    fontFamily: AppThemeData.bold,
                                  ),
                                ),
                                const Divider(
                                  color: AppThemeData.grey600,
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        children: [
                                          Text(
                                            "Order Amount".tr,
                                            maxLines: 1,
                                            style: TextStyle(
                                              color: themeChange.getThem() ? AppThemeData.grey900 : AppThemeData.grey900,
                                              fontSize: 14,
                                              overflow: TextOverflow.ellipsis,
                                              fontFamily: AppThemeData.regular,
                                            ),
                                          ),
                                          Text(
                                            Constant.amountShow(amount: controller.orderAmount.value.toString()),
                                            maxLines: 1,
                                            style: TextStyle(
                                              color: themeChange.getThem() ? AppThemeData.grey900 : AppThemeData.grey900,
                                              fontSize: 18,
                                              overflow: TextOverflow.ellipsis,
                                              fontFamily: AppThemeData.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                        children: [
                                          Text(
                                            "Total Tax.".tr,
                                            maxLines: 1,
                                            style: TextStyle(
                                              color: themeChange.getThem() ? AppThemeData.grey900 : AppThemeData.grey900,
                                              fontSize: 14,
                                              overflow: TextOverflow.ellipsis,
                                              fontFamily: AppThemeData.regular,
                                            ),
                                          ),
                                          Text(
                                            Constant.amountShow(amount: controller.taxAmount.value.toString()),
                                            maxLines: 1,
                                            style: TextStyle(
                                              color: themeChange.getThem() ? AppThemeData.grey900 : AppThemeData.grey900,
                                              fontSize: 18,
                                              overflow: TextOverflow.ellipsis,
                                              fontFamily: AppThemeData.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: [
                                    (Constant.isRestaurantVerification == true && controller.userModel.value.isDocumentVerify == false) ||
                                            (controller.userModel.value.vendorID == null || controller.userModel.value.vendorID!.isEmpty)
                                        ? const SizedBox()
                                        : Expanded(
                                            child: RoundedButtonFill(
                                              title: "Withdraw".tr,
                                              width: 24,
                                              height: 5,
                                              color: AppThemeData.secondary300,
                                              textColor: AppThemeData.grey50,
                                              onPress: () {
                                                if ((Constant.userModel!.userBankDetails != null && Constant.userModel!.userBankDetails!.accountNumber.isNotEmpty) ||
                                                    controller.withdrawMethodModel.value.id != null) {
                                                  controller.amountTextFieldController.value.text = '';
                                                  controller.noteTextFieldController.value.text = '';
                                                  withdrawalCardBottomSheet(context, controller);
                                                } else {
                                                  ShowToastDialog.showToast("Please setup payment method".tr);
                                                }
                                              },
                                            ),
                                          ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: RoundedButtonFill(
                                        title: "Download Statement".tr,
                                        height: 5,
                                        color: AppThemeData.success500,
                                        textColor: AppThemeData.grey50,
                                        onPress: () {
                                          controller.createAndSavePdf();
                                        },
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 10),
                                      child: InkWell(
                                        splashColor: Colors.transparent,
                                        onTap: () {
                                          datePicker(context, controller);
                                        },
                                        child: const Icon(
                                          Icons.filter_alt,
                                          size: 32,
                                        ),
                                      ),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: DefaultTabController(
                          length: 3,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                child: TabBar(
                                  onTap: (value) {
                                    controller.selectedTabIndex.value = value;
                                  },
                                  padding: EdgeInsets.zero,
                                  isScrollable: true,
                                  tabAlignment: TabAlignment.start,
                                  labelStyle: TextStyle(fontFamily: AppThemeData.semiBold, color: AppThemeData.grey50),
                                  labelColor: themeChange.getThem() ? AppThemeData.grey50 : AppThemeData.grey700,
                                  unselectedLabelStyle: const TextStyle(fontFamily: AppThemeData.medium),
                                  unselectedLabelColor: AppThemeData.grey600,
                                  indicatorColor: themeChange.getThem() ? AppThemeData.grey50 : AppThemeData.grey700,
                                  dividerColor: Colors.transparent,
                                  tabs: [
                                    Tab(text: "Transaction History".tr),
                                    Tab(text: "Withdrawal History".tr),
                                    Tab(text: "Earnings".tr),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: TabBarView(
                                  children: [
                                    controller.walletTransactionList.isEmpty
                                        ? Constant.showEmptyView(message: "Transaction history not found".tr)
                                        : Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                            child: Container(
                                              decoration: ShapeDecoration(
                                                color: themeChange.getThem() ? AppThemeData.grey900 : AppThemeData.grey50,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(12),
                                                ),
                                              ),
                                              child: Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: ListView.separated(
                                                  padding: EdgeInsets.zero,
                                                  shrinkWrap: true,
                                                  itemCount: controller.walletTransactionList.length,
                                                  itemBuilder: (context, index) {
                                                    WalletTransactionModel walletTractionModel = controller.walletTransactionList[index];
                                                    return transactionCard(controller, themeChange, walletTractionModel);
                                                  },
                                                  separatorBuilder: (BuildContext context, int index) {
                                                    return Padding(
                                                      padding: const EdgeInsets.symmetric(vertical: 5),
                                                      child: MySeparator(color: themeChange.getThem() ? AppThemeData.grey700 : AppThemeData.grey200),
                                                    );
                                                  },
                                                ),
                                              ),
                                            ),
                                          ),
                                    controller.withdrawalList.isEmpty
                                        ? Constant.showEmptyView(message: "Transaction history not found".tr)
                                        : Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                            child: Container(
                                              decoration: ShapeDecoration(
                                                color: themeChange.getThem() ? AppThemeData.grey900 : AppThemeData.grey50,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(12),
                                                ),
                                              ),
                                              child: Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: ListView.separated(
                                                  padding: EdgeInsets.zero,
                                                  shrinkWrap: true,
                                                  itemCount: controller.withdrawalList.length,
                                                  itemBuilder: (context, index) {
                                                    WithdrawalModel walletTractionModel = controller.withdrawalList[index];
                                                    return transactionCardWithdrawal(controller, themeChange, walletTractionModel);
                                                  },
                                                  separatorBuilder: (BuildContext context, int index) {
                                                    return Padding(
                                                      padding: const EdgeInsets.symmetric(vertical: 5),
                                                      child: MySeparator(color: themeChange.getThem() ? AppThemeData.grey700 : AppThemeData.grey200),
                                                    );
                                                  },
                                                ),
                                              ),
                                            ),
                                          ),
                                    _buildEarningsTab(context, controller, themeChange),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
          );
        });
  }

  Future<dynamic> datePicker(BuildContext context, WalletController controller) {
    return showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 440, // Height of the bottom sheet
          color: AppThemeData.grey50,
          child: Column(
            children: [
              SfDateRangePicker(
                backgroundColor: AppThemeData.grey50,
                onSelectionChanged: (DateRangePickerSelectionChangedArgs args) {
                  // Store the selected date range
                  if (args.value is PickerDateRange) {
                    controller.startDate.value = args.value.startDate;
                    controller.endDate.value = args.value.endDate;
                  }
                },
                selectionMode: DateRangePickerSelectionMode.range,
                maxDate: DateTime.now(),
                initialSelectedRange: PickerDateRange(
                  controller.startDate.value,
                  controller.endDate.value,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: RoundedButtonFill(
                  title: "Filter".tr,
                  color: AppThemeData.secondary300,
                  textColor: AppThemeData.grey50,
                  onPress: () async {
                    Get.back();
                    await controller.getWalletTransaction(true);
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: RoundedButtonFill(
                  title: "Clear".tr,
                  color: AppThemeData.grey50,
                  textColor: AppThemeData.secondary300,
                  onPress: () async {
                    Get.back();
                    await controller.getWalletTransaction(false);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future withdrawalCardBottomSheet(BuildContext context, WalletController controller) {
    return showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        isDismissible: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(30),
          ),
        ),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        builder: (context) => FractionallySizedBox(
              heightFactor: 0.8,
              child: StatefulBuilder(builder: (context1, setState) {
                final themeChange = Provider.of<DarkThemeProvider>(context);
                return Obx(
                  () => Scaffold(
                    body: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      "Withdrawal".tr,
                                      style: TextStyle(color: themeChange.getThem() ? AppThemeData.grey100 : AppThemeData.grey800, fontSize: 18, fontFamily: AppThemeData.semiBold),
                                    ),
                                  ),
                                  InkWell(
                                      splashColor: Colors.transparent,
                                      onTap: () {
                                        Get.back();
                                      },
                                      child: const Icon(Icons.close)),
                                ],
                              ),
                            ),
                            TextFieldWidget(
                              title: 'Withdrawal amount'.tr,
                              controller: controller.amountTextFieldController.value,
                              hintText: 'Enter withdrawal amount'.tr,
                              textInputType: const TextInputType.numberWithOptions(signed: true, decimal: true),
                              textInputAction: TextInputAction.done,
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(RegExp('[0-9]')),
                              ],
                              prefix: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                                child: Text(
                                  "${Constant.currencyModel!.symbol}".tr,
                                  style: TextStyle(color: themeChange.getThem() ? AppThemeData.grey50 : AppThemeData.grey900, fontFamily: AppThemeData.semiBold, fontSize: 18),
                                ),
                              ),
                            ),
                            TextFieldWidget(
                              title: 'Notes'.tr,
                              controller: controller.noteTextFieldController.value,
                              hintText: 'Add Notes'.tr,
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Text(
                                "Select Withdraw Method".tr,
                                style: TextStyle(color: themeChange.getThem() ? AppThemeData.grey100 : AppThemeData.grey800, fontSize: 16, fontFamily: AppThemeData.medium),
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(borderRadius: const BorderRadius.all(Radius.circular(20)), color: themeChange.getThem() ? AppThemeData.grey900 : AppThemeData.grey50),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                child: Column(
                                  children: [
                                    Constant.userModel!.userBankDetails == null || Constant.userModel!.userBankDetails!.accountNumber.isEmpty
                                        ? const SizedBox()
                                        : InkWell(
                                            splashColor: Colors.transparent,
                                            onTap: () {
                                              controller.selectedValue.value = 0;
                                            },
                                            child: Row(
                                              children: [
                                                Container(
                                                  decoration: ShapeDecoration(
                                                    shape: RoundedRectangleBorder(
                                                      side: BorderSide(width: 1, color: themeChange.getThem() ? AppThemeData.grey700 : AppThemeData.grey200),
                                                      borderRadius: BorderRadius.circular(8),
                                                    ),
                                                  ),
                                                  child: Padding(
                                                    padding: const EdgeInsets.all(10),
                                                    child: SvgPicture.asset("assets/icons/ic_building_four.svg"),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    "Bank Transfer".tr,
                                                    style: TextStyle(color: themeChange.getThem() ? AppThemeData.grey50 : AppThemeData.grey900, fontSize: 16, fontFamily: AppThemeData.medium),
                                                  ),
                                                ),
                                                Radio(
                                                  value: 0,
                                                  groupValue: controller.selectedValue.value,
                                                  activeColor: AppThemeData.secondary300,
                                                  onChanged: (value) {
                                                    controller.selectedValue.value = value!;
                                                  },
                                                ),
                                              ],
                                            ),
                                          ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    controller.withdrawMethodModel.value.flutterWave == null || (controller.flutterWaveSettingData.value.isWithdrawEnabled == false)
                                        ? const SizedBox()
                                        : InkWell(
                                            splashColor: Colors.transparent,
                                            onTap: () {
                                              controller.selectedValue.value = 1;
                                            },
                                            child: Row(
                                              children: [
                                                Container(
                                                  decoration: ShapeDecoration(
                                                    shape: RoundedRectangleBorder(
                                                      side: BorderSide(width: 1, color: themeChange.getThem() ? AppThemeData.grey700 : AppThemeData.grey200),
                                                      borderRadius: BorderRadius.circular(8),
                                                    ),
                                                  ),
                                                  child: Padding(
                                                    padding: const EdgeInsets.all(10),
                                                    child: Image.asset("assets/images/flutterwave.png"),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    "Flutter wave".tr,
                                                    style: TextStyle(color: themeChange.getThem() ? AppThemeData.grey50 : AppThemeData.grey900, fontSize: 16, fontFamily: AppThemeData.medium),
                                                  ),
                                                ),
                                                Radio(
                                                  value: 1,
                                                  groupValue: controller.selectedValue.value,
                                                  activeColor: AppThemeData.secondary300,
                                                  onChanged: (value) {
                                                    controller.selectedValue.value = value!;
                                                  },
                                                ),
                                              ],
                                            ),
                                          ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    controller.withdrawMethodModel.value.paypal == null || (controller.paypalDataModel.value.isWithdrawEnabled == false)
                                        ? const SizedBox()
                                        : InkWell(
                                            splashColor: Colors.transparent,
                                            onTap: () {
                                              controller.selectedValue.value = 2;
                                            },
                                            child: Row(
                                              children: [
                                                Container(
                                                  decoration: ShapeDecoration(
                                                    shape: RoundedRectangleBorder(
                                                      side: BorderSide(width: 1, color: themeChange.getThem() ? AppThemeData.grey700 : AppThemeData.grey200),
                                                      borderRadius: BorderRadius.circular(8),
                                                    ),
                                                  ),
                                                  child: Padding(
                                                    padding: const EdgeInsets.all(10),
                                                    child: Image.asset("assets/images/paypal.png"),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    "PayPal".tr,
                                                    style: TextStyle(color: themeChange.getThem() ? AppThemeData.grey50 : AppThemeData.grey900, fontSize: 16, fontFamily: AppThemeData.medium),
                                                  ),
                                                ),
                                                Radio(
                                                  value: 2,
                                                  groupValue: controller.selectedValue.value,
                                                  activeColor: AppThemeData.secondary300,
                                                  onChanged: (value) {
                                                    controller.selectedValue.value = value!;
                                                  },
                                                ),
                                              ],
                                            ),
                                          ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    controller.withdrawMethodModel.value.razorpay == null || (controller.razorPayModel.value.isWithdrawEnabled == false)
                                        ? const SizedBox()
                                        : InkWell(
                                            splashColor: Colors.transparent,
                                            onTap: () {
                                              controller.selectedValue.value = 3;
                                            },
                                            child: Row(
                                              children: [
                                                Container(
                                                  decoration: ShapeDecoration(
                                                    shape: RoundedRectangleBorder(
                                                      side: BorderSide(width: 1, color: themeChange.getThem() ? AppThemeData.grey700 : AppThemeData.grey200),
                                                      borderRadius: BorderRadius.circular(8),
                                                    ),
                                                  ),
                                                  child: Padding(
                                                    padding: const EdgeInsets.all(10),
                                                    child: Image.asset("assets/images/razorpay.png"),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    "RazorPay".tr,
                                                    style: TextStyle(color: themeChange.getThem() ? AppThemeData.grey50 : AppThemeData.grey900, fontSize: 16, fontFamily: AppThemeData.medium),
                                                  ),
                                                ),
                                                Radio(
                                                  value: 3,
                                                  groupValue: controller.selectedValue.value,
                                                  activeColor: AppThemeData.secondary300,
                                                  onChanged: (value) {
                                                    controller.selectedValue.value = value!;
                                                  },
                                                ),
                                              ],
                                            ),
                                          ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    controller.withdrawMethodModel.value.stripe == null || (controller.stripeSettingData.value.isWithdrawEnabled == false)
                                        ? const SizedBox()
                                        : InkWell(
                                            splashColor: Colors.transparent,
                                            onTap: () {
                                              controller.selectedValue.value = 4;
                                            },
                                            child: Row(
                                              children: [
                                                Container(
                                                  decoration: ShapeDecoration(
                                                    shape: RoundedRectangleBorder(
                                                      side: BorderSide(width: 1, color: themeChange.getThem() ? AppThemeData.grey700 : AppThemeData.grey200),
                                                      borderRadius: BorderRadius.circular(8),
                                                    ),
                                                  ),
                                                  child: Padding(
                                                    padding: const EdgeInsets.all(10),
                                                    child: Image.asset("assets/images/stripe.png"),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    "Stripe".tr,
                                                    style: TextStyle(color: themeChange.getThem() ? AppThemeData.grey50 : AppThemeData.grey900, fontSize: 16, fontFamily: AppThemeData.medium),
                                                  ),
                                                ),
                                                Radio(
                                                  value: 4,
                                                  groupValue: controller.selectedValue.value,
                                                  activeColor: AppThemeData.secondary300,
                                                  onChanged: (value) {
                                                    controller.selectedValue.value = value!;
                                                  },
                                                ),
                                              ],
                                            ),
                                          ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    bottomNavigationBar: Container(
                      color: themeChange.getThem() ? AppThemeData.grey900 : AppThemeData.grey50,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: RoundedButtonFill(
                          title: "Withdraw".tr,
                          height: 5.5,
                          color: AppThemeData.secondary300,
                          textColor: AppThemeData.grey50,
                          fontSizes: 16,
                          onPress: () async {
                            if (controller.amountTextFieldController.value.text.isEmpty) {
                              ShowToastDialog.showToast("Please enter amount".tr);
                            } else if (controller.noteTextFieldController.value.text.isEmpty) {
                              ShowToastDialog.showToast("Please enter note".tr);
                            } else if (double.parse(controller.userModel.value.walletAmount.toString()) <= 0) {
                              ShowToastDialog.showToast("You are not able to place Withdraw request due to insufficient wallet amount".tr);
                            } else {
                              if (controller.isWithdrawBTnEnabled.value == true) {
                                controller.isWithdrawBTnEnabled.value = false;
                                WithdrawalModel withdrawHistory = WithdrawalModel(
                                  amount: controller.amountTextFieldController.value.text,
                                  vendorID: controller.userModel.value.vendorID,
                                  paymentStatus: "Pending",
                                  paidDate: Timestamp.now(),
                                  id: Constant.getUuid(),
                                  note: controller.noteTextFieldController.value.text,
                                  withdrawMethod: controller.selectedValue.value == 0
                                      ? "bank"
                                      : controller.selectedValue.value == 1
                                          ? "flutterwave"
                                          : controller.selectedValue.value == 2
                                              ? "paypal"
                                              : controller.selectedValue.value == 3
                                                  ? "razorpay"
                                                  : "stripe",
                                );
                                await FireStoreUtils.withdrawWalletAmount(withdrawHistory);
                                await FireStoreUtils.updateUserWallet(amount: "-${controller.amountTextFieldController.value.text}", userId: FireStoreUtils.getCurrentUid()).then((value) {
                                  Get.back();
                                  FireStoreUtils.sendPayoutMail(amount: controller.amountTextFieldController.value.text, payoutrequestid: withdrawHistory.id.toString());
                                  controller.getWalletTransaction(false);
                                });
                                controller.isWithdrawBTnEnabled.value = true;
                              }
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ));
  }

  InkWell transactionCardWithdrawal(WalletController controller, themeChange, WithdrawalModel transactionModel) {
    return InkWell(
      splashColor: Colors.transparent,
      onTap: () async {},
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Row(
          children: [
            Container(
              decoration: ShapeDecoration(
                shape: RoundedRectangleBorder(
                  side: BorderSide(width: 1, color: themeChange.getThem() ? AppThemeData.grey800 : AppThemeData.grey100),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: SvgPicture.asset(
                  "assets/icons/ic_debit.svg",
                  height: 16,
                  width: 16,
                ),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              transactionModel.note.toString(),
                              style: TextStyle(
                                fontSize: 16,
                                fontFamily: AppThemeData.semiBold,
                                fontWeight: FontWeight.w600,
                                color: themeChange.getThem() ? AppThemeData.grey100 : AppThemeData.grey800,
                              ),
                            ),
                            Text(
                              "(${transactionModel.withdrawMethod!.capitalizeString()})",
                              style: TextStyle(
                                fontSize: 14,
                                fontFamily: AppThemeData.medium,
                                fontWeight: FontWeight.w600,
                                color: themeChange.getThem() ? AppThemeData.grey100 : AppThemeData.grey800,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        "-${Constant.amountShow(amount: transactionModel.amount!.isEmpty ? "0.0" : transactionModel.amount.toString())}",
                        style: const TextStyle(
                          fontSize: 16,
                          fontFamily: AppThemeData.medium,
                          color: AppThemeData.danger300,
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 2,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          transactionModel.paymentStatus.toString(),
                          style: TextStyle(
                            fontSize: 14,
                            fontFamily: AppThemeData.semiBold,
                            fontWeight: FontWeight.w600,
                            color: transactionModel.paymentStatus == "Success"
                                ? AppThemeData.success400
                                : transactionModel.paymentStatus == "Pending"
                                    ? AppThemeData.secondary300
                                    : AppThemeData.danger300,
                          ),
                        ),
                      ),
                      Text(
                        Constant.timestampToDateTime(transactionModel.paidDate!),
                        style: TextStyle(fontSize: 12, fontFamily: AppThemeData.medium, fontWeight: FontWeight.w500, color: themeChange.getThem() ? AppThemeData.grey200 : AppThemeData.grey700),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEarningsTab(BuildContext context, WalletController controller, DarkThemeProvider themeChange) {
    final vendorId = Constant.userModel?.vendorID ?? '';

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          StreamBuilder<DocumentSnapshot>(
            stream: FireStoreUtils.fireStore.collection(CollectionName.vendors).doc(vendorId).snapshots(),
            builder: (context, snapshot) {
              final data = snapshot.data?.data() as Map<String, dynamic>?;
              final double weeklyAccrual = (data?['weeklyAccrual'] ?? 0).toDouble();
              final int weeklyOrderCount = (data?['weeklyOrderCount'] ?? 0).toInt();
              final double lastPayoutAmount = (data?['lastPayoutAmount'] ?? 0).toDouble();
              final Timestamp? lastPayoutAt = data?['lastPayoutAt'] as Timestamp?;
              final double totalEarnings = (data?['totalEarnings'] ?? 0).toDouble();

              return Column(
                children: [
                  _earningCard(
                    title: 'Weekly Earnings'.tr,
                    icon: Icons.trending_up,
                    color: AppThemeData.success400,
                    amount: weeklyAccrual,
                    subtitle: '$weeklyOrderCount ${'Orders'.tr}',
                    themeChange: themeChange,
                  ),
                  const SizedBox(height: 12),
                  _earningCard(
                    title: 'Last Payout'.tr,
                    icon: Icons.payments_outlined,
                    color: AppThemeData.info300,
                    amount: lastPayoutAmount,
                    subtitle: lastPayoutAt != null
                        ? DateFormat('dd/MM/yyyy').format(lastPayoutAt.toDate())
                        : 'No payout yet'.tr,
                    themeChange: themeChange,
                  ),
                  const SizedBox(height: 12),
                  _earningCard(
                    title: 'Total Earnings'.tr,
                    icon: Icons.account_balance_wallet_outlined,
                    color: AppThemeData.secondary300,
                    amount: totalEarnings,
                    themeChange: themeChange,
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 16),
          _buildBankDetailsHeader(context, controller, themeChange),
          const SizedBox(height: 20),
          Text(
            'Payout History'.tr,
            style: TextStyle(
              fontFamily: AppThemeData.semiBold,
              fontSize: 16,
              color: themeChange.getThem() ? AppThemeData.grey100 : AppThemeData.grey800,
            ),
          ),
          const SizedBox(height: 8),
          FutureBuilder<QuerySnapshot>(
            future: FireStoreUtils.fireStore
                .collection('weeklyPayouts')
                .where('restaurantId', isEqualTo: vendorId)
                .get(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: Padding(padding: EdgeInsets.all(20), child: CircularProgressIndicator()));
              }
              final docs = List<QueryDocumentSnapshot>.from(snapshot.data?.docs ?? []);
              if (docs.isEmpty) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Center(
                    child: Text(
                      'No payout history'.tr,
                      style: TextStyle(color: themeChange.getThem() ? AppThemeData.grey400 : AppThemeData.grey600),
                    ),
                  ),
                );
              }
              docs.sort((a, b) {
                final aTs = (a.data() as Map<String, dynamic>)['periodStart'] as Timestamp?;
                final bTs = (b.data() as Map<String, dynamic>)['periodStart'] as Timestamp?;
                if (aTs == null || bTs == null) return 0;
                return bTs.compareTo(aTs);
              });
              return Container(
                decoration: ShapeDecoration(
                  color: themeChange.getThem() ? AppThemeData.grey900 : AppThemeData.grey50,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(8),
                  itemCount: docs.length,
                  separatorBuilder: (_, __) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: MySeparator(color: themeChange.getThem() ? AppThemeData.grey700 : AppThemeData.grey200),
                  ),
                  itemBuilder: (context, index) {
                    final d = docs[index].data() as Map<String, dynamic>;
                    final double amount = (d['amount'] ?? 0).toDouble();
                    final String status = d['status'] ?? 'pending';
                    final Timestamp? periodStart = d['periodStart'] as Timestamp?;
                    final Timestamp? periodEnd = d['periodEnd'] as Timestamp?;
                    final String period = (periodStart != null && periodEnd != null)
                        ? '${DateFormat('dd/MM').format(periodStart.toDate())} – ${DateFormat('dd/MM/yyyy').format(periodEnd.toDate())}'
                        : '';
                    final Color statusColor = status == 'paid'
                        ? AppThemeData.success400
                        : status == 'on_hold'
                            ? AppThemeData.warning300
                            : AppThemeData.secondary300;
                    final String statusLabel = status == 'paid'
                        ? 'Paid'.tr
                        : status == 'on_hold'
                            ? 'On Hold'.tr
                            : 'Pending'.tr;

                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  Constant.amountShow(amount: amount.toString()),
                                  style: TextStyle(
                                    fontFamily: AppThemeData.semiBold,
                                    fontSize: 16,
                                    color: themeChange.getThem() ? AppThemeData.grey100 : AppThemeData.grey800,
                                  ),
                                ),
                                if (period.isNotEmpty)
                                  Text(
                                    period,
                                    style: TextStyle(
                                      fontFamily: AppThemeData.regular,
                                      fontSize: 12,
                                      color: themeChange.getThem() ? AppThemeData.grey400 : AppThemeData.grey600,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: statusColor.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              statusLabel,
                              style: TextStyle(fontFamily: AppThemeData.medium, fontSize: 12, color: statusColor),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              );
            },
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _earningCard({
    required String title,
    required IconData icon,
    required Color color,
    required double amount,
    String? subtitle,
    required DarkThemeProvider themeChange,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: themeChange.getThem() ? AppThemeData.grey900 : AppThemeData.grey50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontFamily: AppThemeData.regular,
                    fontSize: 13,
                    color: themeChange.getThem() ? AppThemeData.grey400 : AppThemeData.grey600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  Constant.amountShow(amount: amount.toString()),
                  style: TextStyle(
                    fontFamily: AppThemeData.bold,
                    fontSize: 18,
                    color: themeChange.getThem() ? AppThemeData.grey100 : AppThemeData.grey800,
                  ),
                ),
                if (subtitle != null)
                  Text(
                    subtitle,
                    style: TextStyle(fontFamily: AppThemeData.regular, fontSize: 12, color: color),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBankDetailsHeader(BuildContext context, WalletController controller, DarkThemeProvider themeChange) {
    final bankDetails = Constant.userModel?.userBankDetails;

    return GestureDetector(
      onTap: () => _bankDetailsBottomSheet(context, controller, themeChange),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: themeChange.getThem() ? AppThemeData.grey900 : AppThemeData.grey50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: themeChange.getThem() ? AppThemeData.grey700 : AppThemeData.grey200),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppThemeData.info300.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.account_balance_outlined, color: AppThemeData.info300, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Bank Details'.tr,
                    style: TextStyle(
                      fontFamily: AppThemeData.semiBold,
                      fontSize: 15,
                      color: themeChange.getThem() ? AppThemeData.grey100 : AppThemeData.grey800,
                    ),
                  ),
                  if (bankDetails != null && bankDetails.accountNumber.isNotEmpty)
                    Text(
                      '${bankDetails.bankName} • ${bankDetails.accountNumber}',
                      style: TextStyle(
                        fontFamily: AppThemeData.regular,
                        fontSize: 12,
                        color: themeChange.getThem() ? AppThemeData.grey400 : AppThemeData.grey600,
                      ),
                    )
                  else
                    Text(
                      'Tap to add bank details'.tr,
                      style: const TextStyle(fontFamily: AppThemeData.regular, fontSize: 12, color: AppThemeData.info300),
                    ),
                ],
              ),
            ),
            const Icon(Icons.edit_outlined, color: AppThemeData.info300, size: 18),
          ],
        ),
      ),
    );
  }

  Future<void> _bankDetailsBottomSheet(BuildContext context, WalletController controller, DarkThemeProvider themeChange) async {
    final bankNameCtrl = TextEditingController(text: Constant.userModel?.userBankDetails?.bankName ?? '');
    final ribCtrl = TextEditingController(text: Constant.userModel?.userBankDetails?.accountNumber ?? '');
    final holderCtrl = TextEditingController(text: Constant.userModel?.userBankDetails?.holderName ?? '');
    final branchCtrl = TextEditingController(text: Constant.userModel?.userBankDetails?.branchName ?? '');

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Bank Details'.tr,
                      style: TextStyle(
                        fontFamily: AppThemeData.semiBold,
                        fontSize: 18,
                        color: themeChange.getThem() ? AppThemeData.grey100 : AppThemeData.grey800,
                      ),
                    ),
                  ),
                  InkWell(splashColor: Colors.transparent, onTap: () => Get.back(), child: const Icon(Icons.close)),
                ],
              ),
              const SizedBox(height: 16),
              TextFieldWidget(title: 'Bank Name'.tr, controller: bankNameCtrl, hintText: 'Enter bank name'.tr),
              const SizedBox(height: 8),
              TextFieldWidget(title: 'RIB / Account Number'.tr, controller: ribCtrl, hintText: 'Enter RIB / account number'.tr),
              const SizedBox(height: 8),
              TextFieldWidget(title: 'Account Holder'.tr, controller: holderCtrl, hintText: 'Enter holder name'.tr),
              const SizedBox(height: 8),
              TextFieldWidget(title: 'Branch'.tr, controller: branchCtrl, hintText: 'Enter branch name'.tr),
              const SizedBox(height: 16),
              RoundedButtonFill(
                title: 'Save'.tr,
                color: AppThemeData.secondary300,
                textColor: AppThemeData.grey50,
                height: 5.5,
                onPress: () async {
                  ShowToastDialog.showLoader('Please wait'.tr);
                  Constant.userModel!.userBankDetails = UserBankDetails(
                    bankName: bankNameCtrl.text.trim(),
                    accountNumber: ribCtrl.text.trim(),
                    holderName: holderCtrl.text.trim(),
                    branchName: branchCtrl.text.trim(),
                    otherDetails: Constant.userModel?.userBankDetails?.otherDetails ?? '',
                  );
                  await FireStoreUtils.updateUser(Constant.userModel!);
                  ShowToastDialog.closeLoader();
                  Get.back();
                  ShowToastDialog.showToast('Bank details saved'.tr);
                },
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  InkWell transactionCard(WalletController controller, themeChange, WalletTransactionModel transactionModel) {
    return InkWell(
      splashColor: Colors.transparent,
      onTap: () async {
        await FireStoreUtils.getOrderByOrderId(transactionModel.orderId.toString()).then(
          (value) {
            if (value != null) {
              Get.to(const OrderDetailsScreen(), arguments: {"orderModel": value});
            }
          },
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Row(
          children: [
            Container(
              decoration: ShapeDecoration(
                shape: RoundedRectangleBorder(
                  side: BorderSide(width: 1, color: themeChange.getThem() ? AppThemeData.grey800 : AppThemeData.grey100),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: transactionModel.isTopup == false
                    ? SvgPicture.asset(
                        "assets/icons/ic_debit.svg",
                        height: 16,
                        width: 16,
                      )
                    : SvgPicture.asset(
                        "assets/icons/ic_credit.svg",
                        height: 16,
                        width: 16,
                      ),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          transactionModel.note.toString(),
                          style: TextStyle(
                            fontSize: 16,
                            fontFamily: AppThemeData.semiBold,
                            fontWeight: FontWeight.w600,
                            color: themeChange.getThem() ? AppThemeData.grey100 : AppThemeData.grey800,
                          ),
                        ),
                      ),
                      Text(
                        transactionModel.isTopup == false ? "-${Constant.amountShow(amount: transactionModel.amount.toString())}" : Constant.amountShow(amount: transactionModel.amount.toString()),
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: AppThemeData.medium,
                          color: transactionModel.isTopup == true ? AppThemeData.success400 : AppThemeData.danger300,
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 2,
                  ),
                  Text(
                    Constant.timestampToDateTime(transactionModel.date!),
                    style: TextStyle(fontSize: 12, fontFamily: AppThemeData.medium, fontWeight: FontWeight.w500, color: themeChange.getThem() ? AppThemeData.grey200 : AppThemeData.grey700),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
