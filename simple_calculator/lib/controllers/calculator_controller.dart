import 'package:get/get.dart';

class CalculatorController extends GetxController {
  var display = '0'.obs;
  var firstNumber = 0.0;
  var secondNumber = 0.0;
  var operation = ''.obs;
  var waitingForSecondNumber = false.obs;
  var hasError = false.obs;

  void inputNumber(String number) {
    if (hasError.value) {
      clear();
    }

    if (display.value == '0' || waitingForSecondNumber.value) {
      display.value = number;
      waitingForSecondNumber.value = false;
    } else {
      display.value += number;
    }
  }

  void inputDecimal() {
    if (hasError.value) {
      clear();
    }

    if (waitingForSecondNumber.value) {
      display.value = '0.';
      waitingForSecondNumber.value = false;
    } else if (!display.value.contains('.')) {
      display.value += '.';
    }
  }

  void setOperation(String op) {
    if (hasError.value) {
      clear();
    }

    if (!waitingForSecondNumber.value && operation.value.isNotEmpty) {
      calculate();
    }

    firstNumber = double.tryParse(display.value) ?? 0.0;
    operation.value = op;
    waitingForSecondNumber.value = true;
  }

  void calculate() {
    if (operation.value.isEmpty) return;

    secondNumber = double.tryParse(display.value) ?? 0.0;
    double result = 0.0;
    hasError.value = false;

    try {
      switch (operation.value) {
        case '+':
          result = firstNumber + secondNumber;
          break;
        case '-':
          result = firstNumber - secondNumber;
          break;
        case '×':
          result = firstNumber * secondNumber;
          break;
        case '÷':
          if (secondNumber == 0) {
            display.value = 'Error';
            hasError.value = true;
            return;
          }
          result = firstNumber / secondNumber;
          break;
      }

      // Format result to avoid unnecessary decimals
      if (result == result.toInt()) {
        display.value = result.toInt().toString();
      } else {
        display.value = result
            .toStringAsFixed(8)
            .replaceAll(RegExp(r'0*$'), '')
            .replaceAll(RegExp(r'\.$'), '');
      }

      operation.value = '';
      waitingForSecondNumber.value = true;
    } catch (e) {
      display.value = 'Error';
      hasError.value = true;
    }
  }

  void clear() {
    display.value = '0';
    firstNumber = 0.0;
    secondNumber = 0.0;
    operation.value = '';
    waitingForSecondNumber.value = false;
    hasError.value = false;
  }

  void clearEntry() {
    display.value = '0';
  }

  void backspace() {
    if (hasError.value) {
      clear();
      return;
    }

    if (display.value.length > 1) {
      display.value = display.value.substring(0, display.value.length - 1);
    } else {
      display.value = '0';
    }
  }
}
