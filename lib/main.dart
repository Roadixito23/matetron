import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'services/hive_service.dart';
import 'providers/ejercicios_provider.dart';
import 'providers/rutinas_provider.dart';
import 'providers/registros_provider.dart';
import 'screens/home_screen.dart';
import 'utils/constantes.dart';

/// Punto de entrada de la aplicación MATETRÓN
///
/// Inicializa Hive, los providers y la aplicación Flutter
void main() async {
  // Asegurar que los bindings de Flutter estén inicializados
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializar Hive y cargar datos de ejemplo
  await HiveService.init();
  await HiveService.cargarDatosEjemplo();

  runApp(const MatetronApp());
}

/// Widget raíz de la aplicación
class MatetronApp extends StatelessWidget {
  const MatetronApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        /// Provider para gestión de ejercicios
        ChangeNotifierProvider(create: (_) => EjerciciosProvider()),

        /// Provider para gestión de rutinas
        ChangeNotifierProvider(create: (_) => RutinasProvider()),

        /// Provider para gestión de registros de progreso
        ChangeNotifierProvider(create: (_) => RegistrosProvider()),
      ],
      child: MaterialApp(
        title: Constantes.nombreApp,
        debugShowCheckedModeBanner: false,

        /// Tema oscuro principal de la aplicación
        theme: TemaMatetron.temaOscuro,

        /// Tema claro (actualmente no se usa, pero está disponible)
        /// Para implementar cambio de tema, agregar un ThemeProvider
        // darkTheme: TemaMatetron.temaOscuro,
        // themeMode: ThemeMode.dark,

        /// Pantalla inicial de la aplicación
        home: const HomeScreen(),
      ),
    );
  }
}
