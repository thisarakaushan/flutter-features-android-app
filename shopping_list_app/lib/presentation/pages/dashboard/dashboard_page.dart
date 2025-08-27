// Packages
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Constants
import '../../../core/constants/app_dimensions.dart';

// Widgets
import '../../../presentation/widgets/loading_widget.dart';

// Routes
import '../../../routes/app_routes.dart';

// Controllers
import '../../controllers/dashboard_controller.dart';

class DashboardPage extends StatelessWidget {
  final DashboardController _controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Shopping Lists'),
        actions: [
          IconButton(icon: Icon(Icons.logout), onPressed: _controller.logout),
        ],
      ),
      body: Obx(
        () => _controller.isLoading.value
            ? LoadingWidget()
            : _controller.lists.isEmpty
            ? Center(child: Text('No lists found. Create or join one!'))
            : ListView.builder(
                padding: EdgeInsets.all(AppDimensions.paddingMedium),
                itemCount: _controller.lists.length,
                itemBuilder: (context, index) {
                  final list = _controller.lists[index];
                  return Card(
                    child: ListTile(
                      title: Text(list.title),
                      subtitle: Text(list.description ?? ''),
                      onTap: () =>
                          Get.toNamed(AppRoutes.LIST_DETAIL, arguments: list),
                      trailing: IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _controller.deleteList(list.id),
                      ),
                    ),
                  );
                },
              ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () => Get.toNamed(AppRoutes.CREATE_LIST),
            child: Icon(Icons.add),
          ),
          SizedBox(height: AppDimensions.paddingSmall),
          FloatingActionButton(
            onPressed: () => Get.toNamed(AppRoutes.JOIN_LIST),
            child: Icon(Icons.group_add),
          ),
        ],
      ),
    );
  }
}
