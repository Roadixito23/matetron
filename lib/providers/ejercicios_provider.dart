import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import '../models/ejercicio.dart';
import '../services/hive_service.dart';

/// Provider para gestionar los ejercicios
///
/// Usa ChangeNotifier para notificar cambios a los widgets
/// y Hive para persistencia local
class EjerciciosProvider extends ChangeNotifier {
  late Box<Ejercicio> _box;
  List<Ejercicio> _ejercicios = [];

  EjerciciosProvider() {
    _inicializar();
  }

  /// Lista de todos los ejercicios
  List<Ejercicio> get ejercicios => _ejercicios;

  /// Inicializa el provider cargando datos desde Hive
  Future<void> _inicializar() async {
    _box = Hive.box<Ejercicio>(HiveService.ejerciciosBox);
    cargarEjercicios();
  }

  /// Carga todos los ejercicios desde Hive
  void cargarEjercicios() {
    _ejercicios = _box.values.toList();
    notifyListeners();
  }

  /// Obtiene un ejercicio por su ID
  Ejercicio? obtenerEjercicio(String id) {
    return _box.get(id);
  }

  /// Agrega un nuevo ejercicio
  Future<void> agregarEjercicio(Ejercicio ejercicio) async {
    await _box.put(ejercicio.id, ejercicio);
    cargarEjercicios();
  }

  /// Actualiza un ejercicio existente
  Future<void> actualizarEjercicio(Ejercicio ejercicio) async {
    await _box.put(ejercicio.id, ejercicio);
    cargarEjercicios();
  }

  /// Elimina un ejercicio
  Future<void> eliminarEjercicio(String id) async {
    await _box.delete(id);
    cargarEjercicios();
  }

  /// Verifica si existe un ejercicio con el mismo nombre
  bool existeEjercicioConNombre(String nombre, {String? excluyendoId}) {
    return _ejercicios.any((e) =>
        e.nombre.toLowerCase() == nombre.toLowerCase() &&
        e.id != excluyendoId);
  }

  /// Obtiene ejercicios ordenados por nombre
  List<Ejercicio> get ejerciciosOrdenados {
    List<Ejercicio> lista = List.from(_ejercicios);
    lista.sort((a, b) => a.nombre.compareTo(b.nombre));
    return lista;
  }

  /// Obtiene el número total de ejercicios
  int get totalEjercicios => _ejercicios.length;
}
