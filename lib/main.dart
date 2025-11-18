import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const MatetronApp());
}

/// MATETRÓN - Sistema Digital de Optimización Matemática para Entrenamientos Deportivos
/// Proyecto de Funciones y Matrices - INACAP
/// Desarrollado por: Sebastián Reyes y Dante Agüero
/// Profesora: Rosalba Margot Barros Rojas
class MatetronApp extends StatelessWidget {
  const MatetronApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MATETRÓN',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // Paleta de colores del proyecto
        // Primario: #c41e3a (Rojo)
        // Secundario: #f39c12 (Amarillo/Naranja)
        // Acento: #8e44ad (Morado)
        primaryColor: const Color(0xFFc41e3a),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFc41e3a),
          secondary: const Color(0xFFf39c12),
          tertiary: const Color(0xFF8e44ad),
          brightness: Brightness.light,
        ),

        // AppBar personalizado
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFc41e3a),
          foregroundColor: Colors.white,
          elevation: 2,
          centerTitle: true,
          titleTextStyle: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),

        // Fondo general
        scaffoldBackgroundColor: const Color(0xFFf5f5f5),

        // Cards
        cardTheme: CardTheme(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          color: Colors.white,
        ),

        // Botones elevados
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFc41e3a),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 12,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            elevation: 2,
          ),
        ),

        // Botones de texto
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: const Color(0xFFc41e3a),
          ),
        ),

        // Inputs
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.grey[300]!),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(
              color: Color(0xFFc41e3a),
              width: 2,
            ),
          ),
          filled: true,
          fillColor: Colors.white,
        ),

        // FloatingActionButton
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Color(0xFFf39c12),
          foregroundColor: Colors.white,
        ),

        // Texto general
        textTheme: const TextTheme(
          headlineLarge: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
          headlineMedium: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
          bodyLarge: TextStyle(
            fontSize: 16,
            color: Colors.black87,
          ),
          bodyMedium: TextStyle(
            fontSize: 14,
            color: Colors.black87,
          ),
        ),

        // Material 3
        useMaterial3: true,
      ),

      // Tema oscuro (opcional)
      darkTheme: ThemeData(
        primaryColor: const Color(0xFFc41e3a),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFc41e3a),
          secondary: const Color(0xFFf39c12),
          tertiary: const Color(0xFF8e44ad),
          brightness: Brightness.dark,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFc41e3a),
          foregroundColor: Colors.white,
        ),
        scaffoldBackgroundColor: const Color(0xFF121212),
        useMaterial3: true,
      ),

      // Modo de tema (puede ser cambiado a ThemeMode.dark)
      themeMode: ThemeMode.light,

      // Pantalla inicial
      home: const HomeScreen(),
    );
  }
}
