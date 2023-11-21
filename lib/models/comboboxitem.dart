class ComboBoxItem {
  final String text;
  final String value;

  ComboBoxItem(this.text, this.value);

  @override
  bool operator ==(dynamic other) =>
      other != null &&
          other is ComboBoxItem &&
          value == other.value;

  @override
  int get hashCode => value.hashCode;

}

bool compareComboBoxLists(List<ComboBoxItem> list1, List<ComboBoxItem> list2) {
  // Check if the lists have the same length
  if (list1.length != list2.length) {
    return false;
  }

  // Sort the lists to ensure the items are in the same order
  list1.sort((a, b) => a.value.compareTo(b.value));
  list2.sort((a, b) => a.value.compareTo(b.value));

  // Compare each item in the lists
  for (int i = 0; i < list1.length; i++) {
    if (list1[i].value != list2[i].value || list1[i].text != list2[i].text) {
      return false;
    }
  }

  // If all items are equal, the lists are the same
  return true;
}
