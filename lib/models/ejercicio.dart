import 'package:hive/hive.dart';

part 'ejercicio.g.dart';

/// Modelo para representar un ejercicio físico
///
/// Contiene la información básica de un ejercicio que se puede
/// incluir en una rutina de entrenamiento
@HiveType(typeId: 0)
class Ejercicio extends HiveObject {
  /// Identificador único del ejercicio
  @HiveField(0)
  late String id;

  /// Nombre descriptivo del ejercicio (ej: "Flexiones", "Sentadillas")
  @HiveField(1)
  late String nombre;

  /// Calorías quemadas por unidad (repetición/minuto)
  /// Este campo es opcional y se usa para cálculos de gasto calórico
  @HiveField(2)
  double caloriasPorUnidad;

  /// Fecha y hora de creación del ejercicio
  @HiveField(3)
  late DateTime createdAt;

  Ejercicio({
    required this.id,
    required this.nombre,
    this.caloriasPorUnidad = 0.0,
    DateTime? createdAt,
  }) {
    this.createdAt = createdAt ?? DateTime.now();
  }

  /// Constructor vacío para Hive
  Ejercicio.empty()
      : id = '',
        nombre = '',
        caloriasPorUnidad = 0.0,
        createdAt = DateTime.now();

  @override
  String toString() {
    return 'Ejercicio(id: $id, nombre: $nombre, calorías: $caloriasPorUnidad)';
  }
}
