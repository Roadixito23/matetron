import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import '../models/registro_progreso.dart';
import '../services/hive_service.dart';
import '../utils/matematicas.dart';

/// Provider para gestionar los registros de progreso
///
/// Maneja el historial de rendimiento y cálculos de tendencias
class RegistrosProvider extends ChangeNotifier {
  late Box<RegistroProgreso> _box;
  List<RegistroProgreso> _registros = [];

  RegistrosProvider() {
    _inicializar();
  }

  /// Lista de todos los registros
  List<RegistroProgreso> get registros => _registros;

  /// Inicializa el provider cargando datos desde Hive
  Future<void> _inicializar() async {
    _box = Hive.box<RegistroProgreso>(HiveService.registrosBox);
    cargarRegistros();
  }

  /// Carga todos los registros desde Hive
  void cargarRegistros() {
    _registros = _box.values.toList();
    // Ordenar por fecha descendente (más reciente primero)
    _registros.sort((a, b) => b.fecha.compareTo(a.fecha));
    notifyListeners();
  }

  /// Obtiene un registro por su ID
  RegistroProgreso? obtenerRegistro(String id) {
    return _box.get(id);
  }

  /// Agrega un nuevo registro
  Future<void> agregarRegistro(RegistroProgreso registro) async {
    await _box.put(registro.id, registro);
    cargarRegistros();
  }

  /// Actualiza un registro existente
  Future<void> actualizarRegistro(RegistroProgreso registro) async {
    await _box.put(registro.id, registro);
    cargarRegistros();
  }

  /// Elimina un registro
  Future<void> eliminarRegistro(String id) async {
    await _box.delete(id);
    cargarRegistros();
  }

  /// Obtiene registros de un ejercicio específico
  List<RegistroProgreso> obtenerRegistrosPorEjercicio(String ejercicioId) {
    List<RegistroProgreso> registrosEjercicio = _registros
        .where((r) => r.ejercicioId == ejercicioId)
        .toList();
    // Ordenar por fecha ascendente para gráficos
    registrosEjercicio.sort((a, b) => a.fecha.compareTo(b.fecha));
    return registrosEjercicio;
  }

  /// Calcula la regresión lineal para un ejercicio específico
  RegresionLineal? calcularRegresionLineal(String ejercicioId) {
    List<RegistroProgreso> registrosEjercicio = obtenerRegistrosPorEjercicio(ejercicioId);

    if (registrosEjercicio.isEmpty) {
      return null;
    }

    return RegresionLineal.calcular(registrosEjercicio);
  }

  /// Obtiene el último registro de un ejercicio
  RegistroProgreso? obtenerUltimoRegistro(String ejercicioId) {
    List<RegistroProgreso> registrosEjercicio = _registros
        .where((r) => r.ejercicioId == ejercicioId)
        .toList();

    if (registrosEjercicio.isEmpty) {
      return null;
    }

    registrosEjercicio.sort((a, b) => b.fecha.compareTo(a.fecha));
    return registrosEjercicio.first;
  }

  /// Calcula la tasa de mejora promedio de las últimas N semanas
  double calcularTasaMejoraPromedio(String ejercicioId, {int semanas = 4}) {
    List<RegistroProgreso> registrosEjercicio = obtenerRegistrosPorEjercicio(ejercicioId);

    if (registrosEjercicio.length < 2) {
      return 0.0;
    }

    // Filtrar registros de las últimas N semanas
    DateTime fechaLimite = DateTime.now().subtract(Duration(days: semanas * 7));
    List<RegistroProgreso> registrosRecientes = registrosEjercicio
        .where((r) => r.fecha.isAfter(fechaLimite))
        .toList();

    if (registrosRecientes.length < 2) {
      registrosRecientes = registrosEjercicio;
    }

    // Calcular regresión lineal
    RegresionLineal regresion = RegresionLineal.calcular(registrosRecientes);

    // La pendiente representa la mejora por día, convertir a porcentaje semanal
    double rendimientoInicial = registrosRecientes.first.rendimiento;
    if (rendimientoInicial == 0) return 0.0;

    double mejoraSemanaldouble = (regresion.pendiente * 7 / rendimientoInicial) * 100;
    return mejoraSemanaldouble;
  }

  /// Obtiene registros en un rango de fechas
  List<RegistroProgreso> obtenerRegistrosPorRango(
    DateTime fechaInicio,
    DateTime fechaFin, {
    String? ejercicioId,
  }) {
    List<RegistroProgreso> registrosFiltrados = _registros.where((r) {
      bool enRango = r.fecha.isAfter(fechaInicio.subtract(Duration(days: 1))) &&
          r.fecha.isBefore(fechaFin.add(Duration(days: 1)));

      if (ejercicioId != null) {
        return enRango && r.ejercicioId == ejercicioId;
      }

      return enRango;
    }).toList();

    registrosFiltrados.sort((a, b) => a.fecha.compareTo(b.fecha));
    return registrosFiltrados;
  }

  /// Obtiene ejercicios únicos con registros
  List<String> get ejerciciosConRegistros {
    Set<String> ejerciciosIds = _registros.map((r) => r.ejercicioId).toSet();
    return ejerciciosIds.toList();
  }

  /// Obtiene el número total de registros
  int get totalRegistros => _registros.length;

  /// Obtiene el número de registros por ejercicio
  int contarRegistrosPorEjercicio(String ejercicioId) {
    return _registros.where((r) => r.ejercicioId == ejercicioId).length;
  }
}
