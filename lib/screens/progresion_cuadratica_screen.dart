import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../services/funciones_service.dart';

/// Pantalla de Progresión Cuadrática: f(t) = at² + bt + c
/// Conexión curricular: Funciones polinómicas de grado 2 (Peak Performance)
class ProgresionCuadraticaScreen extends StatefulWidget {
  const ProgresionCuadraticaScreen({super.key});

  @override
  State<ProgresionCuadraticaScreen> createState() =>
      _ProgresionCuadraticaScreenState();
}

class _ProgresionCuadraticaScreenState
    extends State<ProgresionCuadraticaScreen> {
  final _aController = TextEditingController(text: '-0.5');
  final _bController = TextEditingController(text: '6');
  final _cController = TextEditingController(text: '50');
  final _semanasController = TextEditingController(text: '16');

  Map<String, dynamic>? _resultado;

  @override
  void initState() {
    super.initState();
    _calcular();
  }

  void _calcular() {
    final a = double.tryParse(_aController.text) ?? -0.5;
    final b = double.tryParse(_bController.text) ?? 6;
    final c = double.tryParse(_cController.text) ?? 50;
    final semanas = int.tryParse(_semanasController.text) ?? 16;

    setState(() {
      _resultado = FuncionesService.analizarProgresionCuadratica(
        a: a,
        b: b,
        c: c,
        semanas: semanas,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Progresión Cuadrática'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              color: Colors.purple[50],
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Función Cuadrática: f(t) = at² + bt + c',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Módulo 2: Funciones Polinómicas de Grado 2',
                      style: TextStyle(fontSize: 13),
                    ),
                    Text(
                      'Conexión: "Lanzamiento de una piedra", "Peak Performance"',
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

            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _aController,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                      signed: true,
                    ),
                    decoration: const InputDecoration(
                      labelText: 'a (coef. cuadrático)',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (_) => _calcular(),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: _bController,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                      signed: true,
                    ),
                    decoration: const InputDecoration(
                      labelText: 'b (coef. lineal)',
                      border: OutlineInputBorder(),
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
                    controller: _cController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'c (intercepto)',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (_) => _calcular(),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: _semanasController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Semanas',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (_) => _calcular(),
                  ),
                ),
              ],
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

              Card(
                color: Colors.amber[50],
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.star,
                            color: Colors.amber[700],
                            size: 32,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Vértice (${_resultado!['tipoVertice']})',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Semana óptima: ${_resultado!['semanaOptima']!.toStringAsFixed(1)}',
                                  style: const TextStyle(fontSize: 14),
                                ),
                                Text(
                                  'Valor óptimo: ${_resultado!['valorOptimo']!.toStringAsFixed(2)} kg',
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              const Text(
                'Proyección Parabólica',
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
                        color: Colors.purple,
                        barWidth: 3,
                        dotData: FlDotData(show: true),
                      ),
                    ],
                    extraLinesData: ExtraLinesData(
                      verticalLines: [
                        VerticalLine(
                          x: _resultado!['semanaOptima']!,
                          color: Colors.amber,
                          strokeWidth: 2,
                          dashArray: [5, 5],
                          label: VerticalLineLabel(
                            show: true,
                            style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _aController.dispose();
    _bController.dispose();
    _cController.dispose();
    _semanasController.dispose();
    super.dispose();
  }
}
