import 'package:flutter/material.dart';

ThemeData lightMode = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.light(
    primary: const Color(0xFF1B5E20), // Solo para texto o detalles mínimos
    surface: Colors.white, // Un fondo casi blanco para que resalte la tarjeta
  ),
  
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: Colors.white, // Campos blancos
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
    // Borde sutil cuando no se está usando
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
    ),
    // Borde cuando el usuario hace clic para escribir
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Color(0xFF1B5E20), width: 1.5),
    ),
  ),
);