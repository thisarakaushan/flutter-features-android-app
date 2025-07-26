// Packages
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Controllers
import '../controllers/calculator_controller.dart';

class SimpleCalculatorScreen extends StatelessWidget {
  const SimpleCalculatorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final CalculatorController controller = Get.put(CalculatorController());

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Calculator'),
        backgroundColor: Colors.grey[900],
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Display Area
          Expanded(
            flex: 2,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Obx(
                    () => Text(
                      controller.operation.value.isNotEmpty
                          ? '${controller.firstNumber.toInt()} ${controller.operation.value}'
                          : '',
                      style: TextStyle(color: Colors.grey[400], fontSize: 20),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Obx(
                    () => Text(
                      controller.display.value,
                      style: TextStyle(
                        color: controller.hasError.value
                            ? Colors.red
                            : Colors.white,
                        fontSize: 48,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Buttons Area
          Expanded(
            flex: 3,
            child: Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // First row: AC, C, ⌫, ÷
                  Expanded(
                    child: Row(
                      children: [
                        _buildButton(
                          'AC',
                          controller.clear,
                          color: Colors.grey[600]!,
                          textColor: Colors.black,
                        ),
                        _buildButton(
                          'C',
                          controller.clearEntry,
                          color: Colors.grey[600]!,
                          textColor: Colors.black,
                        ),
                        _buildButton(
                          '⌫',
                          controller.backspace,
                          color: Colors.grey[600]!,
                          textColor: Colors.black,
                        ),
                        _buildButton(
                          '÷',
                          () => controller.setOperation('÷'),
                          color: Colors.orange,
                        ),
                      ],
                    ),
                  ),
                  // Second row: 7, 8, 9, ×
                  Expanded(
                    child: Row(
                      children: [
                        _buildButton('7', () => controller.inputNumber('7')),
                        _buildButton('8', () => controller.inputNumber('8')),
                        _buildButton('9', () => controller.inputNumber('9')),
                        _buildButton(
                          '×',
                          () => controller.setOperation('×'),
                          color: Colors.orange,
                        ),
                      ],
                    ),
                  ),
                  // Third row: 4, 5, 6, -
                  Expanded(
                    child: Row(
                      children: [
                        _buildButton('4', () => controller.inputNumber('4')),
                        _buildButton('5', () => controller.inputNumber('5')),
                        _buildButton('6', () => controller.inputNumber('6')),
                        _buildButton(
                          '-',
                          () => controller.setOperation('-'),
                          color: Colors.orange,
                        ),
                      ],
                    ),
                  ),
                  // Fourth row: 1, 2, 3, +
                  Expanded(
                    child: Row(
                      children: [
                        _buildButton('1', () => controller.inputNumber('1')),
                        _buildButton('2', () => controller.inputNumber('2')),
                        _buildButton('3', () => controller.inputNumber('3')),
                        _buildButton(
                          '+',
                          () => controller.setOperation('+'),
                          color: Colors.orange,
                        ),
                      ],
                    ),
                  ),
                  // Fifth row: 0, ., =
                  Expanded(
                    child: Row(
                      children: [
                        _buildButton(
                          '0',
                          () => controller.inputNumber('0'),
                          flex: 2,
                        ),
                        _buildButton('.', controller.inputDecimal),
                        _buildButton(
                          '=',
                          controller.calculate,
                          color: Colors.orange,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButton(
    String text,
    VoidCallback onPressed, {
    Color color = const Color(0xFF333333),
    Color textColor = Colors.white,
    int flex = 1,
  }) {
    return Expanded(
      flex: flex,
      child: Container(
        margin: const EdgeInsets.all(4),
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: color,
            foregroundColor: textColor,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            padding: const EdgeInsets.all(0),
          ),
          child: Container(
            height: double.infinity,
            alignment: Alignment.center,
            child: Text(
              text,
              style: TextStyle(
                fontSize: text == '0' ? 24 : 28,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
