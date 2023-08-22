import 'key_value.dart';

class KeypadGenerator {
  KeyValue get(int index) {
    switch (index) {
      case 9:
        return ActionKey.star();
      case 10:
        return DigitKey(10, '0');
      case 11:
        return ActionKey.hash();
      default:
        return DigitKey.index(index);
    }
  }
}
