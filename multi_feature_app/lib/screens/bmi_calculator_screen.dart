// Packages
import 'package:flutter/material.dart';

// Widgets
import '../widgets/custom_button.dart';
import '../widgets/custom_input_field.dart';

class BMICalculatorScreen extends StatefulWidget {
  const BMICalculatorScreen({super.key});

  @override
  State<BMICalculatorScreen> createState() => _BMICalculatorScreenState();
}

class _BMICalculatorScreenState extends State<BMICalculatorScreen> {
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();
  String _result = '';

  String? _validateInput(String? value) {
    if (value == null || value.isEmpty) {
      return 'This field is required';
    }
    if (double.tryParse(value) == null || double.parse(value) <= 0) {
      return 'Enter a valid number';
    }
    return null;
  }

  void _calculateBMI() {
    if (_formKey.currentState!.validate()) {
      final height =
          double.parse(_heightController.text) / 100; // Convert cm to meters
      final weight = double.parse(_weightController.text);
      final bmi = weight / (height * height);
      setState(() {
        _result = 'BMI: ${bmi.toStringAsFixed(2)}';
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(_result)));
    }
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('BMI Calculator')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              CustomInputField(
                controller: _heightController,
                label: 'Height (cm)',
                keyboardType: TextInputType.number,
                validator: _validateInput,
              ),
              CustomInputField(
                controller: _weightController,
                label: 'Weight (kg)',
                keyboardType: TextInputType.number,
                validator: _validateInput,
              ),
              const SizedBox(height: 20),
              CustomButton(text: 'Calculate BMI', onPressed: _calculateBMI),
              const SizedBox(height: 20),
              Text(_result, style: Theme.of(context).textTheme.headlineSmall),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _heightController.dispose();
    _weightController.dispose();
    super.dispose();
  }
}
