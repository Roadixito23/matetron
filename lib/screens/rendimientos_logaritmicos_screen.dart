import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../services/funciones_service.dart';

/// Pantalla de Rendimientos Logarítmicos: f(t) = a · ln(t) + b
/// Conexión curricular: Funciones logarítmicas (atletas avanzados)
class RendimientosLogaritmicosScreen extends StatefulWidget {
  const RendimientosLogaritmicosScreen({super.key});

  @override
  State<RendimientosLogaritmicosScreen> createState() =>
      _RendimientosLogaritmicosScreenState();
}

class _RendimientosLogaritmicosScreenState
    extends State<RendimientosLogaritmicosScreen> {
  final _aController = TextEditingController(text: '5');
  final _bController = TextEditingController(text: '50');
  final _semanasController = TextEditingController(text: '20');

  Map<String, dynamic>? _resultado;

  @override
  void initState() {
    super.initState();
    _calcular();
  }

  void _calcular() {
    final a = double.tryParse(_aController.text) ?? 5;
    final b = double.tryParse(_bController.text) ?? 50;
    final semanas = int.tryParse(_semanasController.text) ?? 20;

    setState(() {
      _resultado = FuncionesService.analizarProgresionLogaritmica(
        a: a,
        b: b,
        semanas: semanas,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rendimientos Logarítmicos'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              color: Colors.orange[50],
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Función Logarítmica: f(t) = a · ln(t) + b',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Módulo 5: Funciones Logarítmicas',
                      style: TextStyle(fontSize: 13),
                    ),
                    Text(
                      'Conexión: "Escala Richter", Rendimientos decrecientes',
                      style: TextStyle(
                        fontSize: 12,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Cada mejora requiere más tiempo y esfuerzo. Típico en atletas intermedios/avanzados.',
                      style: TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            TextField(
              controller: _aController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: const InputDecoration(
                labelText: 'a: Factor de Escala',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.zoom_out),
                helperText: 'Controla la velocidad de desaceleración',
              ),
              onChanged: (_) => _calcular(),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _bController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'b: Nivel Base (kg)',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.fitness_center),
                helperText: 'Nivel inicial del atleta',
              ),
              onChanged: (_) => _calcular(),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _semanasController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 't: Semanas de Entrenamiento',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.calendar_today),
              ),
              onChanged: (_) => _calcular(),
            ),
            const SizedBox(height: 24),

            if (_resultado != null) ...[
              Card(
                color: Colors.blue[50],
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    _resultado!['formula'],
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'monospace',
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: _buildResultCard(
                      'Valor Inicial',
                      '${_resultado!['valorInicial'].toStringAsFixed(1)} kg',
                      Icons.play_arrow,
                      Colors.blue,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildResultCard(
                      'Valor Final',
                      '${_resultado!['valorFinal'].toStringAsFixed(1)} kg',
                      Icons.flag,
                      Colors.green,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              Card(
                color: Colors.amber[50],
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Análisis de Rendimientos Decrecientes',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Mejora semanas 1-4:'),
                          Text(
                            '${_resultado!['mejoraSemana1a4'].toStringAsFixed(2)} kg',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Mejora últimas 4 semanas:'),
                          Text(
                            '${_resultado!['mejoraSemanaFinal'].toStringAsFixed(2)} kg',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Nota: La mejora se desacelera con el tiempo, requiriendo más esfuerzo para cada ganancia.',
                        style: TextStyle(
                          fontSize: 11,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              const Text(
                'Curva de Progresión Logarítmica',
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
                            (index + 1).toDouble(),
                            _resultado!['valores'][index],
                          ),
                        ),
                        isCurved: true,
                        color: Colors.orange,
                        barWidth: 3,
                        dotData: FlDotData(show: false),
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
    _aController.dispose();
    _bController.dispose();
    _semanasController.dispose();
    super.dispose();
  }
}
