import 'package:flutter/material.dart';

/// Constantes de la aplicación MATETRÓN
///
/// Centraliza colores, estilos, textos y configuraciones
class Constantes {
  // ==================== COLORES ====================

  /// Color primario: Dorado/Amarillo (#FFD700)
  static const Color colorPrimario = Color(0xFFFFD700);

  /// Color secundario: Azul (#4A90E2)
  static const Color colorSecundario = Color(0xFF4A90E2);

  /// Fondo oscuro (#2B2B2B)
  static const Color fondoOscuro = Color(0xFF2B2B2B);

  /// Fondo claro para modo light
  static const Color fondoClaro = Color(0xFFF5F5F5);

  /// Texto principal (blanco)
  static const Color textoPrincipal = Color(0xFFFFFFFF);

  /// Texto secundario (gris claro)
  static const Color textoSecundario = Color(0xFFC0C0C0);

  /// Color de éxito: Verde (#50C878)
  static const Color colorExito = Color(0xFF50C878);

  /// Color de advertencia: Naranja (#FFA500)
  static const Color colorAdvertencia = Color(0xFFFFA500);

  /// Color de peligro: Rojo (#E74C3C)
  static const Color colorPeligro = Color(0xFFE74C3C);

  // ==================== TEXTOS ====================

  /// Nombre de la aplicación
  static const String nombreApp = 'MATETRÓN';

  /// Descripción de la aplicación
  static const String descripcionApp =
      'Optimización matemática para entrenamientos deportivos';

  /// Nombres de los días de la semana
  static const List<String> diasSemana = [
    'Lun',
    'Mar',
    'Mié',
    'Jue',
    'Vie',
    'Sáb',
    'Dom',
  ];

  /// Nombres completos de los días
  static const List<String> diasSemanaCompletos = [
    'Lunes',
    'Martes',
    'Miércoles',
    'Jueves',
    'Viernes',
    'Sábado',
    'Domingo',
  ];

  // ==================== LÍMITES Y VALIDACIONES ====================

  /// Número mínimo de ejercicios en una rutina
  static const int minEjercicios = 3;

  /// Número máximo de ejercicios en una rutina
  static const int maxEjercicios = 10;

  /// Número mínimo de series
  static const int minSeries = 1;

  /// Número máximo de series
  static const int maxSeries = 10;

  /// Número mínimo de repeticiones
  static const int minRepeticiones = 1;

  /// Número máximo de repeticiones
  static const int maxRepeticiones = 100;

  /// Número mínimo de semanas para proyección
  static const int minSemanas = 1;

  /// Número máximo de semanas para proyección
  static const int maxSemanas = 20;

  // ==================== TASAS DE MEJORA ====================

  /// Tasa máxima saludable para principiante (%)
  static const double tasaMaxPrincipiante = 10.0;

  /// Tasa mínima esperada para principiante (%)
  static const double tasaMinPrincipiante = 5.0;

  /// Tasa máxima saludable para intermedio (%)
  static const double tasaMaxIntermedio = 5.0;

  /// Tasa mínima esperada para intermedio (%)
  static const double tasaMinIntermedio = 3.0;

  /// Tasa máxima saludable para avanzado (%)
  static const double tasaMaxAvanzado = 3.0;

  /// Tasa mínima esperada para avanzado (%)
  static const double tasaMinAvanzado = 1.0;

  // ==================== DESCARGA ====================

  /// Frecuencia de descarga (cada N semanas)
  static const int frecuenciaDescarga = 4;

  /// Factor de descarga por defecto (50% = 0.5)
  static const double factorDescarga = 0.5;

  // ==================== MENSAJES ====================

  /// Mensaje de tasa saludable
  static const String mensajeTasaSaludable =
      '✓ Tasa de mejora saludable y sostenible';

  /// Mensaje de advertencia
  static const String mensajeAdvertencia =
      '⚠ Tasa elevada. Monitorea tu recuperación';

