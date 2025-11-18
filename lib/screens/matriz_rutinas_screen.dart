import 'package:flutter/material.dart';
import '../models/rutina.dart';
import '../models/ejercicio.dart';
import '../services/matriz_service.dart';

/// Pantalla para crear y gestionar la matriz de rutinas (4×7)
/// Implementa operaciones matriciales y sumatoria: V_total = Σᵢ Σⱼ rᵢⱼ
class MatrizRutinasScreen extends StatefulWidget {
  const MatrizRutinasScreen({super.key});

  @override
  State<MatrizRutinasScreen> createState() => _MatrizRutinasScreenState();
}

class _MatrizRutinasScreenState extends State<MatrizRutinasScreen> {
  late Rutina rutina;
  static const List<String> diasSemana = [
    'Lun',
    'Mar',
    'Mie',
    'Jue',
    'Vie',
    'Sab',
    'Dom'
  ];

  @override
  void initState() {
    super.initState();
    // Cargar rutina de ejemplo
    rutina = MatrizService.crearRutinaEjemplo();
  }

  @override
  Widget build(BuildContext context) {
    final validacion = MatrizService.validarVolumen(rutina.volumenTotal);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Matriz de Rutinas'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                rutina = Rutina(
                  nombre: 'Nueva Rutina',
                  fechaCreacion: DateTime.now(),
                );
              });
            },
            tooltip: 'Limpiar matriz',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Título explicativo
            Card(
              color: Colors.blue[50],
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Matriz de Rutinas 4×7',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Organiza 4 ejercicios × 7 días de la semana',
                      style: TextStyle(fontSize: 13),
                    ),
                    Text(
                      'Fórmula: V_total = Σᵢ Σⱼ (series × repeticiones)ᵢⱼ',
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

            // Tabla de matriz
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                headingRowColor: MaterialStateProperty.all(
                  Theme.of(context).primaryColor.withOpacity(0.1),
                ),
                columns: [
                  const DataColumn(label: Text('Ejercicio')),
                  ...diasSemana.map((dia) => DataColumn(
                        label: Text(
                          dia,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      )),
                ],
                rows: List.generate(
                  Rutina.numEjercicios,
                  (ejercicioIndex) => DataRow(
                    cells: [
                      DataCell(
                        Text(
                          MatrizService
                              .nombresEjerciciosDefault[ejercicioIndex],
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                      ...List.generate(
                        Rutina.diasSemana,
                        (diaIndex) {
                          final ejercicio =
                              rutina.getEjercicio(ejercicioIndex, diaIndex);
                          return DataCell(
                            GestureDetector(
                              onTap: () => _editarEjercicio(
                                ejercicioIndex,
                                diaIndex,
                              ),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: ejercicio != null
                                      ? Theme.of(context)
                                          .primaryColor
                                          .withOpacity(0.1)
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  ejercicio != null
                                      ? '${ejercicio.series}×${ejercicio.repeticiones}'
                                      : '-',
                                  style: TextStyle(
                                    fontWeight: ejercicio != null
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                    color: ejercicio != null
                                        ? Theme.of(context).primaryColor
                                        : Colors.grey,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Estadísticas
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    'Volumen Total',
                    rutina.volumenTotal.toString(),
                    'repeticiones',
                    Icons.fitness_center,
                    validacion['nivel'] == 'optimo'
                        ? Colors.green
                        : validacion['nivel'] == 'bajo'
                            ? Colors.orange
                            : Colors.red,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard(
                    'Promedio/Día',
                    (rutina.volumenTotal / 7).toStringAsFixed(0),
                    'reps/día',
                    Icons.calendar_today,
                    Colors.blue,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Validación de volumen
            Card(
              color: _getColorForNivel(validacion['nivel']).withOpacity(0.1),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          _getIconForNivel(validacion['nivel']),
                          color: _getColorForNivel(validacion['nivel']),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Estado: ${validacion['nivel'].toString().toUpperCase()}',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: _getColorForNivel(validacion['nivel']),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      validacion['mensaje'],
                      style: const TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 8),
                    LinearProgressIndicator(
                      value: (validacion['porcentaje'] / 150).clamp(0.0, 1.0),
                      backgroundColor: Colors.grey[300],
                      valueColor: AlwaysStoppedAnimation(
                        _getColorForNivel(validacion['nivel']),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Volumen por día
            const Text(
              'Volumen por Día',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            ...List.generate(
              Rutina.diasSemana,
              (dia) => Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Row(
                  children: [
                    SizedBox(
                      width: 40,
                      child: Text(
                        diasSemana[dia],
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                    Expanded(
                      child: LinearProgressIndicator(
                        value: rutina.volumenTotal > 0
                            ? rutina.volumenPorDia[dia] / rutina.volumenTotal
                            : 0,
                        backgroundColor: Colors.grey[300],
                        minHeight: 24,
                      ),
                    ),
                    const SizedBox(width: 8),
                    SizedBox(
                      width: 50,
                      child: Text(
                        '${rutina.volumenPorDia[dia]} reps',
                        style: const TextStyle(fontSize: 12),
                        textAlign: TextAlign.right,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    String unit,
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
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(
              unit,
              style: const TextStyle(fontSize: 11, color: Colors.grey),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: const TextStyle(fontSize: 13),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Color _getColorForNivel(String nivel) {
    switch (nivel) {
      case 'bajo':
        return Colors.orange;
      case 'optimo':
        return Colors.green;
      case 'alto':
        return Colors.amber;
      case 'excesivo':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  IconData _getIconForNivel(String nivel) {
    switch (nivel) {
      case 'bajo':
        return Icons.trending_down;
      case 'optimo':
        return Icons.check_circle;
      case 'alto':
        return Icons.warning;
      case 'excesivo':
        return Icons.error;
      default:
        return Icons.info;
    }
  }

  void _editarEjercicio(int ejercicioIndex, int diaIndex) {
    final ejercicioActual = rutina.getEjercicio(ejercicioIndex, diaIndex);
    final seriesController = TextEditingController(
      text: ejercicioActual?.series.toString() ?? '',
    );
    final repsController = TextEditingController(
      text: ejercicioActual?.repeticiones.toString() ?? '',
    );
    final pesoController = TextEditingController(
      text: ejercicioActual?.peso?.toString() ?? '',
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          '${MatrizService.nombresEjerciciosDefault[ejercicioIndex]} - ${diasSemana[diaIndex]}',
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: seriesController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Series',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: repsController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Repeticiones',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: pesoController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Peso (kg) - Opcional',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                rutina.setEjercicio(ejercicioIndex, diaIndex, null);
              });
              Navigator.pop(context);
            },
            child: const Text('Eliminar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              final series = int.tryParse(seriesController.text);
              final reps = int.tryParse(repsController.text);
              final peso = double.tryParse(pesoController.text);

              if (series != null && reps != null) {
                setState(() {
                  rutina.setEjercicio(
                    ejercicioIndex,
                    diaIndex,
                    Ejercicio(
                      nombre: MatrizService
                          .nombresEjerciciosDefault[ejercicioIndex],
                      series: series,
                      repeticiones: reps,
                      peso: peso,
                    ),
                  );
                });
              }
              Navigator.pop(context);
            },
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
  }
}
