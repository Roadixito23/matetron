import 'ejercicio.dart';

/// Modelo que representa una rutina semanal de entrenamiento
/// Utiliza una matriz de ejercicios por día de la semana
class Rutina {
  final String nombre;
  final DateTime fechaCreacion;

  /// Matriz de ejercicios: 4 ejercicios × 7 días
  /// matriz[ejercicioIndex][diaIndex]
  final List<List<Ejercicio?>> matriz;

  static const int numEjercicios = 4;
  static const int diasSemana = 7;

  Rutina({
    required this.nombre,
    required this.fechaCreacion,
    List<List<Ejercicio?>>? matriz,
  }) : matriz = matriz ?? _crearMatrizVacia();

  /// Crea una matriz vacía de 4×7
  static List<List<Ejercicio?>> _crearMatrizVacia() {
    return List.generate(
      numEjercicios,
      (_) => List.filled(diasSemana, null),
    );
  }

  /// Obtiene el ejercicio en la posición especificada
  Ejercicio? getEjercicio(int ejercicioIndex, int diaIndex) {
    if (ejercicioIndex >= 0 && ejercicioIndex < numEjercicios &&
        diaIndex >= 0 && diaIndex < diasSemana) {
      return matriz[ejercicioIndex][diaIndex];
    }
    return null;
  }

  /// Establece un ejercicio en la posición especificada
  void setEjercicio(int ejercicioIndex, int diaIndex, Ejercicio? ejercicio) {
    if (ejercicioIndex >= 0 && ejercicioIndex < numEjercicios &&
        diaIndex >= 0 && diaIndex < diasSemana) {
      matriz[ejercicioIndex][diaIndex] = ejercicio;
    }
  }

  /// Calcula el volumen total semanal usando sumatoria
  /// V_total = Σᵢ Σⱼ rᵢⱼ (suma de todas las repeticiones)
  int get volumenTotal {
    int total = 0;
    for (var fila in matriz) {
      for (var ejercicio in fila) {
        if (ejercicio != null) {
          total += ejercicio.volumen;
        }
      }
    }
    return total;
  }

  /// Calcula el volumen por día
  List<int> get volumenPorDia {
    List<int> volumenes = List.filled(diasSemana, 0);
    for (int dia = 0; dia < diasSemana; dia++) {
      for (int ejercicio = 0; ejercicio < numEjercicios; ejercicio++) {
        final ej = matriz[ejercicio][dia];
        if (ej != null) {
          volumenes[dia] += ej.volumen;
        }
      }
    }
    return volumenes;
  }

  /// Calcula el volumen por ejercicio
  List<int> get volumenPorEjercicio {
    List<int> volumenes = List.filled(numEjercicios, 0);
    for (int ejercicio = 0; ejercicio < numEjercicios; ejercicio++) {
      for (int dia = 0; dia < diasSemana; dia++) {
        final ej = matriz[ejercicio][dia];
        if (ej != null) {
          volumenes[ejercicio] += ej.volumen;
        }
      }
    }
    return volumenes;
  }

  /// Convierte la rutina a un Map para almacenamiento
  Map<String, dynamic> toMap() {
    return {
      'nombre': nombre,
      'fechaCreacion': fechaCreacion.toIso8601String(),
      'matriz': matriz.map((fila) =>
        fila.map((ejercicio) => ejercicio?.toMap()).toList()
      ).toList(),
    };
  }

  /// Crea una rutina desde un Map
  factory Rutina.fromMap(Map<String, dynamic> map) {
    return Rutina(
      nombre: map['nombre'] as String,
      fechaCreacion: DateTime.parse(map['fechaCreacion'] as String),
      matriz: (map['matriz'] as List).map((fila) =>
        (fila as List).map((ejercicioMap) =>
          ejercicioMap != null ? Ejercicio.fromMap(ejercicioMap) : null
        ).toList()
      ).toList(),
    );
  }

  @override
  String toString() {
    return 'Rutina(nombre: $nombre, volumenTotal: $volumenTotal)';
  }
}
