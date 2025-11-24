import 'dart:math' as math;
import '../models/registro_progreso.dart';

/// Clase para realizar cálculos de regresión lineal simple
///
/// Implementa el método de mínimos cuadrados para encontrar
/// la línea de mejor ajuste: y = mx + b
///
/// Donde:
/// - m = pendiente (tasa de cambio)
/// - b = intercepto (valor inicial)
/// - R² = coeficiente de determinación (calidad del ajuste)
class RegresionLineal {
  /// Pendiente de la recta (m)
  final double pendiente;

  /// Intercepto con el eje Y (b)
  final double intercepto;

  /// Coeficiente de determinación R² (0 a 1)
  /// Indica qué tan bien se ajustan los datos a la línea
  /// R² = 1: ajuste perfecto
  /// R² = 0: sin correlación
  final double r2;

  /// Número de puntos de datos usados
  final int n;

  RegresionLineal({
    required this.pendiente,
    required this.intercepto,
    required this.r2,
    required this.n,
  });

  /// Calcula la regresión lineal a partir de una lista de registros
  ///
  /// Usa el método de mínimos cuadrados:
  /// m = (n·Σxy - Σx·Σy) / (n·Σx² - (Σx)²)
  /// b = (Σy - m·Σx) / n
  ///
  /// Para R²:
  /// R² = 1 - (SS_res / SS_tot)
  /// donde SS_res = Σ(yᵢ - ŷᵢ)² y SS_tot = Σ(yᵢ - ȳ)²
  factory RegresionLineal.calcular(List<RegistroProgreso> datos) {
    if (datos.isEmpty) {
      return RegresionLineal(
        pendiente: 0,
        intercepto: 0,
        r2: 0,
        n: 0,
      );
    }

    if (datos.length == 1) {
      return RegresionLineal(
        pendiente: 0,
        intercepto: datos[0].rendimiento,
        r2: 1,
        n: 1,
      );
    }

    // Ordenar datos por fecha
    List<RegistroProgreso> datosOrdenados = List.from(datos)
      ..sort((a, b) => a.fecha.compareTo(b.fecha));

    int n = datosOrdenados.length;

    // Convertir fechas a números (días desde el primer registro)
    DateTime fechaInicial = datosOrdenados.first.fecha;
    List<double> x = datosOrdenados
        .map((r) => r.fecha.difference(fechaInicial).inDays.toDouble())
        .toList();
    List<double> y = datosOrdenados.map((r) => r.rendimiento).toList();

    // Calcular sumatorias necesarias
    double sumX = x.reduce((a, b) => a + b);
    double sumY = y.reduce((a, b) => a + b);
    double sumXY = 0;
    double sumX2 = 0;
    double sumY2 = 0;

    for (int i = 0; i < n; i++) {
      sumXY += x[i] * y[i];
      sumX2 += x[i] * x[i];
      sumY2 += y[i] * y[i];
    }

    // Calcular pendiente: m = (n·Σxy - Σx·Σy) / (n·Σx² - (Σx)²)
    double denominador = (n * sumX2 - sumX * sumX);
    double pendiente = denominador != 0
        ? (n * sumXY - sumX * sumY) / denominador
        : 0;

    // Calcular intercepto: b = (Σy - m·Σx) / n
    double intercepto = (sumY - pendiente * sumX) / n;

    // Calcular R² (coeficiente de determinación)
    double mediaY = sumY / n;
    double ssTot = 0; // Suma total de cuadrados
    double ssRes = 0; // Suma residual de cuadrados

    for (int i = 0; i < n; i++) {
      double yPredicho = pendiente * x[i] + intercepto;
      ssRes += math.pow(y[i] - yPredicho, 2);
      ssTot += math.pow(y[i] - mediaY, 2);
    }

    double r2 = ssTot != 0 ? 1 - (ssRes / ssTot) : 0;

    return RegresionLineal(
      pendiente: pendiente,
      intercepto: intercepto,
      r2: r2,
      n: n,
    );
  }

  /// Predice el rendimiento para un número de días desde el inicio
  ///
  /// Usa la ecuación: y = mx + b
  double predecir(double diasDesdeInicio) {
    return pendiente * diasDesdeInicio + intercepto;
  }

  /// Predice el rendimiento para una fecha específica
  double predecirEnFecha(DateTime fecha, DateTime fechaInicial) {
    double dias = fecha.difference(fechaInicial).inDays.toDouble();
    return predecir(dias);
  }

  /// Obtiene la calidad del ajuste como texto
  String get calidadAjuste {
    if (r2 >= 0.9) return 'Excelente';
    if (r2 >= 0.7) return 'Bueno';
    if (r2 >= 0.5) return 'Regular';
    return 'Pobre';
  }

  @override
  String toString() {
    return 'y = ${pendiente.toStringAsFixed(3)}x + ${intercepto.toStringAsFixed(2)} (R² = ${r2.toStringAsFixed(3)})';
  }
}

/// Funciones matemáticas auxiliares para cálculos de entrenamiento
class Matematicas {
  /// Calcula el progreso usando función lineal: f(t) = P₀ + r·t
  ///
  /// @param p0: Rendimiento inicial
  /// @param r: Tasa de mejora por unidad de tiempo
  /// @param t: Tiempo transcurrido
  /// @return: Rendimiento proyectado
  static double calcularProgreso(double p0, double r, int t) {
    return p0 + (r * t);
  }

