// Packages
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Utils
import '../../../core/utils/validators.dart';

// Controllers
import '../../controllers/shopping_list_controller.dart';

// Widgets
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/loading_widget.dart';

// Constants
import '../../../core/constants/app_dimensions.dart';

class CreateListPage extends StatelessWidget {
  final ShoppingListController _controller = Get.find();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  CreateListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Create List')),
      body: Padding(
        padding: EdgeInsets.all(AppDimensions.paddingMedium),
        child: Obx(
          () => _controller.isLoading.value
              ? LoadingWidget()
              : Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      CustomTextField(
                        controller: titleController,
                        label: 'Title',
                        validator: Validators.validateTitle,
                      ),
                      SizedBox(height: AppDimensions.paddingMedium),
                      CustomTextField(
                        controller: descriptionController,
                        label: 'Description (Optional)',
                      ),
                      SizedBox(height: AppDimensions.paddingMedium),
                      CustomButton(
                        text: 'Create',
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _controller.createList(
                              titleController.text,
                              descriptionController.text.isEmpty
                                  ? null
                                  : descriptionController.text,
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}
