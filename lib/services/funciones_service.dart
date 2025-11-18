import '../utils/calculos_matematicos.dart';

/// Servicio que integra todas las funciones matemáticas para análisis deportivo
class FuncionesService {
  /// Analiza la progresión lineal de un atleta
  /// Retorna proyección completa y estadísticas
  static Map<String, dynamic> analizarProgresionLineal({
    required double valorInicial,
    required double tasaMejoraSemanal,
    required int semanas,
  }) {
    // Calcular progresión
    List<double> valores = CalculosMatematicos.progresionLineal(
      valorInicial,
      tasaMejoraSemanal,
      semanas,
    );

    double valorFinal = valores.last;
    double mejoraPorcentaje = CalculosMatematicos.porcentajeMejora(
      valorInicial,
      valorFinal,
    );

    // Validar tasa de mejora
    bool tasaValida = CalculosMatematicos.validarTasaMejora(
      (tasaMejoraSemanal / valorInicial) * 100,
    );

    return {
      'valores': valores,
      'valorInicial': valorInicial,
      'valorFinal': valorFinal,
      'mejoraPorcentaje': mejoraPorcentaje,
      'tasaValida': tasaValida,
      'formula': 'f(t) = $valorInicial + ${tasaMejoraSemanal.toStringAsFixed(2)} × t',
    };
  }

  /// Analiza la progresión cuadrática (con peak performance)
  static Map<String, dynamic> analizarProgresionCuadratica({
    required double a,
    required double b,
    required double c,
    required int semanas,
  }) {
    // Calcular vértice (punto máximo/mínimo)
    Map<String, double> vertice = CalculosMatematicos.verticeParabola(a, b, c);

    // Calcular progresión
    List<double> valores = CalculosMatematicos.progresionCuadratica(
      a,
      b,
      c,
      semanas,
    );

    // Determinar si es máximo o mínimo
    String tipoVertice = a < 0 ? 'máximo' : 'mínimo';

    return {
      'valores': valores,
      'vertice': vertice,
      'tipoVertice': tipoVertice,
      'semanaOptima': vertice['semana'],
      'valorOptimo': vertice['valor'],
      'formula':
          'f(t) = ${a.toStringAsFixed(2)}t² + ${b.toStringAsFixed(2)}t + ${c.toStringAsFixed(2)}',
    };
  }

  /// Analiza la recuperación exponencial (fatiga muscular)
  static Map<String, dynamic> analizarRecuperacionExponencial({
    required double fatigaInicial,
    required double constanteK,
    required int horas,
  }) {
    // Calcular progresión de recuperación
    List<double> valores = CalculosMatematicos.progresionExponencial(
      fatigaInicial,
      constanteK,
      horas,
    );

    // Calcular vida media
    double vidaMedia = CalculosMatematicos.vidaMedia(constanteK);

    // Tiempo para recuperación al 90%
    double tiempo90 = CalculosMatematicos.tiempoRecuperacion(constanteK, 10);

    // Tiempo para recuperación al 95%
    double tiempo95 = CalculosMatematicos.tiempoRecuperacion(constanteK, 5);

    return {
      'valores': valores,
      'vidaMedia': vidaMedia,
      'tiempo90': tiempo90,
      'tiempo95': tiempo95,
      'formula':
          'f(t) = ${fatigaInicial.toStringAsFixed(0)} × e^(-${constanteK.toStringAsFixed(3)}t)',
    };
  }

  /// Analiza la progresión logarítmica (rendimientos decrecientes)
  static Map<String, dynamic> analizarProgresionLogaritmica({
    required double a,
    required double b,
    required int semanas,
  }) {
    // Calcular progresión
    List<double> valores = CalculosMatematicos.progresionLogaritmica(
      a,
      b,
      semanas,
    );

    // Comparar mejora inicial vs final
    double mejoraSemana1a4 = valores[3] - valores[0];
    double mejoraSemanaFinal = valores.last - valores[valores.length - 5];

    return {
      'valores': valores,
      'valorInicial': b,
      'valorFinal': valores.last,
      'mejoraSemana1a4': mejoraSemana1a4,
      'mejoraSemanaFinal': mejoraSemanaFinal,
      'formula': 'f(t) = ${a.toStringAsFixed(2)} × ln(t) + ${b.toStringAsFixed(2)}',
    };
  }

