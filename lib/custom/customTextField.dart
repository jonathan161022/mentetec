import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  final String labelText;
  final bool obscureText;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onChanged; // Agrega el parámetro onChanged

  const CustomTextField({
    super.key,
    required this.controller,
    required this.labelText,
    this.obscureText = false,
    this.validator,
    this.onChanged, // Agrega onChanged a los parámetros
  });

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _textHasBeenDeleted =
      false; // Variable para controlar si se ha borrado el texto

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: widget.obscureText,
      decoration: InputDecoration(
        labelText: widget.labelText,
        border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))),
        errorText: _textHasBeenDeleted && widget.controller.text.isEmpty
            ? 'Ingrese ${widget.labelText}'
            : null,
      ),
      onChanged: (value) {
        setState(() {
          // Verifica si se ha borrado el texto
          _textHasBeenDeleted = value.isEmpty;
        });
        widget.onChanged?.call(value); // Llama al onChanged si está definido
      },
      validator: widget.validator,
    );
  }
}
