import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../services/funciones_service.dart';

/// Pantalla de Recuperación Exponencial: f(t) = P₀ · e^(-kt)
/// Conexión curricular: Funciones exponenciales (eliminación de fármacos)
class RecuperacionExponencialScreen extends StatefulWidget {
  const RecuperacionExponencialScreen({super.key});

  @override
  State<RecuperacionExponencialScreen> createState() =>
      _RecuperacionExponencialScreenState();
}

class _RecuperacionExponencialScreenState
    extends State<RecuperacionExponencialScreen> {
  final _fatigaInicialController = TextEditingController(text: '100');
  final _constanteKController = TextEditingController(text: '0.1');
  final _horasController = TextEditingController(text: '48');

  Map<String, dynamic>? _resultado;

  @override
  void initState() {
    super.initState();
    _calcular();
  }

  void _calcular() {
    final fatigaInicial =
        double.tryParse(_fatigaInicialController.text) ?? 100;
    final constanteK = double.tryParse(_constanteKController.text) ?? 0.1;
    final horas = int.tryParse(_horasController.text) ?? 48;

    setState(() {
      _resultado = FuncionesService.analizarRecuperacionExponencial(
        fatigaInicial: fatigaInicial,
        constanteK: constanteK,
        horas: horas,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recuperación Exponencial'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              color: Colors.blue[50],
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Función Exponencial: f(t) = P₀ · e^(-kt)',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Módulo 4: Funciones Exponenciales',
                      style: TextStyle(fontSize: 13),
                    ),
                    Text(
                      'Conexión: "Eliminación de fármacos", Decaimiento de fatiga',
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

            TextField(
              controller: _fatigaInicialController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'P₀: Fatiga Inicial (%)',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.battery_charging_full),
              ),
              onChanged: (_) => _calcular(),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _constanteKController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: const InputDecoration(
                labelText: 'k: Constante de Decaimiento',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.speed),
                helperText: 'Valores típicos: 0.05 - 0.2',
              ),
              onChanged: (_) => _calcular(),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _horasController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 't: Tiempo de Recuperación (horas)',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.access_time),
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
                      'Vida Media',
                      '${_resultado!['vidaMedia'].toStringAsFixed(1)} h',
                      Icons.timelapse,
                      Colors.blue,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildResultCard(
                      'Recuperación 90%',
                      '${_resultado!['tiempo90'].toStringAsFixed(1)} h',
                      Icons.check_circle,
                      Colors.green,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _buildResultCard(
                'Recuperación 95%',
                '${_resultado!['tiempo95'].toStringAsFixed(1)} horas',
                Icons.verified,
                Colors.teal,
              ),
              const SizedBox(height: 24),

              const Text(
                'Curva de Recuperación',
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
                        isCurved: true,
                        color: Colors.blue,
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
    _fatigaInicialController.dispose();
    _constanteKController.dispose();
    _horasController.dispose();
    super.dispose();
  }
}
