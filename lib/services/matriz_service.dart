import '../models/rutina.dart';
import '../models/ejercicio.dart';

/// Servicio para operaciones matriciales sobre rutinas de entrenamiento
class MatrizService {
  /// Calcula el gasto calórico usando multiplicación matricial: R × C = G
  /// R: matriz de rutinas (repeticiones por ejercicio/día)
  /// C: vector de calorías por repetición de cada ejercicio
  /// G: vector de gasto calórico diario
  ///
  /// Calorías por ejercicio (predefinidas):
  /// - Sentadillas: 0.5 cal/rep
  /// - Press banca: 0.7 cal/rep
  /// - Peso muerto: 5.0 cal/rep
  /// - Dominadas: 10.0 cal/rep
  static const List<double> caloriasPorEjercicio = [
    0.5, // Sentadillas
    0.7, // Press banca
    5.0, // Peso muerto
    10.0, // Dominadas
  ];

  static const List<String> nombresEjerciciosDefault = [
    'Sentadillas',
    'Press Banca',
    'Peso Muerto',
    'Dominadas',
  ];

  /// Calcula el gasto calórico por día
  /// Retorna un vector de 7 elementos (uno por día)
  static List<double> calcularGastoCalorioDiario(Rutina rutina) {
    List<double> gastoDiario = List.filled(Rutina.diasSemana, 0.0);

    for (int dia = 0; dia < Rutina.diasSemana; dia++) {
      double gastoDia = 0.0;

      for (int ejercicio = 0; ejercicio < Rutina.numEjercicios; ejercicio++) {
        final ej = rutina.getEjercicio(ejercicio, dia);
        if (ej != null) {
          // Multiplicación: repeticiones × calorías por repetición
          gastoDia += ej.volumen * caloriasPorEjercicio[ejercicio];
        }
      }

      gastoDiario[dia] = gastoDia;
    }

    return gastoDiario;
  }

  /// Calcula el gasto calórico total semanal
  static double calcularGastoCaloricoTotal(Rutina rutina) {
    final gastoDiario = calcularGastoCalorioDiario(rutina);
    return gastoDiario.reduce((a, b) => a + b);
  }

  /// Calcula el gasto calórico por ejercicio (sumando todos los días)
  static List<double> calcularGastoCalorioPorEjercicio(Rutina rutina) {
    List<double> gastoPorEjercicio = List.filled(Rutina.numEjercicios, 0.0);

    for (int ejercicio = 0; ejercicio < Rutina.numEjercicios; ejercicio++) {
      double gastoEjercicio = 0.0;

      for (int dia = 0; dia < Rutina.diasSemana; dia++) {
        final ej = rutina.getEjercicio(ejercicio, dia);
        if (ej != null) {
          gastoEjercicio += ej.volumen * caloriasPorEjercicio[ejercicio];
        }
      }

      gastoPorEjercicio[ejercicio] = gastoEjercicio;
    }

    return gastoPorEjercicio;
  }

  /// Crea una matriz de volumen (series × repeticiones) para visualización
  /// Retorna una matriz de enteros 4×7
  static List<List<int>> obtenerMatrizVolumen(Rutina rutina) {
    List<List<int>> matrizVolumen = List.generate(
      Rutina.numEjercicios,
      (_) => List.filled(Rutina.diasSemana, 0),
    );

    for (int ejercicio = 0; ejercicio < Rutina.numEjercicios; ejercicio++) {
      for (int dia = 0; dia < Rutina.diasSemana; dia++) {
        final ej = rutina.getEjercicio(ejercicio, dia);
        if (ej != null) {
          matrizVolumen[ejercicio][dia] = ej.volumen;
        }
      }
    }

    return matrizVolumen;
  }

  /// Calcula la sumatoria total de una matriz
  /// V_total = Σᵢ Σⱼ rᵢⱼ
  static int calcularSumatoriaMatriz(List<List<int>> matriz) {
    int total = 0;
    for (var fila in matriz) {
      for (var valor in fila) {
        total += valor;
      }
    }
    return total;
  }

