import 'dart:math';

/// Clase que contiene todos los cálculos matemáticos de MATETRÓN
/// Implementa funciones lineales, cuadráticas, exponenciales, logarítmicas y trigonométricas
class CalculosMatematicos {
  /// UNIDAD 1 - MÓDULO 1-2: Función Polinómica de Grado 1 (Lineal)
  /// f(t) = P₀ + r·t
  /// Conexión curricular: "Consumo de energía", "Servicio eléctrico"
  /// P₀: valor inicial (intercepto)
  /// r: tasa de cambio (pendiente)
  /// t: tiempo (variable independiente)
  static double funcionLineal(double p0, double r, double t) {
    return p0 + (r * t);
  }

  /// Calcula la progresión lineal completa para un rango de tiempo
  static List<double> progresionLineal(double p0, double r, int semanas) {
    List<double> valores = [];
    for (int t = 0; t <= semanas; t++) {
      valores.add(funcionLineal(p0, r, t.toDouble()));
    }
    return valores;
  }

  /// UNIDAD 1 - MÓDULO 2: Función Polinómica de Grado 2 (Cuadrática)
  /// f(t) = at² + bt + c
  /// Conexión curricular: "Lanzamiento de una piedra", "Altura de un proyectil"
  /// Modela progresión con punto máximo (peak performance)
  static double funcionCuadratica(double a, double b, double c, double t) {
    return a * t * t + b * t + c;
  }

  /// Calcula el vértice de la parábola (punto máximo/mínimo)
  /// Retorna {semana, valor} del vértice
  static Map<String, double> verticeParabola(double a, double b, double c) {
    // Semana del vértice: t = -b / (2a)
    double semanaVertice = -b / (2 * a);

    // Valor en el vértice: f(t_v) = c - (b² / 4a)
    double valorMaximo = c - (b * b) / (4 * a);

    return {
      'semana': semanaVertice,
      'valor': valorMaximo,
    };
  }

  /// Calcula la progresión cuadrática completa
  static List<double> progresionCuadratica(
    double a,
    double b,
    double c,
    int semanas,
  ) {
    List<double> valores = [];
    for (int t = 0; t <= semanas; t++) {
      valores.add(funcionCuadratica(a, b, c, t.toDouble()));
    }
    return valores;
  }

  /// UNIDAD 1 - MÓDULO 4: Función Exponencial
  /// f(t) = P₀ · e^(kt)
  /// Conexión curricular: "Eliminación de fármacos", "Crecimiento de bacterias"
  /// Para decrecimiento (recuperación muscular): k < 0
  /// Para crecimiento: k > 0
  static double funcionExponencial(double p0, double k, double t) {
    return p0 * exp(k * t);
  }

  /// Calcula la vida media (tiempo para reducir al 50%)
  /// Útil para calcular tiempo de recuperación
  static double vidaMedia(double k) {
    return ln(2) / k.abs();
  }

  /// Calcula el tiempo necesario para alcanzar un porcentaje de recuperación
  /// porcentaje: 0-100 (ej: 90 para recuperarse al 90%)
  static double tiempoRecuperacion(double k, double porcentaje) {
    if (porcentaje <= 0 || porcentaje >= 100) return 0;
    double fraccion = 1 - (porcentaje / 100);
    return -ln(fraccion) / k.abs();
  }

  /// Progresión exponencial completa (decaimiento de fatiga)
  static List<double> progresionExponencial(
    double p0,
    double k,
    int horas,
  ) {
    List<double> valores = [];
    for (int t = 0; t <= horas; t++) {
      valores.add(funcionExponencial(p0, -k.abs(), t.toDouble()));
    }
    return valores;
  }

  /// UNIDAD 1 - MÓDULO 5: Función Logarítmica
  /// f(t) = a · ln(t) + b
  /// Conexión curricular: "Escala Richter", "Seguidores de Instagram"
  /// Modela rendimientos decrecientes (cada mejora requiere más tiempo)
  static double funcionLogaritmica(double a, double b, double t) {
    if (t <= 0) return b;
    return a * log(t) + b;
  }