  /// Mensaje de peligro
  static const String mensajePeligro =
      '⚠ Riesgo de sobreentrenamiento. Considera reducir la meta';

  // ==================== ICONOS ====================

  /// Iconos para los módulos principales
  static const IconData iconoMatriz = Icons.grid_on;
  static const IconData iconoCalculadora = Icons.calculate;
  static const IconData iconoGrafico = Icons.show_chart;
  static const IconData iconoDashboard = Icons.dashboard;

  // ==================== ESTILOS DE TEXTO ====================

  /// Estilo para títulos grandes
  static const TextStyle estiloTituloGrande = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: colorPrimario,
  );

  /// Estilo para títulos medianos
  static const TextStyle estiloTituloMediano = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.bold,
    color: textoPrincipal,
  );

  /// Estilo para subtítulos
  static const TextStyle estiloSubtitulo = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: textoPrincipal,
  );

  /// Estilo para texto normal
  static const TextStyle estiloTextoNormal = TextStyle(
    fontSize: 16,
    color: textoPrincipal,
  );

  /// Estilo para texto secundario
  static const TextStyle estiloTextoSecundario = TextStyle(
    fontSize: 14,
    color: textoSecundario,
  );

  /// Estilo para números grandes (métricas)
  static const TextStyle estiloNumeroGrande = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: colorPrimario,
  );

  // ==================== ANIMACIONES ====================

  /// Duración de animaciones rápidas
  static const Duration duracionAnimacionRapida = Duration(milliseconds: 200);

  /// Duración de animaciones normales
  static const Duration duracionAnimacionNormal = Duration(milliseconds: 300);

  /// Duración de animaciones lentas
  static const Duration duracionAnimacionLenta = Duration(milliseconds: 500);
}

/// Tema de la aplicación
class TemaMatetron {
  /// Tema oscuro (principal)
  static ThemeData get temaOscuro {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: Constantes.colorPrimario,
      scaffoldBackgroundColor: Constantes.fondoOscuro,
      colorScheme: ColorScheme.dark(
        primary: Constantes.colorPrimario,
        secondary: Constantes.colorSecundario,
        surface: Color(0xFF1E1E1E),
        background: Constantes.fondoOscuro,
        error: Constantes.colorPeligro,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Constantes.fondoOscuro,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: Constantes.colorPrimario,
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
        iconTheme: IconThemeData(
          color: Constantes.colorPrimario,
        ),
      ),
      cardTheme: CardThemeData(
        color: Color(0xFF1E1E1E),
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: Constantes.colorPrimario,
          foregroundColor: Colors.black,
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          textStyle: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Color(0xFF1E1E1E),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Constantes.textoSecundario),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Constantes.textoSecundario),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Constantes.colorPrimario, width: 2),
        ),
        labelStyle: TextStyle(color: Constantes.textoSecundario),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: Constantes.colorPrimario,
        foregroundColor: Colors.black,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: Color(0xFF1E1E1E),
        selectedItemColor: Constantes.colorPrimario,
        unselectedItemColor: Constantes.textoSecundario,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
    );
  }

  /// Tema claro (alternativo)
  static ThemeData get temaClaro {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: Constantes.colorPrimario,
      scaffoldBackgroundColor: Constantes.fondoClaro,
      colorScheme: ColorScheme.light(
        primary: Constantes.colorPrimario,
        secondary: Constantes.colorSecundario,
        surface: Colors.white,
        background: Constantes.fondoClaro,
        error: Constantes.colorPeligro,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.white,
        elevation: 2,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: Constantes.colorSecundario,
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
        iconTheme: IconThemeData(
          color: Constantes.colorSecundario,
        ),
      ),
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: Constantes.colorSecundario,
          foregroundColor: Colors.white,
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          textStyle: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.grey[100],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey[400]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Constantes.colorSecundario, width: 2),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: Constantes.colorSecundario,
        foregroundColor: Colors.white,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        selectedItemColor: Constantes.colorSecundario,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
    );
  }
}