  /// Calcula la tasa de mejora requerida: r = (Pf - P₀) / t
  ///
  /// @param p0: Rendimiento inicial
  /// @param pf: Rendimiento final deseado
  /// @param t: Tiempo disponible
  /// @return: Tasa de mejora necesaria por unidad de tiempo
  static double calcularTasa(double p0, double pf, int t) {
    if (t == 0) return 0;
    return (pf - p0) / t;
  }

  /// Calcula el porcentaje de mejora semanal: (r / P₀) × 100
  ///
  /// @param p0: Rendimiento inicial
  /// @param r: Tasa de mejora
  /// @return: Porcentaje de mejora semanal
  static double porcentajeMejoraSemanal(double p0, double r) {
    if (p0 == 0) return 0;
    return (r / p0) * 100;
  }

  /// Calcula el porcentaje de mejora total: [(Pf - P₀) / P₀] × 100
  ///
  /// @param p0: Rendimiento inicial
  /// @param pf: Rendimiento final
  /// @return: Porcentaje de mejora total
  static double porcentajeMejoraTotal(double p0, double pf) {
    if (p0 == 0) return 0;
    return ((pf - p0) / p0) * 100;
  }

  /// Calcula el volumen total de una matriz: V = Σᵢ Σⱼ volumenᵢⱼ
  ///
  /// @param matriz: Matriz de volúmenes [ejercicio][día]
  /// @return: Volumen total
  static int calcularVolumenTotal(List<List<int>> matriz) {
    int total = 0;
    for (var fila in matriz) {
      for (var valor in fila) {
        total += valor;
      }
    }
    return total;
  }

  /// Calcula el gasto calórico mediante multiplicación matricial
  ///
  /// G = R × C
  /// donde R es la matriz de volúmenes y C el vector de calorías
  ///
  /// @param matrizVolumenes: Matriz [ejercicio][día] de volúmenes
  /// @param vectorCalorias: Vector de calorías por unidad de cada ejercicio
  /// @return: Vector de gasto calórico por día
  static List<double> calcularGastoCalorico(
    List<List<int>> matrizVolumenes,
    List<double> vectorCalorias,
  ) {
    if (matrizVolumenes.isEmpty || matrizVolumenes[0].isEmpty) {
      return [];
    }

    int dias = matrizVolumenes[0].length;
    int ejercicios = matrizVolumenes.length;

    if (vectorCalorias.length != ejercicios) {
      throw ArgumentError('El vector de calorías debe tener el mismo tamaño que el número de ejercicios');
    }

    List<double> gastoDiario = List.filled(dias, 0.0);

    // Multiplicación matricial: cada día suma (volumen × calorías) de cada ejercicio
    for (int dia = 0; dia < dias; dia++) {
      for (int ejercicio = 0; ejercicio < ejercicios; ejercicio++) {
        gastoDiario[dia] += matrizVolumenes[ejercicio][dia] * vectorCalorias[ejercicio];
      }
    }

    return gastoDiario;
  }

  /// Calcula el volumen mensual: V_mensual = Σₖ V_semana(k)
  ///
  /// @param volumenesSemanales: Lista de volúmenes semanales
  /// @return: Volumen total mensual
  static int calcularVolumenMensual(List<int> volumenesSemanales) {
    if (volumenesSemanales.isEmpty) return 0;
    return volumenesSemanales.reduce((a, b) => a + b);
  }

  /// Calcula la media de una lista de números
  static double calcularMedia(List<double> valores) {
    if (valores.isEmpty) return 0;
    double suma = valores.reduce((a, b) => a + b);
    return suma / valores.length;
  }

  /// Calcula la desviación estándar de una lista de números
  ///
  /// σ = √(Σ(xᵢ - μ)² / n)
  static double calcularDesviacionEstandar(List<double> valores) {
    if (valores.isEmpty) return 0;

    double media = calcularMedia(valores);
    double sumaCuadrados = 0;

    for (double valor in valores) {
      sumaCuadrados += math.pow(valor - media, 2);
    }

    return math.sqrt(sumaCuadrados / valores.length);
  }

  /// Genera semanas de descarga recomendadas
  ///
  /// Se recomienda descarga cada 3-4 semanas para recuperación
  ///
  /// @param totalSemanas: Número total de semanas del programa
  /// @param frecuencia: Cada cuántas semanas hacer descarga (3-4)
  /// @return: Lista de números de semana donde hacer descarga
  static List<int> generarSemanasDescarga(int totalSemanas, {int frecuencia = 4}) {
    List<int> semanas = [];
    for (int semana = frecuencia; semana <= totalSemanas; semana += frecuencia) {
      semanas.add(semana);
    }
    return semanas;
  }

  /// Aplica factor de descarga al volumen
  ///
  /// Típicamente 40-50% de reducción (factor 0.5-0.6)
  ///
  /// @param volumen: Volumen normal
  /// @param factor: Factor de reducción (0.5 = 50% del volumen)
  /// @return: Volumen con descarga aplicada
  static double aplicarDescarga(double volumen, {double factor = 0.5}) {
    return volumen * factor;
  }
}
