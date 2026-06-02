import 'package:get/get.dart';

class EarningsController extends GetxController {
  RxInt walletBalance = 124000.obs;
  RxInt todayEarnings = 12450.obs;
  RxInt weeklyEarnings = 68000.obs;
  RxInt monthlyEarnings = 124000.obs;
  RxInt totalEarnings = 845000.obs;

  // Monthly revenue data (Last 6 months)
  final List<double> monthlyRevenueData = [
    85000,
    95000,
    105000,
    115000,
    120000,
    124000,
  ];

  final List<String> months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun'];

  // Transaction history
  RxList<Transaction> transactions = <Transaction>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadTransactions();
  }

  void loadTransactions() {
    transactions.value = [
      Transaction(
        id: '1',
        title: 'Booking Payment',
        subtitle: 'Rahul Sharma - Hyundai Creta',
        amount: 2499,
        time: 'Today, 2:30 PM',
        isCredit: true,
      ),
      Transaction(
        id: '2',
        title: 'Booking Payment',
        subtitle: 'Priya Patel - Royal Enfield',
        amount: 1196,
        time: 'Today, 11:15 AM',
        isCredit: true,
      ),
      Transaction(
        id: '3',
        title: 'Withdrawal',
        subtitle: 'Bank Transfer - HDFC Bank',
        amount: 50000,
        time: 'Yesterday, 4:20 PM',
        isCredit: false,
      ),
      Transaction(
        id: '4',
        title: 'Booking Payment',
        subtitle: 'Amit Kumar - Honda Activa',
        amount: 799,
        time: 'Yesterday, 9:45 AM',
        isCredit: true,
      ),
    ];
  }

  void withdrawMoney() {
    Get.defaultDialog(
      title: "Withdraw Money",
      middleText: "Enter amount to withdraw",
      textConfirm: "Withdraw",
      textCancel: "Cancel",
      onConfirm: () {
        Get.back();
        Get.snackbar(
          "Success",
          "Withdrawal request submitted",
          snackPosition: SnackPosition.BOTTOM,
        );
      },
    );
  }

  void refreshEarnings() {
    Get.snackbar(
      "Refreshed",
      "Earnings data updated",
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}

class Transaction {
  final String id;
  final String title;
  final String subtitle;
  final int amount;
  final String time;
  final bool isCredit;

  Transaction({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.amount,
    required this.time,
    required this.isCredit,
  });
}
