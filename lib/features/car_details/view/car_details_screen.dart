import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constants.dart';
import '../controller/car_details_controller.dart';

class CarDetailsScreen extends StatelessWidget {
  const CarDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: GetBuilder<CarDetailsController>(
        initState: (_) => Get.find<CarDetailsController>().load(),
        builder: (controller) => Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            iconTheme: const IconThemeData(color: Colors.black),
            title: const Text(
              "سيارتي",
              style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
            centerTitle: true,
          ),
          body: _buildBody(controller),
        ),
      ),
    );
  }

  Widget _buildBody(CarDetailsController controller) {
    if (controller.isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      );
    }

    final car = controller.car;
    if (car == null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.directions_car_outlined,
                size: 80, color: AppColors.textGrey),
            const SizedBox(height: 16),
            const Text(
              "لا توجد سيارة مسجلة",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textGrey,
              ),
            ),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          // حاوية صورة السيارة
          Container(
            height: 180,
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.cardWhite,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Icon(Icons.directions_car,
                size: 80, color: AppColors.primary),
          ),
          const SizedBox(height: 20),

          // حاوية رقم اللوحة
          Container(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
            decoration: BoxDecoration(
              color: AppColors.cardWhite,
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Text(
              car.plateNumber.isEmpty ? "—" : car.plateNumber,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
              ),
            ),
          ),
          const SizedBox(height: 20),

          // تفاصيل السيارة (المعلومات)
          Container(
            decoration: BoxDecoration(
              color: AppColors.cardWhite,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              children: [
                _buildDetailRow("الماركة", car.brand),
                const Divider(),
                _buildDetailRow("الموديل", car.model),
                const Divider(),
                _buildDetailRow("السنة", car.manufacturingYear),
                const Divider(),
                _buildDetailRow("اللون", car.color),
                const Divider(),
                _buildDetailRow("نوع السيارة", car.carTypeName),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ويدجت لتصميم سطر المعلومة
  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: const TextStyle(color: AppColors.textGrey, fontSize: 16)),
          Text(
            value.isEmpty ? "—" : value,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ],
      ),
    );
  }
}
