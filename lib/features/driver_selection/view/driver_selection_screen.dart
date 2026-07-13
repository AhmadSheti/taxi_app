import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constants.dart';
import '../controller/driver_selection_controller.dart';

class DriverSelectionScreen extends StatefulWidget {
  const DriverSelectionScreen({Key? key}) : super(key: key);

  @override
  State<DriverSelectionScreen> createState() => _DriverSelectionScreenState();
}

class _DriverSelectionScreenState extends State<DriverSelectionScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late final DriverSelectionController _controller;

  final Color primaryTeal = const Color(0xFF0F4C5C);
  final Color secondaryAmber = const Color(0xFFFFB627);
  final Color textMain = const Color(0xFF1A1A2E);
  final Color textSecondary = const Color(0xFF7A7A8C);
  final Color backgroundLight = const Color(0xFFF8F9FA);

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _controller = Get.put(DriverSelectionController());
    _controller.loadAvailableDrivers();

    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        _controller.changeFilter(_tabController.index);
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: backgroundLight,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0.5,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_new, color: textMain, size: 20),
            onPressed: () => Navigator.pop(context),
          ),
          title: GetBuilder<DriverSelectionController>(
            builder: (controller) => Text(
              '${controller.drivers.length} سائقين متاحين',
              style: TextStyle(
                fontFamily: 'Cairo',
                color: textMain,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
          centerTitle: true,
        ),
        body: Column(
          children: [
            Container(
              color: Colors.white,
              child: TabBar(
                controller: _tabController,
                indicatorColor: primaryTeal,
                labelColor: primaryTeal,
                unselectedLabelColor: textSecondary,
                labelStyle: const TextStyle(
                  fontFamily: 'Cairo',
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
                unselectedLabelStyle: const TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 14,
                ),
                tabs: const [
                  Tab(text: 'الأقرب'),
                  Tab(text: 'الأعلى تقييماً'),
                  Tab(text: 'المفضّلون'),
                  Tab(text: 'الأرخص'),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildDriverList(),
                  _buildDriverList(),
                  _buildDriverList(),
                  _buildDriverList(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDriverList() {
    return GetBuilder<DriverSelectionController>(
      builder: (controller) {
        if (controller.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.drivers.isEmpty) {
          return const Center(child: Text('لا يوجد سائقين متاحين حالياً'));
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: controller.drivers.length,
          itemBuilder: (context, index) {
            final driver = controller.drivers[index];

            return Container(
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    spreadRadius: 1,
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          radius: 28,
                          backgroundColor: primaryTeal.withOpacity(0.1),
                          child: Icon(
                            Icons.person,
                            color: primaryTeal,
                            size: 30,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                driver.name,
                                style: TextStyle(
                                  fontFamily: 'Cairo',
                                  color: textMain,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${driver.model} · ${driver.color}',
                                style: TextStyle(
                                  fontFamily: 'Cairo',
                                  color: textSecondary,
                                  fontSize: 13,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: backgroundLight,
                                  borderRadius: BorderRadius.circular(4),
                                  border: Border.all(
                                    color: Colors.grey.shade300,
                                  ),
                                ),
                                child: Text(
                                  driver.plateNumber.isEmpty
                                      ? 'بدون لوحة'
                                      : driver.plateNumber,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: textMain,
                                    letterSpacing: 1,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Row(
                              children: [
                                Text(
                                  driver.ratingAverage.toStringAsFixed(1),
                                  style: TextStyle(
                                    fontFamily: 'Cairo',
                                    color: textMain,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                const Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                  size: 16,
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text(
                              '${driver.distanceKm.toStringAsFixed(1)} كم',
                              style: TextStyle(
                                fontFamily: 'Cairo',
                                color: textSecondary,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      child: Divider(height: 1),
                    ),
                    SizedBox(
                      width: double.infinity,
                      height: 44,
                      child: ElevatedButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'تم اختيار السائق ${driver.name} بنجاح',
                                style: const TextStyle(fontFamily: 'Cairo'),
                              ),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: secondaryAmber,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          'اطلب هذا السائق',
                          style: TextStyle(
                            fontFamily: 'Cairo',
                            color: textMain,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
