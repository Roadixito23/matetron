import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';
import '../models/registro_progreso.dart';
import '../models/ejercicio.dart';
import '../providers/registros_provider.dart';
import '../providers/ejercicios_provider.dart';
import '../utils/matematicas.dart';
import '../utils/constantes.dart';

/// Pantalla del Módulo 3: Gráfico de Tendencia
///
/// Visualiza progreso histórico y calcula tendencia usando regresión lineal
class GraficoTendenciaScreen extends StatefulWidget {
  const GraficoTendenciaScreen({super.key});

  @override
  State<GraficoTendenciaScreen> createState() => _GraficoTendenciaScreenState();
}

class _GraficoTendenciaScreenState extends State<GraficoTendenciaScreen> {
  String? _ejercicioSeleccionado;
  List<RegistroProgreso> _registros = [];
  RegresionLineal? _regresion;

  @override
  Widget build(BuildContext context) {
    final ejerciciosProvider = Provider.of<EjerciciosProvider>(context);
    final registrosProvider = Provider.of<RegistrosProvider>(context);

    // Si hay un ejercicio seleccionado, cargar sus registros
    if (_ejercicioSeleccionado != null) {
      _registros = registrosProvider.obtenerRegistrosPorEjercicio(_ejercicioSeleccionado!);
      if (_registros.isNotEmpty) {
        _regresion = RegresionLineal.calcular(_registros);
      }
    }

    return ejerciciosProvider.ejercicios.isEmpty
        ? _buildPantallaVacia()
        : _buildContenidoPrincipal(ejerciciosProvider, registrosProvider);
  }

