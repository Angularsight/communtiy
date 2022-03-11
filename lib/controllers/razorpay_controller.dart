

import 'package:communtiy/controllers/firebase_controller.dart';
import 'package:communtiy/getx_ui/ticket_page.dart';
import 'package:communtiy/models/host/host.dart';
import 'package:communtiy/models/party_details.dart';
import 'package:get/get.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class RazorPayController extends GetxController{

  late Razorpay _razorpay;
  PartyDetails? partyDetails;
  HostModel? host;
  String? paymentId;

  void updateTicketDetails(PartyDetails party,HostModel hostDetail){
    partyDetails = party;
    host = hostDetail;
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }
  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    paymentId = response.paymentId;
    // Get.snackbar("Payment Succesful", "Order Id :${response.orderId} \n Payment Id :${response.paymentId} \n Signature : ${response.signature}");
    Get.to(TicketPage());
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    Get.snackbar("Payment Failed", "Error message :${response.message}");

  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    Get.snackbar("Activated external Wallet", "Wallet name : ${response.walletName}");
    }


  void openCheckout(String name, int amount,String contact, String email, List<String> wallet,String hostContact) async {
    var options = {
      'key': 'rzp_test_nlTDgSSBzbj4bS',
      'amount': amount*100,
      'name': name,
      'description': 'Host contact : $hostContact',
      'retry': {'enabled': true, 'max_count': 1},
      'send_sms_hash': true,
      'prefill': {'contact': contact, 'email': email},
      'external': {
        'wallets': [wallet]
      }
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      print('Error: $e');
    }
  }
}