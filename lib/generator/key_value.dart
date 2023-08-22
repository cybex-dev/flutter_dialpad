class KeyValue {
  final String value;

  bool get isDigit => int.tryParse(value) != null;

  bool get isSymbol => value == '*' || value == '#';

  const KeyValue(this.value);
}

class DigitKey extends KeyValue {
  final int index;

  const DigitKey(this.index, super.value);

  DigitKey.index(this.index) : super(index.toString());
}

enum DialActionKey { backspace, star, hash }

class ActionKey extends KeyValue {
  const ActionKey(DialActionKey action, super.value);

  const ActionKey.backspace() : this(DialActionKey.backspace, '');

  const ActionKey.hash() : this(DialActionKey.hash, '#');

  const ActionKey.star() : this(DialActionKey.star, '*');
}