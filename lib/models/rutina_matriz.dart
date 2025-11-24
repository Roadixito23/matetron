import 'package:hive/hive.dart';
import 'ejercicio.dart';
import 'celda_rutina.dart';

part 'rutina_matriz.g.dart';

/// Modelo para representar una rutina de entrenamiento como matriz
///
/// La matriz R(n×7) representa:
/// - n filas: ejercicios (mínimo 3, máximo 10)
/// - 7 columnas: días de la semana (Lun-Dom)
///
/// Cada celda R[i][j] contiene las series y repeticiones
/// del ejercicio i en el día j
@HiveType(typeId: 2)
class RutinaMatriz extends HiveObject {
  /// Identificador único de la rutina
  @HiveField(0)
  late String id;

  /// Nombre descriptivo de la rutina
  @HiveField(1)
  late String nombre;

  /// Lista de ejercicios incluidos en la rutina
  @HiveField(2)
  late List<String> ejercicioIds;

  /// Matriz de celdas [ejercicio][día]
  /// matriz[i][j] = CeldaRutina del ejercicio i en el día j
  @HiveField(3)
  late List<List<CeldaRutina>> matriz;

  /// Fecha y hora de creación de la rutina
  @HiveField(4)
  late DateTime createdAt;

  RutinaMatriz({
    required this.id,
    required this.nombre,
    required this.ejercicioIds,
    required this.matriz,
    DateTime? createdAt,
  }) {
    this.createdAt = createdAt ?? DateTime.now();
  }

  /// Constructor para crear una rutina vacía con n ejercicios
  RutinaMatriz.vacia({
    required this.id,
    required this.nombre,
    required int numeroEjercicios,
  }) {
    ejercicioIds = [];
    matriz = List.generate(
      numeroEjercicios,
      (_) => List.generate(7, (_) => CeldaRutina.empty()),
    );
    createdAt = DateTime.now();
  }

  /// Calcula el volumen total semanal de la rutina
  ///
  /// V_total = Σᵢ Σⱼ (series × repeticiones)ᵢⱼ
  /// donde i = ejercicios, j = días
  int get volumenTotalSemanal {
    int total = 0;
    for (var fila in matriz) {
      for (var celda in fila) {
        total += celda.volumen;
      }
    }
    return total;
  }

  /// Calcula el volumen por día de la semana
  ///
  /// Retorna una lista de 7 elementos con el volumen total
  /// para cada día (índice 0 = Lunes, 6 = Domingo)
  List<int> get volumenPorDia {
    List<int> volumenes = List.filled(7, 0);

    for (int dia = 0; dia < 7; dia++) {
      for (int ejercicio = 0; ejercicio < matriz.length; ejercicio++) {
        volumenes[dia] += matriz[ejercicio][dia].volumen;
      }
    }

    return volumenes;
  }

  /// Calcula el volumen por ejercicio
  ///
  /// Retorna una lista con el volumen semanal de cada ejercicio
  List<int> get volumenPorEjercicio {
    List<int> volumenes = [];

    for (var fila in matriz) {
      int volumenEjercicio = 0;
      for (var celda in fila) {
        volumenEjercicio += celda.volumen;
      }
      volumenes.add(volumenEjercicio);
    }

    return volumenes;
  }

  /// Calcula el gasto calórico diario
  ///
  /// Realiza la multiplicación matricial: R × C = G
  /// donde C es el vector de calorías por ejercicio
  /// y G es el vector de gasto calórico por día
  List<double> calcularGastoCalorico(List<double> caloriasPorEjercicio) {
    if (caloriasPorEjercicio.length != matriz.length) {
      throw ArgumentError('El número de calorías debe coincidir con el número de ejercicios');
    }

    List<double> gastoDiario = List.filled(7, 0.0);

    for (int dia = 0; dia < 7; dia++) {
      for (int ejercicio = 0; ejercicio < matriz.length; ejercicio++) {
        gastoDiario[dia] +=
          matriz[ejercicio][dia].volumen * caloriasPorEjercicio[ejercicio];
      }
    }

    return gastoDiario;
  }

  /// Calcula el gasto calórico total semanal
  double calcularGastoCaloricoTotal(List<double> caloriasPorEjercicio) {
    List<double> gastoDiario = calcularGastoCalorico(caloriasPorEjercicio);
    return gastoDiario.reduce((a, b) => a + b);
  }

  /// Agrega un nuevo ejercicio a la rutina
  void agregarEjercicio(String ejercicioId) {
    ejercicioIds.add(ejercicioId);
    matriz.add(List.generate(7, (_) => CeldaRutina.empty()));
  }

  /// Elimina un ejercicio de la rutina
  void eliminarEjercicio(int index) {
    if (index >= 0 && index < ejercicioIds.length) {
      ejercicioIds.removeAt(index);
      matriz.removeAt(index);
    }
  }

  /// Actualiza una celda específica de la matriz
  void actualizarCelda(int ejercicioIndex, int diaIndex, CeldaRutina nuevaCelda) {
    if (ejercicioIndex >= 0 && ejercicioIndex < matriz.length &&
        diaIndex >= 0 && diaIndex < 7) {
      matriz[ejercicioIndex][diaIndex] = nuevaCelda;
    }
  }

  @override
  String toString() {
    return 'RutinaMatriz(id: $id, nombre: $nombre, ejercicios: ${matriz.length}, volumenTotal: $volumenTotalSemanal)';
  }
}
