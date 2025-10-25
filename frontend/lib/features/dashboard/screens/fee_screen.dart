import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:school_management/components/custom_app_bar.dart';
import 'package:school_management/components/custom_button.dart';
import 'package:school_management/components/custom_bottom_nav_bar.dart';
import 'package:school_management/components/custom_drawer.dart';
import 'package:school_management/utils/navigation_manager.dart';

class FeeScreen extends StatefulWidget {
  const FeeScreen({super.key});

  @override
  State<FeeScreen> createState() => _FeeScreenState();
}

class _FeeScreenState extends State<FeeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  
  @override
  void initState() {
    super.initState();
    // Set bottom nav index for proper navigation
    NavigationManager.currentBottomNavIndex = 0;
  }
  
  // Sample payment history data
  final List<Map<String, String>> _paymentHistory = [
    {
      'month': 'Jun 24',
      'amount': 'RM 1,290.00',
    },
    {
      'month': 'May 24',
      'amount': 'RM 1,290.00',
    },
    {
      'month': 'Apr 24',
      'amount': 'RM 1,290.00',
    },
    {
      'month': 'Mar 24',
      'amount': 'RM 1,290.00',
    },
  ];
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: const CustomAppBar(
        title: 'Fees',
        showBackButton: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildOutstandingAmount(),
              SizedBox(height: 16.h),
              _buildActionButtons(),
              SizedBox(height: 24.h),
              _buildPaymentHistory(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: NavigationManager.currentBottomNavIndex,
        onTap: (index) {
          NavigationManager.navigateFromBottomBar(index, context);
        },
      ),
    );
  }

  Widget _buildOutstandingAmount() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Outstanding Amount',
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          'RM 3600.00',
          style: TextStyle(
            fontSize: 36.sp,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ],
    );
  }
  
  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              // Handle payment
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF13315C),
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(vertical: 12.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
              elevation: 0,
            ),
            child: Text(
              'Pay',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        SizedBox(width: 12.w),
        TextButton(
          onPressed: () {
            // View fees details
          },
          style: TextButton.styleFrom(
            foregroundColor: Colors.black87,
            padding: EdgeInsets.symmetric(vertical: 12.h),
          ),
          child: Text(
            'View Fees',
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
      ],
    );
  }
  
  Widget _buildPaymentHistory() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Payment History',
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 16.h),
        Column(
          children: _paymentHistory.map((payment) => _buildPaymentItem(
            month: payment['month']!,
            amount: payment['amount']!,
          )).toList(),
        ),
      ],
    );
  }
  
  Widget _buildPaymentItem({
    required String month,
    required String amount,
  }) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(vertical: 16.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                month,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
              Row(
                children: [
                  Text(
                    amount,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                      color: Colors.green,
                    ),
                  ),
                  SizedBox(width: 16.w),
                  InkWell(
                    onTap: () {
                      // Handle download receipt
                    },
                    child: Icon(
                      Icons.download_outlined,
                      color: Colors.black54,
                      size: 24.sp,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Divider(
          color: Colors.grey.shade300,
          height: 1,
        ),
      ],
    );
  }
} 