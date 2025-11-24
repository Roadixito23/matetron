import 'package:hive/hive.dart';

part 'registro_progreso.g.dart';

/// Modelo para registrar el progreso histórico de un ejercicio
///
/// Permite llevar un seguimiento del rendimiento alcanzado
/// en diferentes fechas para posteriormente calcular tendencias
/// y proyecciones usando regresión lineal
@HiveType(typeId: 3)
class RegistroProgreso extends HiveObject {
  /// Identificador único del registro
  @HiveField(0)
  late String id;

  /// ID del ejercicio al que pertenece este registro
  @HiveField(1)
  late String ejercicioId;

  /// Fecha en la que se realizó la medición
  @HiveField(2)
  late DateTime fecha;

  /// Valor de rendimiento alcanzado
  /// Puede ser: repeticiones, kg levantados, minutos, etc.
  @HiveField(3)
  late double rendimiento;

  /// Unidad de medida del rendimiento
  /// Ejemplos: 'reps', 'kg', 'min', 'km'
  @HiveField(4)
  late String unidad;

  /// Notas adicionales opcionales
  @HiveField(5)
  String? notas;

  RegistroProgreso({
    required this.id,
    required this.ejercicioId,
    required this.fecha,
    required this.rendimiento,
    required this.unidad,
    this.notas,
  });

  /// Constructor vacío para Hive
  RegistroProgreso.empty()
      : id = '',
        ejercicioId = '',
        fecha = DateTime.now(),
        rendimiento = 0.0,
        unidad = 'reps',
        notas = null;

  /// Copia el registro con nuevos valores opcionales
  RegistroProgreso copyWith({
    String? id,
    String? ejercicioId,
    DateTime? fecha,
    double? rendimiento,
    String? unidad,
    String? notas,
  }) {
    return RegistroProgreso(
      id: id ?? this.id,
      ejercicioId: ejercicioId ?? this.ejercicioId,
      fecha: fecha ?? this.fecha,
      rendimiento: rendimiento ?? this.rendimiento,
      unidad: unidad ?? this.unidad,
      notas: notas ?? this.notas,
    );
  }

  @override
  String toString() {
    return 'RegistroProgreso(fecha: ${fecha.toString().split(' ')[0]}, rendimiento: $rendimiento $unidad)';
  }

  /// Compara dos registros por fecha (para ordenamiento)
  int compareTo(RegistroProgreso other) {
    return fecha.compareTo(other.fecha);
  }
}
