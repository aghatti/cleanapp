import 'package:team_coord/models/comboboxitem.dart';
import 'package:flutter/material.dart';

class Combobox extends StatefulWidget {
  const Combobox({
    Key? key,
    required this.items,
    required this.onItemSelected,
    this.selectedItem,
    required this.label,
  }) : super(key: key);

  final List<ComboBoxItem> items;
  final Function(ComboBoxItem?) onItemSelected;
  final ComboBoxItem? selectedItem;
  final String label;

  @override
  State<StatefulWidget> createState() => _ComboboxState();
}



class _ComboboxState extends State<Combobox> {
  ComboBoxItem? selectedItem;

  void dropdownCallback(ComboBoxItem? selectedValue) {
    if(selectedValue != null) {
      setState(() {
        selectedItem = selectedValue;
      });
      widget.onItemSelected(selectedItem);
    }
  }

  @override void initState() {
    super.initState();
    selectedItem = widget.selectedItem;
  }
  @override
  Widget build(BuildContext context) {
    //ThemeData appStyle = Theme.of(context);

    return
      DropdownButtonFormField<ComboBoxItem>(
        decoration: InputDecoration (
          enabledBorder:  OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(width: 3, color: Color(0xFFC2E1FF)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(width: 3, color: Color(0xFFC2E1FF)),
          ),
          labelText: widget.label,
        ),
        value: selectedItem,
        items: widget.items.map((item)=>DropdownMenuItem<ComboBoxItem>(
            value: item,
            child: Text(item.text),
        )).toList(),
        onChanged: dropdownCallback,

      );

  }
}