  /// Analiza la periodización sinusoidal (ciclos de carga/descarga)
  static Map<String, dynamic> analizarPeriodizacion({
    required double amplitud,
    required double periodo,
    required double fase,
    required double valorMedio,
    required int semanas,
  }) {
    // Calcular progresión
    List<double> valores = CalculosMatematicos.progresionSinusoidal(
      amplitud,
      periodo,
      fase,
      valorMedio,
      semanas,
    );

    // Calcular omega
    double omega = CalculosMatematicos.calcularOmega(periodo);

    // Identificar puntos de máxima y mínima intensidad
    double intensidadMaxima = valorMedio + amplitud;
    double intensidadMinima = valorMedio - amplitud;

    return {
      'valores': valores,
      'omega': omega,
      'intensidadMaxima': intensidadMaxima,
      'intensidadMinima': intensidadMinima,
      'variacion': amplitud * 2,
      'formula':
          'f(t) = ${amplitud.toStringAsFixed(1)} × sen(${omega.toStringAsFixed(3)}t + ${fase.toStringAsFixed(1)}) + ${valorMedio.toStringAsFixed(1)}',
    };
  }

  /// Compara diferentes modelos de progresión para el mismo atleta
  static Map<String, dynamic> compararModelos({
    required double valorInicial,
    required int semanas,
  }) {
    // Modelo lineal (mejora constante 2.5% semanal)
    double tasaLineal = valorInicial * 0.025;
    List<double> lineal = CalculosMatematicos.progresionLineal(
      valorInicial,
      tasaLineal,
      semanas,
    );

    // Modelo logarítmico (rendimientos decrecientes)
    // a = valorInicial * 0.15, b = valorInicial
    List<double> logaritmico = CalculosMatematicos.progresionLogaritmica(
      valorInicial * 0.15,
      valorInicial,
      semanas,
    );

    // Modelo cuadrático (peak en semana 8)
    // f(t) = -0.1t² + 1.6t + valorInicial
    double a = -0.1;
    double b = 1.6;
    double c = valorInicial;
    List<double> cuadratico = CalculosMatematicos.progresionCuadratica(
      a,
      b,
      c,
      semanas,
    );

    return {
      'lineal': lineal,
      'logaritmico': logaritmico,
      'cuadratico': cuadratico,
      'semanas': List.generate(semanas + 1, (i) => i),
    };
  }

  /// Calcula la carga de entrenamiento óptima según nivel del atleta
  static Map<String, dynamic> calcularCargaOptima({
    required String nivelAtleta, // 'principiante', 'intermedio', 'avanzado'
    required double pesoMaximo,
  }) {
    double porcentaje1RM;
    int series;
    int repeticiones;
    String modelo;

    switch (nivelAtleta.toLowerCase()) {
      case 'principiante':
        porcentaje1RM = 0.65; // 65% del máximo
        series = 3;
        repeticiones = 12;
        modelo = 'lineal'; // Mejora lineal constante
        break;
      case 'intermedio':
        porcentaje1RM = 0.75; // 75% del máximo
        series = 4;
        repeticiones = 10;
        modelo = 'logaritmico'; // Rendimientos decrecientes
        break;
      case 'avanzado':
        porcentaje1RM = 0.85; // 85% del máximo
        series = 5;
        repeticiones = 6;
        modelo = 'sinusoidal'; // Periodización necesaria
        break;
      default:
        porcentaje1RM = 0.70;
        series = 3;
        repeticiones = 10;
        modelo = 'lineal';
    }

    double pesoTrabajo = pesoMaximo * porcentaje1RM;

    return {
      'nivelAtleta': nivelAtleta,
      'pesoTrabajo': pesoTrabajo,
      'porcentaje1RM': porcentaje1RM * 100,
      'series': series,
      'repeticiones': repeticiones,
      'volumen': series * repeticiones,
      'modeloRecomendado': modelo,
    };
  }
}
