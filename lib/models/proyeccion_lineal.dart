import 'package:hive/hive.dart';

part 'proyeccion_lineal.g.dart';

/// Niveles de experiencia del deportista
/// Determina las tasas de mejora sostenibles
enum NivelDeportista {
  principiante,  // 5-10% semanal sostenible
  intermedio,    // 3-5% semanal sostenible
  avanzado       // 1-3% semanal sostenible
}

/// Modelo para calcular y almacenar proyecciones lineales de progreso
///
/// Usa la función lineal: f(t) = P₀ + r·t
/// donde:
/// - P₀ = rendimiento inicial
/// - r = tasa de mejora por semana (pendiente)
/// - t = tiempo en semanas
/// - f(t) = rendimiento proyectado en la semana t
@HiveType(typeId: 4)
class ProyeccionLineal extends HiveObject {
  /// Rendimiento inicial (P₀)
  @HiveField(0)
  late double p0;

  /// Tasa de mejora por semana (r)
  /// Representa la pendiente de la función lineal
  @HiveField(1)
  late double r;

  /// Rendimiento objetivo/meta (Pf)
  @HiveField(2)
  late double pf;

  /// Número de semanas para alcanzar la meta
  @HiveField(3)
  late int semanas;

  /// Nivel del deportista
  @HiveField(4)
  late String nivelDeportista;

  /// Proyección calculada para cada semana
  /// proyeccion[t] = f(t) = P₀ + r·t
  @HiveField(5)
  late List<double> proyeccion;

  /// Semanas donde se recomienda descarga
  /// Típicamente cada 3-4 semanas con reducción del 40-50%
  @HiveField(6)
  late List<int> semanasDescarga;

  ProyeccionLineal({
    required this.p0,
    required this.r,
    required this.pf,
    required this.semanas,
    required this.nivelDeportista,
    required this.proyeccion,
    required this.semanasDescarga,
  });

  /// Constructor que calcula la proyección automáticamente
  factory ProyeccionLineal.calcular({
    required double p0,
    required double pf,
    required int semanas,
    required NivelDeportista nivel,
  }) {
    // Calcular tasa de mejora: r = (Pf - P₀) / t
    double r = (pf - p0) / semanas;

    // Generar proyección para cada semana usando f(t) = P₀ + r·t
    List<double> proyeccion = [];
    for (int t = 0; t <= semanas; t++) {
      proyeccion.add(p0 + (r * t));
    }

    // Calcular semanas de descarga (cada 3-4 semanas)
    List<int> semanasDescarga = [];
    for (int semana = 3; semana <= semanas; semana += 4) {
      semanasDescarga.add(semana);
    }

    return ProyeccionLineal(
      p0: p0,
      r: r,
      pf: pf,
      semanas: semanas,
      nivelDeportista: nivel.toString().split('.').last,
      proyeccion: proyeccion,
      semanasDescarga: semanasDescarga,
    );
  }

  /// Calcula el porcentaje de mejora semanal respecto al valor inicial
  ///
  /// % mejora semanal = (r / P₀) × 100
  double get porcentajeMejoraSemanal {
    if (p0 == 0) return 0.0;
    return (r / p0) * 100;
  }

  /// Calcula el porcentaje de mejora total
  ///
  /// % mejora total = [(Pf - P₀) / P₀] × 100
  double get porcentajeMejoraTotal {
    if (p0 == 0) return 0.0;
    return ((pf - p0) / p0) * 100;
  }

  /// Verifica si la tasa de mejora es saludable según el nivel
  ///
  /// Retorna true si la tasa está dentro de los rangos recomendados:
  /// - Principiante: ≤ 10%
  /// - Intermedio: ≤ 5%
  /// - Avanzado: ≤ 3%
  bool get esTasaSaludable {
    double porcentaje = porcentajeMejoraSemanal.abs();

    switch (nivelDeportista) {
      case 'principiante':
        return porcentaje <= 10.0;
      case 'intermedio':
        return porcentaje <= 5.0;
      case 'avanzado':
        return porcentaje <= 3.0;
      default:
        return true;
    }
  }

  /// Obtiene el nivel de riesgo de sobreentrenamiento
  ///
  /// Retorna:
  /// - 'bajo': Tasa saludable (verde)
  /// - 'medio': Tasa elevada pero manejable (amarillo)
  /// - 'alto': Riesgo de sobreentrenamiento (rojo)
  String get nivelRiesgo {
    double porcentaje = porcentajeMejoraSemanal.abs();

    switch (nivelDeportista) {
      case 'principiante':
        if (porcentaje <= 10.0) return 'bajo';
        if (porcentaje <= 15.0) return 'medio';
        return 'alto';
      case 'intermedio':
        if (porcentaje <= 5.0) return 'bajo';
        if (porcentaje <= 8.0) return 'medio';
        return 'alto';
      case 'avanzado':
        if (porcentaje <= 3.0) return 'bajo';
        if (porcentaje <= 5.0) return 'medio';
        return 'alto';
      default:
        return 'bajo';
    }
  }

  /// Obtiene el rendimiento proyectado en una semana específica
  ///
  /// f(t) = P₀ + r·t
  double obtenerProyeccion(int semana) {
    if (semana < 0 || semana > semanas) {
      return p0 + (r * semana); // Calcular si está fuera del rango
    }
    return proyeccion[semana];
  }

  /// Verifica si una semana es de descarga
  bool esSemanaDescarga(int semana) {
    return semanasDescarga.contains(semana);
  }

  /// Obtiene el valor ajustado para una semana de descarga
  ///
  /// En semanas de descarga se reduce el volumen en 40-50%
  double obtenerProyeccionConDescarga(int semana, {double factorDescarga = 0.5}) {
    double valorBase = obtenerProyeccion(semana);
    if (esSemanaDescarga(semana)) {
      return valorBase * factorDescarga;
    }
    return valorBase;
  }

  @override
  String toString() {
    return 'ProyeccionLineal(P₀: $p0, r: ${r.toStringAsFixed(2)}, Pf: $pf, semanas: $semanas, % mejora: ${porcentajeMejoraSemanal.toStringAsFixed(2)}%)';
  }
}
