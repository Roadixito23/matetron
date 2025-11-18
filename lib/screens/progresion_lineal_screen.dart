import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../services/funciones_service.dart';

/// Pantalla de Progresión Lineal: f(t) = P₀ + r·t
/// Conexión curricular: Funciones polinómicas de grado 1
class ProgresionLinealScreen extends StatefulWidget {
  const ProgresionLinealScreen({super.key});

  @override
  State<ProgresionLinealScreen> createState() => _ProgresionLinealScreenState();
}

class _ProgresionLinealScreenState extends State<ProgresionLinealScreen> {
  final _valorInicialController = TextEditingController(text: '50');
  final _tasaMejoraController = TextEditingController(text: '1.25');
  final _semanasController = TextEditingController(text: '12');

  Map<String, dynamic>? _resultado;

  @override
  void initState() {
    super.initState();
    _calcular();
  }

  void _calcular() {
    final valorInicial = double.tryParse(_valorInicialController.text) ?? 50;
    final tasaMejora = double.tryParse(_tasaMejoraController.text) ?? 1.25;
    final semanas = int.tryParse(_semanasController.text) ?? 12;

    setState(() {
      _resultado = FuncionesService.analizarProgresionLineal(
        valorInicial: valorInicial,
        tasaMejoraSemanal: tasaMejora,
        semanas: semanas,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Progresión Lineal'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Explicación
            Card(
              color: Colors.green[50],
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Función Lineal: f(t) = P₀ + r·t',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Módulo 1-2: Funciones Polinómicas de Grado 1',
                      style: TextStyle(fontSize: 13),
                    ),
                    Text(
                      'Conexión: "Consumo de energía", "Servicio eléctrico"',
                      style: TextStyle(
                        fontSize: 12,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Inputs
            TextField(
              controller: _valorInicialController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'P₀: Valor Inicial (kg)',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.fitness_center),
              ),
              onChanged: (_) => _calcular(),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _tasaMejoraController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'r: Tasa de Mejora Semanal (kg/semana)',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.trending_up),
                helperText: 'Recomendado: 2-5% del valor inicial',
              ),
              onChanged: (_) => _calcular(),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _semanasController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 't: Número de Semanas',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.calendar_today),
              ),
              onChanged: (_) => _calcular(),
            ),
            const SizedBox(height: 24),

            if (_resultado != null) ...[
              // Fórmula
              Card(
                color: Colors.blue[50],
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    _resultado!['formula'],
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'monospace',
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Resultados
              Row(
                children: [
                  Expanded(
                    child: _buildResultCard(
                      'Valor Final',
                      '${_resultado!['valorFinal'].toStringAsFixed(2)} kg',
                      Icons.flag,
                      Colors.green,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildResultCard(
                      'Mejora',
                      '${_resultado!['mejoraPorcentaje'].toStringAsFixed(1)}%',
                      Icons.trending_up,
                      Colors.blue,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Validación
              if (!_resultado!['tasaValida'])
                Card(
                  color: Colors.orange[50],
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      children: const [
                        Icon(Icons.warning, color: Colors.orange),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'La tasa de mejora está fuera del rango recomendado (2-5% semanal)',
                            style: TextStyle(fontSize: 13),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              const SizedBox(height: 24),

              // Gráfico
              const Text(
                'Proyección de Progreso',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 300,
                child: LineChart(
                  LineChartData(
                    gridData: FlGridData(show: true),
                    titlesData: FlTitlesData(
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 40,
                        ),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 30,
                        ),
                      ),
                      rightTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      topTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                    ),
                    borderData: FlBorderData(show: true),
                    lineBarsData: [
                      LineChartBarData(
                        spots: List.generate(
                          _resultado!['valores'].length,
                          (index) => FlSpot(
                            index.toDouble(),
                            _resultado!['valores'][index],
                          ),
                        ),
                        isCurved: false,
                        color: Theme.of(context).primaryColor,
                        barWidth: 3,
                        dotData: FlDotData(show: true),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildResultCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: const TextStyle(fontSize: 12),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _valorInicialController.dispose();
    _tasaMejoraController.dispose();
    _semanasController.dispose();
    super.dispose();
  }
}
