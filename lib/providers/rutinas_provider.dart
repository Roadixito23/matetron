import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import '../models/rutina_matriz.dart';
import '../services/hive_service.dart';

/// Provider para gestionar las rutinas de entrenamiento
///
/// Maneja las operaciones CRUD de rutinas y cálculos relacionados
class RutinasProvider extends ChangeNotifier {
  late Box<RutinaMatriz> _box;
  List<RutinaMatriz> _rutinas = [];
  RutinaMatriz? _rutinaActual;

  RutinasProvider() {
    _inicializar();
  }

  /// Lista de todas las rutinas
  List<RutinaMatriz> get rutinas => _rutinas;

  /// Rutina seleccionada actualmente
  RutinaMatriz? get rutinaActual => _rutinaActual;

  /// Inicializa el provider cargando datos desde Hive
  Future<void> _inicializar() async {
    _box = Hive.box<RutinaMatriz>(HiveService.rutinasBox);
    cargarRutinas();
  }

  /// Carga todas las rutinas desde Hive
  void cargarRutinas() {
    _rutinas = _box.values.toList();
    // Si hay rutinas pero no hay una actual, seleccionar la primera
    if (_rutinas.isNotEmpty && _rutinaActual == null) {
      _rutinaActual = _rutinas.first;
    }
    notifyListeners();
  }

  /// Obtiene una rutina por su ID
  RutinaMatriz? obtenerRutina(String id) {
    return _box.get(id);
  }

  /// Agrega una nueva rutina
  Future<void> agregarRutina(RutinaMatriz rutina) async {
    await _box.put(rutina.id, rutina);
    cargarRutinas();
  }

  /// Actualiza una rutina existente
  Future<void> actualizarRutina(RutinaMatriz rutina) async {
    await _box.put(rutina.id, rutina);
    // Si es la rutina actual, actualizar la referencia
    if (_rutinaActual?.id == rutina.id) {
      _rutinaActual = rutina;
    }
    cargarRutinas();
  }

  /// Elimina una rutina
  Future<void> eliminarRutina(String id) async {
    await _box.delete(id);
    // Si era la rutina actual, limpiar la referencia
    if (_rutinaActual?.id == id) {
      _rutinaActual = _rutinas.isNotEmpty ? _rutinas.first : null;
    }
    cargarRutinas();
  }

  /// Establece la rutina actual
  void setRutinaActual(RutinaMatriz? rutina) {
    _rutinaActual = rutina;
    notifyListeners();
  }

  /// Obtiene el volumen total semanal de la rutina actual
  int get volumenTotalSemanalActual {
    return _rutinaActual?.volumenTotalSemanal ?? 0;
  }

  /// Obtiene el volumen por día de la rutina actual
  List<int> get volumenPorDiaActual {
    return _rutinaActual?.volumenPorDia ?? List.filled(7, 0);
  }

  /// Obtiene rutinas ordenadas por fecha de creación (más reciente primero)
  List<RutinaMatriz> get rutinasRecientes {
    List<RutinaMatriz> lista = List.from(_rutinas);
    lista.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return lista;
  }

  /// Verifica si existe una rutina con el mismo nombre
  bool existeRutinaConNombre(String nombre, {String? excluyendoId}) {
    return _rutinas.any((r) =>
        r.nombre.toLowerCase() == nombre.toLowerCase() &&
        r.id != excluyendoId);
  }

  /// Obtiene el número total de rutinas
  int get totalRutinas => _rutinas.length;

  /// Calcula el volumen mensual basado en las últimas 4 semanas
  /// (asumiendo que se repite la rutina actual)
  int get volumenMensualProyectado {
    return volumenTotalSemanalActual * 4;
  }
}