  /// Valida que el volumen semanal no sea excesivo
  /// Volumen recomendado: 300-1000 repeticiones por semana
  static Map<String, dynamic> validarVolumen(int volumenTotal) {
    const int volumenMinimo = 300;
    const int volumenMaximo = 1000;
    const int volumenOptimo = 650;

    String mensaje;
    String nivel; // 'bajo', 'optimo', 'alto', 'excesivo'

    if (volumenTotal < volumenMinimo) {
      mensaje =
          'Volumen bajo. Considera aumentar el número de series o repeticiones.';
      nivel = 'bajo';
    } else if (volumenTotal >= volumenMinimo && volumenTotal <= volumenOptimo) {
      mensaje = 'Volumen óptimo para progresión constante.';
      nivel = 'optimo';
    } else if (volumenTotal > volumenOptimo && volumenTotal <= volumenMaximo) {
      mensaje = 'Volumen alto. Monitorea signos de sobreentrenamiento.';
      nivel = 'alto';
    } else {
      mensaje =
          'Volumen excesivo. Alto riesgo de sobreentrenamiento. Reduce el volumen.';
      nivel = 'excesivo';
    }

    return {
      'volumen': volumenTotal,
      'nivel': nivel,
      'mensaje': mensaje,
      'porcentaje': (volumenTotal / volumenOptimo * 100).clamp(0, 150),
    };
  }

  /// Crea una rutina de ejemplo para demostración
  static Rutina crearRutinaEjemplo() {
    Rutina rutina = Rutina(
      nombre: 'Rutina de Ejemplo',
      fechaCreacion: DateTime.now(),
    );

    // Sentadillas: Lunes, Miércoles, Viernes (4×12)
    rutina.setEjercicio(
      0,
      0,
      Ejercicio(nombre: 'Sentadillas', series: 4, repeticiones: 12, peso: 60),
    );
    rutina.setEjercicio(
      0,
      2,
      Ejercicio(nombre: 'Sentadillas', series: 4, repeticiones: 12, peso: 60),
    );
    rutina.setEjercicio(
      0,
      4,
      Ejercicio(nombre: 'Sentadillas', series: 4, repeticiones: 12, peso: 60),
    );

    // Press Banca: Lunes, Martes, Jueves, Viernes (3×10)
    rutina.setEjercicio(
      1,
      0,
      Ejercicio(nombre: 'Press Banca', series: 3, repeticiones: 10, peso: 50),
    );
    rutina.setEjercicio(
      1,
      1,
      Ejercicio(nombre: 'Press Banca', series: 3, repeticiones: 10, peso: 50),
    );
    rutina.setEjercicio(
      1,
      3,
      Ejercicio(nombre: 'Press Banca', series: 3, repeticiones: 10, peso: 50),
    );
    rutina.setEjercicio(
      1,
      5,
      Ejercicio(nombre: 'Press Banca', series: 3, repeticiones: 10, peso: 50),
    );

    // Peso Muerto: Lunes, Miércoles, Viernes (4×10)
    rutina.setEjercicio(
      2,
      0,
      Ejercicio(nombre: 'Peso Muerto', series: 4, repeticiones: 10, peso: 80),
    );
    rutina.setEjercicio(
      2,
      2,
      Ejercicio(nombre: 'Peso Muerto', series: 4, repeticiones: 10, peso: 80),
    );
    rutina.setEjercicio(
      2,
      4,
      Ejercicio(nombre: 'Peso Muerto', series: 4, repeticiones: 10, peso: 80),
    );

    // Dominadas: Todos los días laborables (5×10)
    for (int dia = 0; dia < 5; dia++) {
      rutina.setEjercicio(
        3,
        dia,
        Ejercicio(nombre: 'Dominadas', series: 5, repeticiones: 10),
      );
    }

    return rutina;
  }
}
