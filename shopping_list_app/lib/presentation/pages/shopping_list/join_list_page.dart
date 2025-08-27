// Packages
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Constants
import '../../../core/constants/app_dimensions.dart';

// Controllers
import '../../controllers/shopping_list_controller.dart';

// Widegts
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/loading_widget.dart';

class JoinListPage extends StatelessWidget {
  final ShoppingListController _controller = Get.find();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController codeController = TextEditingController();

  JoinListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Join List')),
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
                        controller: codeController,
                        label: 'List Code',
                        validator: (value) =>
                            value?.isEmpty ?? true ? 'Code is required' : null,
                      ),
                      SizedBox(height: AppDimensions.paddingMedium),
                      CustomButton(
                        text: 'Join',
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _controller.joinList(codeController.text);
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
