import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../services/funciones_service.dart';
import 'dart:math' as math;

/// Pantalla de Periodización Trigonométrica: f(t) = A · sen(ωt + φ) + k
/// Conexión curricular: Funciones trigonométricas (ciclos de entrenamiento)
class PeriodizacionTrigonometricaScreen extends StatefulWidget {
  const PeriodizacionTrigonometricaScreen({super.key});

  @override
  State<PeriodizacionTrigonometricaScreen> createState() =>
      _PeriodizacionTrigonometricaScreenState();
}

class _PeriodizacionTrigonometricaScreenState
    extends State<PeriodizacionTrigonometricaScreen> {
  final _amplitudController = TextEditingController(text: '20');
  final _periodoController = TextEditingController(text: '4');
  final _faseController = TextEditingController(text: '0');
  final _valorMedioController = TextEditingController(text: '70');
  final _semanasController = TextEditingController(text: '16');

  Map<String, dynamic>? _resultado;

  @override
  void initState() {
    super.initState();
    _calcular();
  }

  void _calcular() {
    final amplitud = double.tryParse(_amplitudController.text) ?? 20;
    final periodo = double.tryParse(_periodoController.text) ?? 4;
    final fase = double.tryParse(_faseController.text) ?? 0;
    final valorMedio = double.tryParse(_valorMedioController.text) ?? 70;
    final semanas = int.tryParse(_semanasController.text) ?? 16;

    setState(() {
      _resultado = FuncionesService.analizarPeriodizacion(
        amplitud: amplitud,
        periodo: periodo,
        fase: fase,
        valorMedio: valorMedio,
        semanas: semanas,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Periodización Trigonométrica'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              color: Colors.teal[50],
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Función Sinusoidal: f(t) = A · sen(ωt + φ) + k',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Módulo 3: Funciones Trigonométricas',
                      style: TextStyle(fontSize: 13),
                    ),
                    Text(
                      'Conexión: "Análisis de ondas sonoras", Ciclos de carga/descarga',
                      style: TextStyle(
                        fontSize: 12,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Modela la variación cíclica de intensidad en mesociclos de entrenamiento.',
                      style: TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _amplitudController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'A: Amplitud (%)',
                      border: OutlineInputBorder(),
                      helperText: 'Variación de intensidad',
                    ),
                    onChanged: (_) => _calcular(),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: _periodoController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Período (semanas)',
                      border: OutlineInputBorder(),
                      helperText: 'Duración del ciclo',
                    ),
                    onChanged: (_) => _calcular(),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _faseController,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    decoration: const InputDecoration(
                      labelText: 'φ: Fase (radianes)',
                      border: OutlineInputBorder(),
                      helperText: 'Desplazamiento',
                    ),
                    onChanged: (_) => _calcular(),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: _valorMedioController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'k: Intensidad media (%)',
                      border: OutlineInputBorder(),
                      helperText: 'Línea base',
                    ),
                    onChanged: (_) => _calcular(),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _semanasController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Semanas a Planificar',
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
                  child: Column(
                    children: [
                      Text(
                        _resultado!['formula'],
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'monospace',
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'ω = ${_resultado!['omega'].toStringAsFixed(4)} rad/semana',
                        style: const TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: _buildResultCard(
                      'Intensidad Máxima',
                      '${_resultado!['intensidadMaxima'].toStringAsFixed(0)}%',
                      Icons.arrow_upward,
                      Colors.red,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildResultCard(
                      'Intensidad Mínima',
                      '${_resultado!['intensidadMinima'].toStringAsFixed(0)}%',
                      Icons.arrow_downward,
                      Colors.blue,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _buildResultCard(
                'Variación Total',
                '±${_resultado!['variacion'].toStringAsFixed(0)}% del promedio',
                Icons.swap_vert,
                Colors.orange,
              ),
              const SizedBox(height: 24),

              const Text(
                'Onda de Periodización',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Ciclos de carga (alta intensidad) y descarga (baja intensidad)',
                style: TextStyle(fontSize: 12, color: Colors.grey),
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
                        color: Colors.teal,
                        barWidth: 3,
                        dotData: FlDotData(show: true),
                      ),
                    ],
                    extraLinesData: ExtraLinesData(
                      horizontalLines: [
                        HorizontalLine(
                          y: _resultado!['intensidadMaxima']!,
                          color: Colors.red.withOpacity(0.3),
                          strokeWidth: 1,
                          dashArray: [5, 5],
                        ),
                        HorizontalLine(
                          y: _resultado!['intensidadMinima']!,
                          color: Colors.blue.withOpacity(0.3),
                          strokeWidth: 1,
                          dashArray: [5, 5],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              Card(
                color: Colors.amber[50],
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Row(
                        children: [
                          Icon(Icons.lightbulb, color: Colors.amber),
                          SizedBox(width: 8),
                          Text(
                            'Interpretación',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Text(
                        '• Semanas de carga: alta intensidad (picos de la onda)',
                        style: TextStyle(fontSize: 12),
                      ),
                      Text(
                        '• Semanas de descarga: baja intensidad (valles de la onda)',
                        style: TextStyle(fontSize: 12),
                      ),
                      Text(
                        '• Periodo típico: 4 semanas (3 carga + 1 descarga)',
                        style: TextStyle(fontSize: 12),
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
                fontSize: 18,
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
    _amplitudController.dispose();
    _periodoController.dispose();
    _faseController.dispose();
    _valorMedioController.dispose();
    _semanasController.dispose();
    super.dispose();
  }
}
