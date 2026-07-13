import 'package:get/get.dart';

import '../../../core/network/api_constants.dart';
import '../../../core/network/api_method.dart';
import '../../../core/network/api_service.dart';

class HistoryController extends GetxController {
  bool isLoading = false;
  bool hasError = false;
  String errorMessage = '';

  String selectedTab = 'الكل';
  String statusFilter = 'all';
  int currentPage = 1;
  int lastPage = 1;
  int total = 0;
  final int perPage = 20;

  final List<Map<String, String>> tabs = [
    {'label': 'الكل', 'status': 'all'},
    {'label': 'اليوم', 'status': 'all'},
    {'label': 'مكتملة', 'status': 'completed'},
    {'label': 'ملغاة', 'status': 'cancelled'},
  ];

  final List<Map<String, dynamic>> trips = [];

  List<Map<String, dynamic>> get visibleTrips {
    if (selectedTab == 'اليوم') {
      final now = DateTime.now();
      return trips.where((trip) {
        final completedAt = trip['completed_at'];
        if (completedAt is String) {
          final date = DateTime.tryParse(completedAt);
          if (date != null) {
            return date.year == now.year &&
                date.month == now.month &&
                date.day == now.day;
          }
        }
        return false;
      }).toList();
    }
    return trips;
  }

  @override
  void onInit() {
    super.onInit();
    fetchHistory();
  }

  void setSelectedTab(String tab) {
    selectedTab = tab;
    statusFilter = tabs.firstWhere((item) => item['label'] == tab)['status']!;
    currentPage = 1;
    fetchHistory();
  }

  Future<void> fetchHistory({int page = 1}) async {
    isLoading = true;
    hasError = false;
    errorMessage = '';
    update();

    final result = await ApiService.instance.makeRequest(
      method: ApiMethod.get,
      endPoint: 'api/customer/rides',
      queryParams: {'status': statusFilter, 'page': page, 'per_page': perPage},
    );

    isLoading = false;
    result.fold(
      (error) {
        hasError = true;
        errorMessage = error;
        trips.clear();
        update();
      },
      (data) {
        final responseData = data['data'] ?? data;
        trips.clear();
        if (responseData is List) {
          for (final item in responseData) {
            if (item is Map<String, dynamic>) {
              trips.add(item);
            } else if (item is Map) {
              trips.add(Map<String, dynamic>.from(item));
            }
          }
        }

        final pagination = data['pagination'];
        if (pagination is Map<String, dynamic>) {
          currentPage =
              int.tryParse(pagination['current_page']?.toString() ?? '') ??
              currentPage;
          lastPage =
              int.tryParse(pagination['last_page']?.toString() ?? '') ??
              lastPage;
          total = int.tryParse(pagination['total']?.toString() ?? '') ?? total;
        }

        update();
      },
    );
  }
}
