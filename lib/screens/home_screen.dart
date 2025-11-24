import 'package:flutter/material.dart';
import '../utils/constantes.dart';
import 'matriz_rutinas_screen.dart';
import 'calculadora_progresion_screen.dart';
import 'grafico_tendencia_screen.dart';
import 'dashboard_screen.dart';

/// Pantalla principal de la aplicación MATETRÓN
///
/// Contiene la navegación inferior con 4 módulos:
/// 1. Matriz de Rutinas
/// 2. Calculadora de Progresión
/// 3. Gráfico de Tendencia
/// 4. Dashboard de Indicadores
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  /// Índice de la pestaña seleccionada
  int _indiceActual = 0;

  /// Lista de pantallas correspondientes a cada pestaña
  final List<Widget> _pantallas = [
    const MatrizRutinasScreen(),
    const CalculadoraProgresionScreen(),
    const GraficoTendenciaScreen(),
    const DashboardScreen(),
  ];

  /// Títulos para cada pantalla
  final List<String> _titulos = [
    'Matriz de Rutinas',
    'Calculadora de Progresión',
    'Gráfico de Tendencia',
    'Dashboard',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.fitness_center,
              color: Constantes.colorPrimario,
              size: 28,
            ),
            SizedBox(width: 8),
            Text(
              Constantes.nombreApp,
              style: TextStyle(
                color: Constantes.colorPrimario,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: AnimatedSwitcher(
        duration: Constantes.duracionAnimacionRapida,
        child: _pantallas[_indiceActual],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _indiceActual,
        onTap: (index) {
          setState(() {
            _indiceActual = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        selectedFontSize: 12,
        unselectedFontSize: 11,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Constantes.iconoMatriz),
            label: 'Rutinas',
            tooltip: 'Matriz de Rutinas',
          ),
          BottomNavigationBarItem(
            icon: Icon(Constantes.iconoCalculadora),
            label: 'Progresión',
            tooltip: 'Calculadora de Progresión',
          ),
          BottomNavigationBarItem(
            icon: Icon(Constantes.iconoGrafico),
            label: 'Tendencia',
            tooltip: 'Gráfico de Tendencia',
          ),
          BottomNavigationBarItem(
            icon: Icon(Constantes.iconoDashboard),
            label: 'Dashboard',
            tooltip: 'Indicadores',
          ),
        ],
      ),
    );
  }
}
