import 'package:flutter/material.dart';

class Combobox extends StatefulWidget {
  Combobox({
    Key? key,
    required this.items,
    required this.onItemSelected,
    this.selectedItem,
  }) : super(key: key);

  final List<String> items;
  final Function(String?) onItemSelected;
  final String? selectedItem;

  @override
  State<StatefulWidget> createState() => _ComboboxState();
}
class _ComboboxState extends State<Combobox> {
  String? selectedItem;

  void dropdownCallback(String? selectedValue) {
    if(selectedValue is String) {
      setState(() {
        selectedItem = selectedValue;
      });
      widget.onItemSelected(selectedValue);
    }
  }

  @override void initState() {
    super.initState();
    selectedItem = widget.selectedItem;
  }
  @override
  Widget build(BuildContext context) {
    ThemeData appStyle = Theme.of(context);
    //var height = MediaQuery.of(context).size.height;
    //var width = MediaQuery.of(context).size.width;

    return
      DropdownButtonFormField<String>(
        decoration: InputDecoration (
          enabledBorder:  OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(width: 3, color: Color(0xFFC2E1FF)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(width: 3, color: Color(0xFFC2E1FF)),
          ),
        ),
        value: selectedItem,
        items: widget.items.map((item)=>DropdownMenuItem<String>(
            value: item,
            child: Text(item),
        )).toList(),
        onChanged: dropdownCallback,

      );

  }
}