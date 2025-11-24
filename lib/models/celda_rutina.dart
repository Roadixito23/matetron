import 'package:hive/hive.dart';

part 'celda_rutina.g.dart';

/// Modelo para representar una celda en la matriz de rutinas
///
/// Cada celda contiene la información de series y repeticiones
/// para un ejercicio específico en un día específico de la semana
@HiveType(typeId: 1)
class CeldaRutina extends HiveObject {
  /// Número de series a realizar
  @HiveField(0)
  int series;

  /// Número de repeticiones por serie
  @HiveField(1)
  int repeticiones;

  CeldaRutina({
    required this.series,
    required this.repeticiones,
  });

  /// Constructor vacío (sin ejercicio para ese día)
  CeldaRutina.empty()
      : series = 0,
        repeticiones = 0;

  /// Cálculo del volumen: series × repeticiones
  ///
  /// Esta es la métrica fundamental para medir el trabajo total
  /// realizado en un ejercicio específico en un día
  int get volumen => series * repeticiones;

  /// Verifica si la celda está vacía (sin ejercicio programado)
  bool get estaVacia => series == 0 || repeticiones == 0;

  /// Copia la celda con nuevos valores opcionales
  CeldaRutina copyWith({
    int? series,
    int? repeticiones,
  }) {
    return CeldaRutina(
      series: series ?? this.series,
      repeticiones: repeticiones ?? this.repeticiones,
    );
  }

  @override
  String toString() {
    if (estaVacia) return 'Descanso';
    return '$series × $repeticiones = $volumen';
  }
}
