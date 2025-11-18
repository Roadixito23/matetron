import 'package:flutter/material.dart';
import 'matriz_rutinas_screen.dart';
import 'progresion_lineal_screen.dart';
import 'progresion_cuadratica_screen.dart';
import 'recuperacion_exponencial_screen.dart';
import 'rendimientos_logaritmicos_screen.dart';
import 'periodizacion_trigonometrica_screen.dart';
import 'gasto_calorico_screen.dart';

/// Pantalla principal de MATETRÓN
/// Sistema Digital de Optimización Matemática para Entrenamientos Deportivos
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'MATETRÓN',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).primaryColor.withOpacity(0.1),
              Colors.white,
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        Icon(
                          Icons.fitness_center,
                          size: 64,
                          color: Theme.of(context).primaryColor,
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Sistema Digital de Optimización',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const Text(
                          'Matemática para Entrenamientos Deportivos',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        const Divider(),
                        const SizedBox(height: 8),
                        const Text(
                          'Proyecto de Funciones y Matrices - INACAP',
                          style: TextStyle(
                            fontSize: 12,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                        const Text(
                          'Sebastián Reyes & Dante Agüero',
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Sección: Operaciones Matriciales
                _buildSectionTitle('Operaciones Matriciales'),
                const SizedBox(height: 12),
                _buildModuleCard(
                  context,
                  title: 'Matriz de Rutinas',
                  subtitle: 'Organiza ejercicios y calcula volumen total',
                  icon: Icons.grid_on,
                  color: const Color(0xFFc41e3a),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MatrizRutinasScreen(),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                _buildModuleCard(
                  context,
                  title: 'Gasto Calórico',
                  subtitle: 'Multiplicación matricial: R × C = G',
                  icon: Icons.local_fire_department,
                  color: const Color(0xFFf39c12),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const GastoCaloricoScreen(),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Sección: Funciones Matemáticas
                _buildSectionTitle('Funciones Matemáticas'),
                const SizedBox(height: 12),
                _buildModuleCard(
                  context,
                  title: 'Progresión Lineal',
                  subtitle: 'f(t) = P₀ + r·t (Grado 1)',
                  icon: Icons.trending_up,
                  color: const Color(0xFF27ae60),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ProgresionLinealScreen(),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                _buildModuleCard(
                  context,
                  title: 'Progresión Cuadrática',
                  subtitle: 'f(t) = at² + bt + c (Peak Performance)',
                  icon: Icons.show_chart,
                  color: const Color(0xFF8e44ad),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ProgresionCuadraticaScreen(),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                _buildModuleCard(
                  context,
                  title: 'Recuperación Exponencial',
                  subtitle: 'f(t) = P₀·e⁻ᵏᵗ (Fatiga Muscular)',
                  icon: Icons.healing,
                  color: const Color(0xFF3498db),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const RecuperacionExponencialScreen(),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                _buildModuleCard(
                  context,
                  title: 'Rendimientos Logarítmicos',
                  subtitle: 'f(t) = a·ln(t) + b (Atletas Avanzados)',
                  icon: Icons.auto_graph,
                  color: const Color(0xFFe67e22),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const RendimientosLogaritmicosScreen(),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                _buildModuleCard(
                  context,
                  title: 'Periodización Trigonométrica',
                  subtitle: 'f(t) = A·sen(ωt + φ) + k (Ciclos)',
                  icon: Icons.waves,
                  color: const Color(0xFF16a085),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PeriodizacionTrigonometricaScreen(),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Footer
                const Text(
                  'Desarrollado para la asignatura de Funciones y Matrices',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey,
                  ),
                ),
                const Text(
                  'Profesora: Rosalba Margot Barros Rojas',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _buildModuleCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  icon,
                  size: 32,
                  color: color,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: Colors.grey[400],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
