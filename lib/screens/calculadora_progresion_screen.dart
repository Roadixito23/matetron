import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/proyeccion_lineal.dart';
import '../utils/constantes.dart';

/// Pantalla del Módulo 2: Calculadora de Progresión
///
/// Calcula y proyecta mejoras usando la función lineal f(t) = P₀ + r·t
/// Valida tasas de mejora según el nivel del deportista
class CalculadoraProgresionScreen extends StatefulWidget {
  const CalculadoraProgresionScreen({super.key});

  @override
  State<CalculadoraProgresionScreen> createState() => _CalculadoraProgresionScreenState();
}

class _CalculadoraProgresionScreenState extends State<CalculadoraProgresionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _p0Controller = TextEditingController();
  final _pfController = TextEditingController();
  final _semanasController = TextEditingController();

  NivelDeportista _nivelSeleccionado = NivelDeportista.principiante;
  ProyeccionLineal? _proyeccion;

  @override
  void dispose() {
    _p0Controller.dispose();
    _pfController.dispose();
    _semanasController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildTituloSeccion('Datos Iniciales'),
          SizedBox(height: 12),
          _buildFormulario(),
          SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: _calcularProyeccion,
            icon: Icon(Icons.calculate),
            label: Text('Calcular Proyección'),
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.all(16),
            ),
          ),
          if (_proyeccion != null) ...[
            SizedBox(height: 32),
            _buildResultados(),
            SizedBox(height: 24),
            _buildGrafico(),
            SizedBox(height: 24),
            _buildTablaProyeccion(),
          ],
        ],
      ),
    );
  }

  /// Título de sección
  Widget _buildTituloSeccion(String titulo) {
    return Text(
      titulo,
      style: Constantes.estiloSubtitulo,
    );
  }

  /// Formulario de entrada de datos
  Widget _buildFormulario() {
    return Form(
      key: _formKey,
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              TextFormField(
                controller: _p0Controller,
                decoration: InputDecoration(
                  labelText: 'Rendimiento Inicial (P₀)',
                  hintText: 'ej: 20',
                  helperText: 'Tu rendimiento actual',
                  prefixIcon: Icon(Icons.start),
                ),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Ingresa el rendimiento inicial';
                  }
                  final numero = double.tryParse(value);
                  if (numero == null || numero <= 0) {
                    return 'Debe ser un número mayor a 0';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _pfController,
                decoration: InputDecoration(
                  labelText: 'Meta Deseada (Pf)',
                  hintText: 'ej: 30',
                  helperText: 'Tu objetivo a alcanzar',
                  prefixIcon: Icon(Icons.flag),
                ),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Ingresa la meta deseada';
                  }
                  final numero = double.tryParse(value);
                  if (numero == null || numero <= 0) {
                    return 'Debe ser un número mayor a 0';
                  }
                  final p0 = double.tryParse(_p0Controller.text) ?? 0;
                  if (numero <= p0) {
                    return 'La meta debe ser mayor al rendimiento inicial';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _semanasController,
                decoration: InputDecoration(
                  labelText: 'Tiempo Objetivo (semanas)',
                  hintText: 'ej: 12',
                  helperText: 'Entre ${Constantes.minSemanas} y ${Constantes.maxSemanas} semanas',
                  prefixIcon: Icon(Icons.calendar_today),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Ingresa el número de semanas';
                  }
                  final numero = int.tryParse(value);
                  if (numero == null ||
                      numero < Constantes.minSemanas ||
                      numero > Constantes.maxSemanas) {
                    return 'Entre ${Constantes.minSemanas} y ${Constantes.maxSemanas} semanas';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              DropdownButtonFormField<NivelDeportista>(
                value: _nivelSeleccionado,
                decoration: InputDecoration(
                  labelText: 'Nivel del Deportista',
                  prefixIcon: Icon(Icons.person),
                ),
                items: [
                  DropdownMenuItem(
                    value: NivelDeportista.principiante,
                    child: Text('Principiante (5-10% semanal)'),
                  ),
                  DropdownMenuItem(
                    value: NivelDeportista.intermedio,
                    child: Text('Intermedio (3-5% semanal)'),
                  ),
                  DropdownMenuItem(
                    value: NivelDeportista.avanzado,
                    child: Text('Avanzado (1-3% semanal)'),
                  ),
                ],
                onChanged: (valor) {
                  setState(() {
                    _nivelSeleccionado = valor!;
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Calcula la proyección lineal
  void _calcularProyeccion() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final p0 = double.parse(_p0Controller.text);
    final pf = double.parse(_pfController.text);
    final semanas = int.parse(_semanasController.text);

    setState(() {
      _proyeccion = ProyeccionLineal.calcular(
        p0: p0,
        pf: pf,
        semanas: semanas,
        nivel: _nivelSeleccionado,
      );
    });
  }

  /// Muestra los resultados de la proyección
  Widget _buildResultados() {
    if (_proyeccion == null) return Container();

    Color colorRiesgo;
    switch (_proyeccion!.nivelRiesgo) {
      case 'bajo':
        colorRiesgo = Constantes.colorExito;
        break;
      case 'medio':
        colorRiesgo = Constantes.colorAdvertencia;
        break;
      case 'alto':
        colorRiesgo = Constantes.colorPeligro;
        break;
      default:
        colorRiesgo = Constantes.colorExito;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildTituloSeccion('Resultados'),
        SizedBox(height: 12),
        Card(
          color: colorRiesgo.withOpacity(0.1),
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildMetrica(
                      'Tasa (r)',
                      '${_proyeccion!.r.toStringAsFixed(2)}',
                      'por semana',
                    ),
                    _buildMetrica(
                      'Mejora Semanal',
                      '${_proyeccion!.porcentajeMejoraSemanal.toStringAsFixed(2)}%',
                      '',
                    ),
                    _buildMetrica(
                      'Mejora Total',
                      '${_proyeccion!.porcentajeMejoraTotal.toStringAsFixed(1)}%',
                      '',
                    ),
                  ],
                ),
                Divider(height: 32),
                Icon(
                  _proyeccion!.esTasaSaludable
                      ? Icons.check_circle
                      : Icons.warning,
                  size: 48,
                  color: colorRiesgo,
                ),
                SizedBox(height: 12),
                Text(
                  _obtenerMensajeRiesgo(),
                  style: TextStyle(
                    fontSize: 16,
                    color: colorRiesgo,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// Widget para mostrar una métrica
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
          style: Constantes.estiloNumeroGrande.copyWith(fontSize: 24),
        ),
        if (subtitulo.isNotEmpty)
          Text(
            subtitulo,
            style: Constantes.estiloTextoSecundario.copyWith(fontSize: 12),
          ),
      ],
    );
  }

  /// Obtiene el mensaje según el nivel de riesgo
  String _obtenerMensajeRiesgo() {
    switch (_proyeccion!.nivelRiesgo) {
      case 'bajo':
        return Constantes.mensajeTasaSaludable;
      case 'medio':
        return Constantes.mensajeAdvertencia;
      case 'alto':
        return Constantes.mensajePeligro;
      default:
        return '';
    }
  }

  /// Gráfico de la función lineal f(t) = P₀ + r·t
  Widget _buildGrafico() {
    if (_proyeccion == null) return Container();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildTituloSeccion('Gráfico de Proyección'),
        SizedBox(height: 12),
        Card(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: SizedBox(
              height: 250,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(show: true),
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 30,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            'S${value.toInt()}',
                            style: TextStyle(fontSize: 10),
                          );
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
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
                    LineChartBarData(
                      spots: List.generate(_proyeccion!.proyeccion.length, (i) {
                        return FlSpot(i.toDouble(), _proyeccion!.proyeccion[i]);
                      }),
                      isCurved: false,
                      color: Constantes.colorPrimario,
                      barWidth: 3,
                      dotData: FlDotData(show: false),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: 8),
        Center(
          child: Text(
            'f(t) = ${_proyeccion!.p0.toStringAsFixed(1)} + ${_proyeccion!.r.toStringAsFixed(2)}·t',
            style: Constantes.estiloTextoSecundario,
          ),
        ),
      ],
    );
  }

  /// Tabla con proyección semanal detallada
  Widget _buildTablaProyeccion() {
    if (_proyeccion == null) return Container();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildTituloSeccion('Proyección Semanal'),
        SizedBox(height: 12),
        Card(
          child: Padding(
            padding: EdgeInsets.all(8),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columnSpacing: 24,
                columns: [
                  DataColumn(label: Text('Semana')),
                  DataColumn(label: Text('Proyección')),
                  DataColumn(label: Text('Tipo')),
                ],
                rows: List.generate(_proyeccion!.semanas + 1, (i) {
                  bool esDescarga = _proyeccion!.esSemanaDescarga(i);
                  double valor = esDescarga
                      ? _proyeccion!.obtenerProyeccionConDescarga(i)
                      : _proyeccion!.proyeccion[i];

                  return DataRow(
                    color: MaterialStateProperty.resolveWith((states) {
                      if (esDescarga) {
                        return Constantes.colorAdvertencia.withOpacity(0.1);
                      }
                      return null;
                    }),
                    cells: [
                      DataCell(Text('Semana $i')),
                      DataCell(
                        Text(
                          valor.toStringAsFixed(1),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: esDescarga
                                ? Constantes.colorAdvertencia
                                : Constantes.colorPrimario,
                          ),
                        ),
                      ),
                      DataCell(
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (esDescarga)
                              Icon(
                                Icons.battery_charging_full,
                                size: 16,
                                color: Constantes.colorAdvertencia,
                              ),
                            SizedBox(width: 4),
                            Text(
                              esDescarga ? 'Descarga (-50%)' : 'Normal',
                              style: TextStyle(
                                color: esDescarga
                                    ? Constantes.colorAdvertencia
                                    : Constantes.textoSecundario,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                }),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
