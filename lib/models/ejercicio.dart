/// Modelo que representa un ejercicio individual en la rutina
class Ejercicio {
  final String nombre;
  final int series;
  final int repeticiones;
  final double? peso; // Opcional, puede ser null

  Ejercicio({
    required this.nombre,
    required this.series,
    required this.repeticiones,
    this.peso,
  });

  /// Calcula el volumen total del ejercicio (series × repeticiones)
  int get volumen => series * repeticiones;

  /// Convierte el ejercicio a un Map para almacenamiento
  Map<String, dynamic> toMap() {
    return {
      'nombre': nombre,
      'series': series,
      'repeticiones': repeticiones,
      'peso': peso,
    };
  }

  /// Crea un ejercicio desde un Map
  factory Ejercicio.fromMap(Map<String, dynamic> map) {
    return Ejercicio(
      nombre: map['nombre'] as String,
      series: map['series'] as int,
      repeticiones: map['repeticiones'] as int,
      peso: map['peso'] as double?,
    );
  }

  /// Crea una copia del ejercicio con valores modificados
  Ejercicio copyWith({
    String? nombre,
    int? series,
    int? repeticiones,
    double? peso,
  }) {
    return Ejercicio(
      nombre: nombre ?? this.nombre,
      series: series ?? this.series,
      repeticiones: repeticiones ?? this.repeticiones,
      peso: peso ?? this.peso,
    );
  }

  @override
  String toString() {
    return 'Ejercicio(nombre: $nombre, series: $series, repeticiones: $repeticiones, peso: $peso)';
  }
}
