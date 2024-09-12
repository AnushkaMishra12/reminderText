import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dashboard/calculator_controller.dart';
import 'history_calculator.dart';

class CalculatorScreen extends StatelessWidget {
  CalculatorScreen({super.key});
  final CalculatorController _controller = Get.put(CalculatorController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white60,
      appBar: AppBar(
        backgroundColor: Colors.black12,
        title: const Text('Calculator',style: TextStyle(color: Colors.black),),
        actions: [
          IconButton(
            icon: const Icon(Icons.history,color: Colors.black,),
            onPressed: () => Get.to(() => const HistoryScreen()),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Obx(() => Container(
              padding: const EdgeInsets.all(10),
            decoration:const BoxDecoration(color: Colors.white60,borderRadius: BorderRadius.all(Radius.circular(10))),
              child: TextField(
                controller: TextEditingController(text: _controller.expression.value),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Enter expression',
                ),
                readOnly: true,
              ),
            )),
            Obx(() => Container(
              margin: const EdgeInsets.all(10),
              child: Text(
                _controller.result.value,
                style: const TextStyle(fontSize: 24,color: Colors.red,fontWeight: FontWeight.bold),
              ),
            )),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: 5.0,
                  mainAxisSpacing: 5.0,
                ),
                itemCount: 21,
                itemBuilder: (context, index) {
                  switch (index) {
                    case 0:
                      return _buildButton('C', _controller.clear, isOperator: true);
                    case 1:
                      return _buildButton('1', () => _controller.appendNumber('1'));
                    case 2:
                      return _buildButton('2', () => _controller.appendNumber('2'));
                    case 3:
                      return _buildButton('3', () => _controller.appendNumber('3'));
                    case 4:
                      return _buildButton('+', () => _controller.appendOperator('+'), isOperator: true);
                    case 5:
                      return _buildButton('4', () => _controller.appendNumber('4'));
                    case 6:
                      return _buildButton('5', () => _controller.appendNumber('5'));
                    case 7:
                      return _buildButton('6', () => _controller.appendNumber('6'));
                    case 8:
                      return _buildButton('-', () => _controller.appendOperator('-'), isOperator: true);
                    case 9:
                      return _buildButton('7', () => _controller.appendNumber('7'));
                    case 10:
                      return _buildButton('8', () => _controller.appendNumber('8'));
                    case 11:
                      return _buildButton('9', () => _controller.appendNumber('9'));
                    case 12:
                      return _buildButton('*', () => _controller.appendOperator('*'), isOperator: true);
                    case 13:
                      return _buildButton('(', () => _controller.appendBracket('('), isOperator: true);
                    case 14:
                      return _buildButton('0', () => _controller.appendNumber('0'));
                    case 15:
                      return _buildButton('.', _controller.appendDecimal);
                    case 16:
                      return _buildButton(')', () => _controller.appendBracket(')'), isOperator: true);
                    case 17:
                      return _buildButton('/', () => _controller.appendOperator('/'), isOperator: true);
                    case 18:
                      return _buildButton('√', () => _controller.appendOperator('√'), isOperator: true);
                    case 19:
                      return _buildButton('del', _controller.deleteLast, isOperator: true);
                    case 20:
                      return _buildButton('=', _controller.calculate, isOperator: true); // Equals button
                    default:
                      return Container();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildButton(String text, VoidCallback onPressed, {bool isOperator = false}) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: isOperator ? Colors.lightBlueAccent : Colors.grey[300],
        foregroundColor: isOperator ? Colors.white : Colors.black,
        iconColor: Colors.black,
        minimumSize: const Size(60, 60),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
      ),
      child: Text(text, style: const TextStyle(fontSize: 18)),
    );
  }
}
