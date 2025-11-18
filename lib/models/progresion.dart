/// Modelo que representa la progresión de un atleta
class Progresion {
  final String nombre;
  final double valorInicial;
  final DateTime fechaInicio;
  final List<RegistroProgresion> registros;

  Progresion({
    required this.nombre,
    required this.valorInicial,
    required this.fechaInicio,
    List<RegistroProgresion>? registros,
  }) : registros = registros ?? [];

  /// Agrega un nuevo registro de progresión
  void agregarRegistro(RegistroProgresion registro) {
    registros.add(registro);
  }

  /// Obtiene el último valor registrado
  double? get ultimoValor {
    if (registros.isEmpty) return valorInicial;
    return registros.last.valor;
  }

  /// Calcula la mejora total en porcentaje
  double get mejoraPorcentaje {
    final ultimo = ultimoValor ?? valorInicial;
    return ((ultimo - valorInicial) / valorInicial) * 100;
  }

  /// Convierte a Map para almacenamiento
  Map<String, dynamic> toMap() {
    return {
      'nombre': nombre,
      'valorInicial': valorInicial,
      'fechaInicio': fechaInicio.toIso8601String(),
      'registros': registros.map((r) => r.toMap()).toList(),
    };
  }

  /// Crea desde Map
  factory Progresion.fromMap(Map<String, dynamic> map) {
    return Progresion(
      nombre: map['nombre'] as String,
      valorInicial: map['valorInicial'] as double,
      fechaInicio: DateTime.parse(map['fechaInicio'] as String),
      registros: (map['registros'] as List)
          .map((r) => RegistroProgresion.fromMap(r))
          .toList(),
    );
  }
}

/// Representa un registro individual de progresión
class RegistroProgresion {
  final DateTime fecha;
  final double valor;
  final String? notas;

  RegistroProgresion({
    required this.fecha,
    required this.valor,
    this.notas,
  });

  /// Convierte a Map
  Map<String, dynamic> toMap() {
    return {
      'fecha': fecha.toIso8601String(),
      'valor': valor,
      'notas': notas,
    };
  }

  /// Crea desde Map
  factory RegistroProgresion.fromMap(Map<String, dynamic> map) {
    return RegistroProgresion(
      fecha: DateTime.parse(map['fecha'] as String),
      valor: map['valor'] as double,
      notas: map['notas'] as String?,
    );
  }
}
