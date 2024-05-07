import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  final String labelText;
  final bool obscureText;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onChanged;
  final IconData? icon;
  final IconData? suffixIcon;
  final IconData? prefixIcon;
  final List<String>? dropdownItems;
  final TextInputType? keyboardType;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.labelText,
    this.obscureText = false,
    this.validator,
    this.onChanged,
    this.icon,
    this.suffixIcon,
    this.prefixIcon,
    this.dropdownItems,
    this.keyboardType,
  });

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _textHasBeenDeleted = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          keyboardType: widget.keyboardType,
          controller: widget.controller,
          obscureText: widget.obscureText,
          decoration: InputDecoration(
            prefixIcon:
                widget.prefixIcon == null ? null : Icon(widget.prefixIcon),
            suffixIcon:
                widget.suffixIcon == null ? null : Icon(widget.suffixIcon),
            icon: widget.icon == null ? null : Icon(widget.icon),
            labelText: widget.labelText,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            errorText: _textHasBeenDeleted && widget.controller.text.isEmpty
                ? 'Ingrese ${widget.labelText}'
                : null,
          ),
          onChanged: (value) {
            setState(() {
              _textHasBeenDeleted = value.isEmpty;
            });
            widget.onChanged?.call(value);
          },
          validator: widget.validator,
        ),
        if (widget.dropdownItems != null) ...[
          const SizedBox(height: 10),
          DropdownButtonFormField<String>(
            value: null,
            items: widget.dropdownItems!.map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                widget.controller.text = newValue ?? '';
              });
            },
          ),
        ],
      ],
    );
  }
}
