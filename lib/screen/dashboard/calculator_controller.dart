import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:expressions/expressions.dart';
import 'dart:math';
import '../../repo/db_calculator.dart';

class CalculatorController extends GetxController {
  var expression = ''.obs;
  var result = ''.obs;

  void appendNumber(String number) {
    expression.value += number;
  }

  void appendOperator(String operator) {
    final lastChar = expression.value.isNotEmpty
        ? expression.value.trim().substring(expression.value.trim().length - 1)
        : '';
    if (lastChar.isNotEmpty && !['+', '-', '*', '/', '(', '√'].contains(lastChar)) {
      expression.value += ' $operator ';
    }
  }

  void appendBracket(String bracket) {
    final lastChar = expression.value.isNotEmpty
        ? expression.value.trim().substring(expression.value.trim().length - 1)
        : '';
    if (bracket == '(') {
      expression.value += bracket;
    } else if (bracket == ')' && lastChar != '(' && !['+', '-', '*', '/', '√'].contains(lastChar)) {
      expression.value += bracket;
    }
  }

  void appendDecimal() {
    final expr = expression.value;
    if (expr.isEmpty || expr.endsWith(' ') || expr.endsWith('(')) {
      expression.value += '0.';
    } else if (!expr.contains(RegExp(r'\.\d*$'))) {
      expression.value += '.';
    }
  }

  void deleteLast() {
    if (expression.value.isNotEmpty) {
      final newExpr = expression.value.substring(0, expression.value.length - 1);
      expression.value = newExpr.endsWith(' ') || newExpr.endsWith('(')
          ? newExpr.substring(0, newExpr.length - 1)
          : newExpr;
    }
  }

  void calculate() {
    try {
      final expr = expression.value;
      final expressionToEvaluate = expr
          .replaceAll('√', 'sqrt(')
          .replaceAll('^2', '**2')
          .replaceAll('^', '**')
          .replaceAll(' ', '');

      final evaluated = _evaluateExpression(expressionToEvaluate);
      result.value = evaluated.toString();
    } catch (e) {
      result.value = 'Error';
    }
    saveToHistory();
  }

  double _evaluateExpression(String expr) {
    try {
      final expression = Expression.parse(expr);
      const evaluator = ExpressionEvaluator();
      final result = evaluator.eval(expression, {});
      return result.toDouble();
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return double.nan;
    }
  }

  void clear() {
    expression.value = '';
    result.value = '';
  }

  Future<void> saveToHistory() async {
    final dbHelper = CalculatorDatabaseHelper();
    await dbHelper.insertCalculatorHistory({
      'expression': expression.value,
      'result': result.value,
    });
  }
}
