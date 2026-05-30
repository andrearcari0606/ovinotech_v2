import 'package:flutter/material.dart';

class PesoInput extends StatelessWidget {

  final TextEditingController controller;

  final Function(String)
      onChanged;

  const PesoInput({
    super.key,
    required this.controller,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {

    return Container(
      decoration:
          BoxDecoration(
        color:
            Colors.white,

        borderRadius:
            BorderRadius.circular(
                16),
      ),

      child: TextField(
        controller:
            controller,

        keyboardType:
            TextInputType
                .number,

        textAlign:
            TextAlign.center,

        style:
            const TextStyle(
          fontSize: 20,
          fontWeight:
              FontWeight.w700,
        ),

        decoration:
            InputDecoration(
          labelText:
              "Peso",

          suffixText:
              "kg",

          filled: true,

          fillColor:
              const Color(
                  0xFFF1EFEA),

          border:
              OutlineInputBorder(
            borderRadius:
                BorderRadius.circular(
                    16),

            borderSide:
                BorderSide.none,
          ),

          contentPadding:
              const EdgeInsets.symmetric(
            horizontal:
                18,
            vertical:
                16,
          ),
        ),

        onChanged:
            onChanged,
      ),
    );
  }
}