  /// Progresión logarítmica completa
  static List<double> progresionLogaritmica(
    double a,
    double b,
    int semanas,
  ) {
    List<double> valores = [];
    for (int t = 1; t <= semanas; t++) {
      valores.add(funcionLogaritmica(a, b, t.toDouble()));
    }
    return valores;
  }

  /// UNIDAD 2 - MÓDULO 3: Función Trigonométrica (Sinusoidal)
  /// f(t) = A · sen(ωt + φ) + k
  /// Conexión curricular: "Análisis de ondas sonoras"
  /// Modela periodización (ciclos de carga/descarga)
  /// A: amplitud (variación de intensidad)
  /// ω: frecuencia angular (relacionada con el período)
  /// φ: fase (desplazamiento horizontal)
  /// k: valor medio (línea base de intensidad)
  static double funcionSinusoidal(
    double amplitud,
    double omega,
    double fase,
    double valorMedio,
    double t,
  ) {
    return amplitud * sin(omega * t + fase) + valorMedio;
  }

  /// Calcula la frecuencia angular (ω) a partir del período
  /// período: duración del ciclo completo (ej: 4 semanas)
  static double calcularOmega(double periodo) {
    return (2 * pi) / periodo;
  }

  /// Progresión sinusoidal (periodización)
  /// período: duración del ciclo en semanas (típicamente 4)
  static List<double> progresionSinusoidal(
    double amplitud,
    double periodo,
    double fase,
    double valorMedio,
    int semanas,
  ) {
    double omega = calcularOmega(periodo);
    List<double> valores = [];

    for (int t = 0; t <= semanas; t++) {
      valores.add(funcionSinusoidal(
        amplitud,
        omega,
        fase,
        valorMedio,
        t.toDouble(),
      ));
    }
    return valores;
  }

  /// UNIDAD 2 - MÓDULO 1-2: Razones Trigonométricas
  /// Conexión curricular: "La plaza de skate", "La rampa"
  /// Útil para análisis biomecánico de ejercicios

  /// Calcula el ángulo óptimo para un ejercicio dado un cateto adyacente y opuesto
  static double calcularAngulo(double catetoOpuesto, double catetoAdyacente) {
    return atan(catetoOpuesto / catetoAdyacente) * (180 / pi);
  }

  /// Calcula la hipotenusa usando teorema de Pitágoras
  static double calcularHipotenusa(double cateto1, double cateto2) {
    return sqrt(cateto1 * cateto1 + cateto2 * cateto2);
  }

  /// UTILIDADES ADICIONALES

  /// Calcula el porcentaje de mejora entre dos valores
  static double porcentajeMejora(double valorInicial, double valorFinal) {
    if (valorInicial == 0) return 0;
    return ((valorFinal - valorInicial) / valorInicial) * 100;
  }

  /// Calcula el promedio de una lista de valores
  static double promedio(List<double> valores) {
    if (valores.isEmpty) return 0;
    return valores.reduce((a, b) => a + b) / valores.length;
  }

  /// Calcula la desviación estándar
  static double desviacionEstandar(List<double> valores) {
    if (valores.isEmpty) return 0;
    double media = promedio(valores);
    double sumaCuadrados = valores.fold(
      0,
      (sum, valor) => sum + pow(valor - media, 2),
    );
    return sqrt(sumaCuadrados / valores.length);
  }

  /// Valida que la tasa de mejora esté en un rango saludable (2-5%)
  static bool validarTasaMejora(double porcentaje) {
    return porcentaje >= 2.0 && porcentaje <= 5.0;
  }

  /// Convierte grados a radianes
  static double gradosARadianes(double grados) {
    return grados * (pi / 180);
  }

  /// Convierte radianes a grados
  static double radianesAGrados(double radianes) {
    return radianes * (180 / pi);
  }
}
