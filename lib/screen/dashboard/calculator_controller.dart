import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:expressions/expressions.dart';
import '../../repo/db_calculator.dart';

class CalculatorController extends GetxController {
  var expression = ''.obs;
  var result = ''.obs;
  RxBool isNextOpenParenthesis = true.obs;
  void appendNumber(String number) {
    expression.value += number;
  }

  void appendOperator(String operator) {
    final lastChar = expression.value.isNotEmpty
        ? expression.value.trim().substring(expression.value.trim().length - 1)
        : '';
    if (lastChar.isNotEmpty && !['+', '-', '*', '/', '('].contains(lastChar)) {
      expression.value += ' $operator ';
    }
  }
  void appendPercentage(String operator) {
    if (operator == '%') {
      if (expression.isNotEmpty) {
        String currentExpression = expression.value;

        RegExp regExp = RegExp(r'[\+\-\*\/]');
        Iterable<RegExpMatch> matches = regExp.allMatches(currentExpression);

        if (matches.isNotEmpty) {
          RegExpMatch lastMatch = matches.last;

          String leftSide = currentExpression.substring(0, lastMatch.start);
          String operator = currentExpression[lastMatch.start];
          String rightSide = currentExpression.substring(lastMatch.start + 1);
          double leftValue = double.tryParse(leftSide) ?? 0;
          double rightValue = double.tryParse(rightSide) ?? 0;
          double percentageResult = (leftValue * rightValue) / 100;


          expression.value = leftValue.toString() + operator + percentageResult.toString();
        } else {
          double currentValue = double.tryParse(currentExpression) ?? 0;
          expression.value = (currentValue / 100).toString();
        }
      }
    } else {
      expression.value += operator;
    }
  }

  void appendParenthesis() {
    if (isNextOpenParenthesis.value) {
      expression.value += '(';
    } else {
      expression.value += ')';
    }
    isNextOpenParenthesis.value = !isNextOpenParenthesis.value;
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
