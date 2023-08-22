class KeyValue {
  final int index;
  final String value;

  bool get isDigit => int.tryParse(value) != null;

  bool get isSymbol => value == '*' || value == '#';

  KeyValue(this.index, this.value);

  KeyValue.fromIndex(this.index) : value = (index + 1).toString();
}

class KeypadGenerator {
  KeyValue get(int index) {
    switch (index) {
      case 9:
        return KeyValue(9, '*');
      case 10:
        return KeyValue(10, '0');
      case 11:
        return KeyValue(11, '#');
      default:
        return KeyValue.fromIndex(index);
    }
  }
}