  Widget _buildPantallaVacia() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.show_chart,
            size: 100,
            color: Constantes.colorPrimario.withOpacity(0.5),
          ),
          SizedBox(height: 24),
          Text(
            'No hay ejercicios registrados',
            style: Constantes.estiloTituloMediano,
          ),
          SizedBox(height: 12),
          Text(
            'Agrega ejercicios para comenzar a registrar tu progreso',
            style: Constantes.estiloTextoSecundario,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildContenidoPrincipal(
    EjerciciosProvider ejerciciosProvider,
    RegistrosProvider registrosProvider,
  ) {
    return Column(
      children: [
        _buildSelectorEjercicio(ejerciciosProvider),
        Expanded(
          child: _ejercicioSeleccionado == null
              ? _buildMensajeSeleccionar()
              : SingleChildScrollView(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (_registros.isNotEmpty) ...[
                        _buildGrafico(),
                        SizedBox(height: 24),
                        _buildEstadisticas(),
                        SizedBox(height: 24),
                      ],
                      _buildListaRegistros(registrosProvider),
                    ],
                  ),
                ),
        ),
      ],
    );
  }

  /// Selector de ejercicio
  Widget _buildSelectorEjercicio(EjerciciosProvider ejerciciosProvider) {
    return Container(
      padding: EdgeInsets.all(16),
      color: Color(0xFF1E1E1E),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Selecciona un ejercicio',
            style: Constantes.estiloSubtitulo,
          ),
          SizedBox(height: 12),
          DropdownButtonFormField<String>(
            value: _ejercicioSeleccionado,
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.fitness_center),
              hintText: 'Elige un ejercicio',
            ),
            items: ejerciciosProvider.ejercicios.map((ejercicio) {
              return DropdownMenuItem(
                value: ejercicio.id,
                child: Text(ejercicio.nombre),
              );
            }).toList(),
            onChanged: (valor) {
              setState(() {
                _ejercicioSeleccionado = valor;
              });
            },
          ),
        ],
      ),
    );
  }

  /// Mensaje para seleccionar un ejercicio
  Widget _buildMensajeSeleccionar() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.arrow_upward,
            size: 64,
            color: Constantes.colorPrimario.withOpacity(0.5),
          ),
          SizedBox(height: 16),
          Text(
            'Selecciona un ejercicio arriba',
            style: Constantes.estiloTextoSecundario,
          ),
        ],
      ),
    );
  }

  /// Gráfico de tendencia con regresión lineal
  Widget _buildGrafico() {
    if (_registros.isEmpty || _regresion == null) return Container();

    // Preparar datos para el gráfico
    DateTime fechaInicial = _registros.first.fecha;
    List<FlSpot> puntosReales = _registros.map((r) {
      double dias = r.fecha.difference(fechaInicial).inDays.toDouble();
      return FlSpot(dias, r.rendimiento);
    }).toList();

    // Puntos de la línea de tendencia
    double diasMax = puntosReales.last.x;
    List<FlSpot> puntosTendencia = [
      FlSpot(0, _regresion!.predecir(0)),
      FlSpot(diasMax, _regresion!.predecir(diasMax)),
      // Proyección futura (30 días más)
      FlSpot(diasMax + 30, _regresion!.predecir(diasMax + 30)),
    ];

    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Gráfico de Progreso',
              style: Constantes.estiloSubtitulo,
            ),
            SizedBox(height: 16),
            SizedBox(
              height: 300,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(show: true),
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      axisNameWidget: Text('Días'),
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 30,
                      ),
                    ),
                    leftTitles: AxisTitles(
                      axisNameWidget: Text(_registros.first.unidad),
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                      ),
                    ),
                    topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  borderData: FlBorderData(show: true),
                  lineBarsData: [
                    // Datos reales
                    LineChartBarData(
                      spots: puntosReales,
                      isCurved: false,
                      color: Constantes.colorPrimario,
                      barWidth: 0,
                      dotData: FlDotData(
                        show: true,
                        getDotPainter: (spot, percent, bar, index) {
                          return FlDotCirclePainter(
                            radius: 4,
                            color: Constantes.colorPrimario,
                            strokeWidth: 2,
                            strokeColor: Colors.white,
                          );
                        },
                      ),
                    ),
                    // Línea de tendencia
                    LineChartBarData(
                      spots: puntosTendencia,
                      isCurved: false,
                      color: Constantes.colorSecundario,
                      barWidth: 2,
                      dotData: FlDotData(show: false),
                      dashArray: [5, 5], // Línea punteada
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildLeyenda(Constantes.colorPrimario, 'Datos reales'),
                SizedBox(width: 20),
                _buildLeyenda(Constantes.colorSecundario, 'Tendencia'),
              ],
            ),
            SizedBox(height: 8),
            Center(
              child: Text(
                _regresion.toString(),
                style: Constantes.estiloTextoSecundario,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Widget de leyenda para el gráfico
  Widget _buildLeyenda(Color color, String texto) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(width: 6),
        Text(texto, style: Constantes.estiloTextoSecundario),
      ],
    );
  }

  /// Estadísticas de la regresión
  Widget _buildEstadisticas() {
    if (_regresion == null) return Container();

    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Estadísticas',
              style: Constantes.estiloSubtitulo,
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildMetrica(
                  'Pendiente',
                  _regresion!.pendiente.toStringAsFixed(3),
                  'por día',
                ),
                _buildMetrica(
                  'R²',
                  _regresion!.r2.toStringAsFixed(3),
                  _regresion!.calidadAjuste,
                ),
                _buildMetrica(
                  'Registros',
                  _regresion!.n.toString(),
                  'puntos de datos',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Widget de métrica
  Widget _buildMetrica(String titulo, String valor, String subtitulo) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          titulo,
          style: Constantes.estiloTextoSecundario,
        ),
        SizedBox(height: 4),
        Text(
          valor,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Constantes.colorPrimario,
          ),
        ),
        Text(
          subtitulo,
          style: Constantes.estiloTextoSecundario.copyWith(fontSize: 12),
        ),
      ],
    );
  }

  /// Lista de registros históricos
  Widget _buildListaRegistros(RegistrosProvider registrosProvider) {
    final ejerciciosProvider = Provider.of<EjerciciosProvider>(context, listen: false);
    final ejercicio = ejerciciosProvider.obtenerEjercicio(_ejercicioSeleccionado!);

    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Historial de Registros',
                  style: Constantes.estiloSubtitulo,
                ),
                ElevatedButton.icon(
                  onPressed: () => _mostrarDialogoNuevoRegistro(ejercicio),
                  icon: Icon(Icons.add, size: 18),
                  label: Text('Agregar'),
                ),
              ],
            ),
            SizedBox(height: 12),
            if (_registros.isEmpty)
              Padding(
                padding: EdgeInsets.all(32),
                child: Center(
                  child: Text(
                    'No hay registros para este ejercicio',
                    style: Constantes.estiloTextoSecundario,
                  ),
                ),
              )
            else
              ListView.separated(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: _registros.length,
                separatorBuilder: (context, index) => Divider(),
                itemBuilder: (context, index) {
                  final registro = _registros[_registros.length - 1 - index];
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Constantes.colorPrimario.withOpacity(0.2),
                      child: Icon(
                        Icons.trending_up,
                        color: Constantes.colorPrimario,
                      ),
                    ),
                    title: Text(
                      '${registro.rendimiento} ${registro.unidad}',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      DateFormat('dd/MM/yyyy').format(registro.fecha),
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.delete, color: Constantes.colorPeligro),
                      onPressed: () => _eliminarRegistro(registrosProvider, registro),
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }

  /// Muestra diálogo para agregar nuevo registro
  void _mostrarDialogoNuevoRegistro(Ejercicio? ejercicio) {
    if (ejercicio == null) return;

    final rendimientoController = TextEditingController();
    final unidadController = TextEditingController(text: 'reps');
    DateTime fechaSeleccionada = DateTime.now();

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text('Nuevo Registro'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: rendimientoController,
                decoration: InputDecoration(
                  labelText: 'Rendimiento',
                  hintText: 'ej: 25',
                ),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                autofocus: true,
              ),
              SizedBox(height: 12),
              TextField(
                controller: unidadController,
                decoration: InputDecoration(
                  labelText: 'Unidad',
                  hintText: 'ej: reps, kg, min',
                ),
              ),
              SizedBox(height: 12),
              ListTile(
                title: Text('Fecha'),
                subtitle: Text(DateFormat('dd/MM/yyyy').format(fechaSeleccionada)),
                trailing: Icon(Icons.calendar_today),
                onTap: () async {
                  final fecha = await showDatePicker(
                    context: context,
                    initialDate: fechaSeleccionada,
                    firstDate: DateTime(2020),
                    lastDate: DateTime.now(),
                  );
                  if (fecha != null) {
                    setDialogState(() {
                      fechaSeleccionada = fecha;
                    });
                  }
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                final rendimiento = double.tryParse(rendimientoController.text);
                if (rendimiento != null && unidadController.text.isNotEmpty) {
                  _agregarRegistro(
                    ejercicio,
                    rendimiento,
                    unidadController.text,
                    fechaSeleccionada,
                  );
                  Navigator.pop(context);
                }
              },
              child: Text('Guardar'),
            ),
          ],
        ),
      ),
    );
  }

  /// Agrega un nuevo registro
  void _agregarRegistro(
    Ejercicio ejercicio,
    double rendimiento,
    String unidad,
    DateTime fecha,
  ) {
    final registrosProvider = Provider.of<RegistrosProvider>(context, listen: false);

    final registro = RegistroProgreso(
      id: Uuid().v4(),
      ejercicioId: ejercicio.id,
      fecha: fecha,
      rendimiento: rendimiento,
      unidad: unidad,
    );

    registrosProvider.agregarRegistro(registro);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Registro agregado')),
    );
  }

  /// Elimina un registro
  void _eliminarRegistro(RegistrosProvider provider, RegistroProgreso registro) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Eliminar Registro'),
        content: Text('¿Seguro que deseas eliminar este registro?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              provider.eliminarRegistro(registro.id);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Registro eliminado')),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Constantes.colorPeligro,
            ),
            child: Text('Eliminar'),
          ),
        ],
      ),
    );
  }
}
