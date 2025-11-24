import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import '../models/ejercicio.dart';
import '../models/celda_rutina.dart';
import '../models/rutina_matriz.dart';
import '../models/registro_progreso.dart';
import '../models/proyeccion_lineal.dart';

/// Servicio para inicializar y gestionar el almacenamiento local con Hive
///
/// Hive es una base de datos NoSQL rápida y ligera para Flutter
/// que permite almacenamiento local sin necesidad de servicios en la nube
class HiveService {
  /// Nombres de las cajas (boxes) de Hive
  static const String ejerciciosBox = 'ejercicios';
  static const String rutinasBox = 'rutinas';
  static const String registrosBox = 'registros';
  static const String proyeccionesBox = 'proyecciones';
  static const String configBox = 'configuracion';

  /// Inicializa Hive y registra todos los adaptadores
  ///
  /// Este método debe ser llamado antes de usar cualquier funcionalidad
  /// de la aplicación que requiera almacenamiento local
  static Future<void> init() async {
    // Inicializar Hive para Flutter
    await Hive.initFlutter();

    // Registrar adaptadores de TypeAdapter para los modelos
    // Cada modelo con @HiveType necesita su adaptador
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(EjercicioAdapter());
    }
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(CeldaRutinaAdapter());
    }
    if (!Hive.isAdapterRegistered(2)) {
      Hive.registerAdapter(RutinaMatrizAdapter());
    }
    if (!Hive.isAdapterRegistered(3)) {
      Hive.registerAdapter(RegistroProgresoAdapter());
    }
    if (!Hive.isAdapterRegistered(4)) {
      Hive.registerAdapter(ProyeccionLinealAdapter());
    }

    // Abrir las cajas necesarias
    await openBoxes();
  }

  /// Abre todas las cajas de Hive
  static Future<void> openBoxes() async {
    await Hive.openBox<Ejercicio>(ejerciciosBox);
    await Hive.openBox<RutinaMatriz>(rutinasBox);
    await Hive.openBox<RegistroProgreso>(registrosBox);
    await Hive.openBox<ProyeccionLineal>(proyeccionesBox);
    await Hive.openBox(configBox);
  }

  /// Obtiene una caja específica
  static Box<T> getBox<T>(String boxName) {
    return Hive.box<T>(boxName);
  }

  /// Cierra todas las cajas abiertas
  static Future<void> closeBoxes() async {
    await Hive.close();
  }

  /// Limpia todos los datos almacenados (usar con precaución)
  static Future<void> clearAllData() async {
    await Hive.box<Ejercicio>(ejerciciosBox).clear();
    await Hive.box<RutinaMatriz>(rutinasBox).clear();
    await Hive.box<RegistroProgreso>(registrosBox).clear();
    await Hive.box<ProyeccionLineal>(proyeccionesBox).clear();
    await Hive.box(configBox).clear();
  }

  /// Carga datos de ejemplo para demostración
  ///
  /// Útil para mostrar la funcionalidad de la app sin que el usuario
  /// tenga que ingresar datos manualmente
  static Future<void> cargarDatosEjemplo() async {
    final ejerciciosBox = Hive.box<Ejercicio>(HiveService.ejerciciosBox);

    // Verificar si ya existen datos
    if (ejerciciosBox.isNotEmpty) {
      return;
    }

    // Crear ejercicios de ejemplo
    final ejercicios = [
      Ejercicio(
        id: 'ej-1',
        nombre: 'Flexiones',
        caloriasPorUnidad: 0.32,
      ),
      Ejercicio(
        id: 'ej-2',
        nombre: 'Sentadillas',
        caloriasPorUnidad: 0.28,
      ),
      Ejercicio(
        id: 'ej-3',
        nombre: 'Dominadas',
        caloriasPorUnidad: 0.45,
      ),
      Ejercicio(
        id: 'ej-4',
        nombre: 'Abdominales',
        caloriasPorUnidad: 0.25,
      ),
    ];

    for (var ejercicio in ejercicios) {
      await ejerciciosBox.put(ejercicio.id, ejercicio);
    }
  }
}
