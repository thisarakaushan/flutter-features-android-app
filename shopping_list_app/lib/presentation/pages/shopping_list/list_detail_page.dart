// Packages
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Controllers
import '../../controllers/list_item_controller.dart';

// Models
import '../../../data/models/shopping_list_model.dart';

// Widgets
import '../../widgets/custom_text_field.dart';
import '../../widgets/list_item_card.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/loading_widget.dart';

// Constants
import '../../../core/constants/app_dimensions.dart';

class ListDetailPage extends StatelessWidget {
  final ListItemController _controller = Get.find();
  final ShoppingListModel list = Get.arguments;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    _controller.fetchItems(list.id);
    return Scaffold(
      appBar: AppBar(title: Text(list.title)),
      body: Obx(
        () => _controller.isLoading.value
            ? LoadingWidget()
            : Column(
                children: [
                  Padding(
                    padding: EdgeInsets.all(AppDimensions.paddingMedium),
                    child: Form(
                      key: _formKey,
                      child: Row(
                        children: [
                          Expanded(
                            child: CustomTextField(
                              controller: nameController,
                              label: 'Item Name',
                              validator: (value) => value?.isEmpty ?? true
                                  ? 'Name is required'
                                  : null,
                            ),
                          ),
                          SizedBox(width: AppDimensions.paddingSmall),
                          SizedBox(
                            width: 100,
                            child: CustomTextField(
                              controller: quantityController,
                              label: 'Qty',
                              keyboardType: TextInputType.number,
                              validator: (value) => value?.isEmpty ?? true
                                  ? 'Qty is required'
                                  : null,
                            ),
                          ),
                          SizedBox(width: AppDimensions.paddingSmall),
                          CustomButton(
                            text: 'Add',
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                _controller.addItem(
                                  list.id,
                                  nameController.text,
                                  int.parse(quantityController.text),
                                );
                                nameController.clear();
                                quantityController.clear();
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: _controller.items.isEmpty
                        ? Center(child: Text('No items in this list'))
                        : ListView.builder(
                            padding: EdgeInsets.all(
                              AppDimensions.paddingMedium,
                            ),
                            itemCount: _controller.items.length,
                            itemBuilder: (context, index) {
                              final item = _controller.items[index];
                              return ListItemCard(
                                item: item,
                                onToggle: () => _controller.updateItem(
                                  list.id,
                                  item.copyWith(isBought: !item.isBought),
                                ),
                                onDelete: () =>
                                    _controller.deleteItem(list.id, item.id),
                              );
                            },
                          ),
                  ),
                ],
              ),
      ),
    );
  }
}
