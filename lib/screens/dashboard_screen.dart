import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../providers/rutinas_provider.dart';
import '../providers/registros_provider.dart';
import '../providers/ejercicios_provider.dart';
import '../utils/constantes.dart';
import '../utils/matematicas.dart';

/// Pantalla del Módulo 4: Dashboard de Indicadores
///
/// Panel central con métricas clave de rendimiento y alertas
class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final rutinasProvider = Provider.of<RutinasProvider>(context);
    final registrosProvider = Provider.of<RegistrosProvider>(context);
    final ejerciciosProvider = Provider.of<EjerciciosProvider>(context);

    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildTituloSeccion('Métricas de Entrenamiento'),
          SizedBox(height: 16),
          _buildMetricasGrid(rutinasProvider, registrosProvider, ejerciciosProvider),
          SizedBox(height: 24),
          _buildTituloSeccion('Volumen por Día'),
          SizedBox(height: 16),
          _buildGraficoVolumenDiario(rutinasProvider),
          SizedBox(height: 24),
          _buildTituloSeccion('Progreso Reciente'),
          SizedBox(height: 16),
          _buildProgresoReciente(registrosProvider, ejerciciosProvider),
          SizedBox(height: 24),
          _buildAlertas(rutinasProvider, registrosProvider),
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

  /// Grid de métricas principales
  Widget _buildMetricasGrid(
    RutinasProvider rutinasProvider,
    RegistrosProvider registrosProvider,
    EjerciciosProvider ejerciciosProvider,
  ) {
    final volumenSemanal = rutinasProvider.volumenTotalSemanalActual;
    final volumenMensual = rutinasProvider.volumenMensualProyectado;
    final totalEjercicios = ejerciciosProvider.totalEjercicios;
    final totalRegistros = registrosProvider.totalRegistros;

    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.3,
      children: [
        _buildCardMetrica(
          'Volumen Semanal',
          '$volumenSemanal',
          'repeticiones',
          Icons.fitness_center,
          Constantes.colorPrimario,
        ),
        _buildCardMetrica(
          'Volumen Mensual',
          '$volumenMensual',
          'proyectado',
          Icons.calendar_today,
          Constantes.colorSecundario,
        ),
        _buildCardMetrica(
          'Ejercicios',
          '$totalEjercicios',
          'registrados',
          Icons.list,
          Constantes.colorExito,
        ),
        _buildCardMetrica(
          'Registros',
          '$totalRegistros',
          'de progreso',
          Icons.show_chart,
          Constantes.colorAdvertencia,
        ),
      ],
    );
  }

  /// Card de métrica individual
  Widget _buildCardMetrica(
    String titulo,
    String valor,
    String subtitulo,
    IconData icono,
    Color color,
  ) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icono,
              size: 32,
              color: color,
            ),
            SizedBox(height: 8),
            Text(
              valor,
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            SizedBox(height: 4),
            Text(
              titulo,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            Text(
              subtitulo,
              style: Constantes.estiloTextoSecundario.copyWith(fontSize: 11),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  /// Gráfico de volumen por día de la semana
  Widget _buildGraficoVolumenDiario(RutinasProvider rutinasProvider) {
    if (rutinasProvider.rutinaActual == null) {
      return _buildCardVacio('No hay rutina seleccionada');
    }

    final volumenesDiarios = rutinasProvider.volumenPorDiaActual;

    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            SizedBox(
              height: 200,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: volumenesDiarios.reduce((a, b) => a > b ? a : b).toDouble() * 1.2,
                  barTouchData: BarTouchData(enabled: true),
                  titlesData: FlTitlesData(
                    show: true,
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          if (value.toInt() >= 0 && value.toInt() < 7) {
                            return Padding(
                              padding: EdgeInsets.only(top: 8),
                              child: Text(
                                Constantes.diasSemana[value.toInt()],
                                style: TextStyle(fontSize: 11),
                              ),
                            );
                          }
                          return Text('');
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
                  gridData: FlGridData(show: true),
                  borderData: FlBorderData(show: false),
                  barGroups: List.generate(7, (i) {
                    return BarChartGroupData(
                      x: i,
                      barRods: [
                        BarChartRodData(
                          toY: volumenesDiarios[i].toDouble(),
                          color: Constantes.colorPrimario,
                          width: 20,
                          borderRadius: BorderRadius.vertical(top: Radius.circular(4)),
                        ),
                      ],
                    );
                  }),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Progreso reciente de ejercicios
  Widget _buildProgresoReciente(
    RegistrosProvider registrosProvider,
    EjerciciosProvider ejerciciosProvider,
  ) {
    final ejerciciosConRegistros = registrosProvider.ejerciciosConRegistros;

    if (ejerciciosConRegistros.isEmpty) {
      return _buildCardVacio('No hay registros de progreso');
    }

    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ...ejerciciosConRegistros.take(5).map((ejercicioId) {
              final ejercicio = ejerciciosProvider.obtenerEjercicio(ejercicioId);
              final ultimoRegistro = registrosProvider.obtenerUltimoRegistro(ejercicioId);
              final tasaMejora = registrosProvider.calcularTasaMejoraPromedio(ejercicioId);

              if (ejercicio == null || ultimoRegistro == null) {
                return Container();
              }

              Color colorTasa = tasaMejora > 0
                  ? Constantes.colorExito
                  : tasaMejora < 0
                      ? Constantes.colorPeligro
                      : Constantes.textoSecundario;

              return Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            ejercicio.nombre,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Último: ${ultimoRegistro.rendimiento} ${ultimoRegistro.unidad}',
                            style: Constantes.estiloTextoSecundario,
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              tasaMejora > 0
                                  ? Icons.trending_up
                                  : tasaMejora < 0
                                      ? Icons.trending_down
                                      : Icons.trending_flat,
                              color: colorTasa,
                              size: 20,
                            ),
                            SizedBox(width: 4),
                            Text(
                              '${tasaMejora.toStringAsFixed(1)}%',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: colorTasa,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          'semanal',
                          style: Constantes.estiloTextoSecundario.copyWith(fontSize: 11),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  /// Alertas y recomendaciones
  Widget _buildAlertas(
    RutinasProvider rutinasProvider,
    RegistrosProvider registrosProvider,
  ) {
    List<Widget> alertas = [];

    // Alerta si no hay rutina
    if (rutinasProvider.rutinaActual == null) {
      alertas.add(_buildCardAlerta(
        'Sin rutina activa',
        'Crea o selecciona una rutina en la sección de Matriz de Rutinas',
        Constantes.colorAdvertencia,
        Icons.warning,
      ));
    }

    // Alerta de volumen bajo
    final volumenSemanal = rutinasProvider.volumenTotalSemanalActual;
    if (volumenSemanal < 100 && volumenSemanal > 0) {
      alertas.add(_buildCardAlerta(
        'Volumen bajo',
        'Tu volumen semanal es bajo. Considera agregar más ejercicios o series',
        Constantes.colorAdvertencia,
        Icons.fitness_center,
      ));
    }

    // Alerta de volumen muy alto
    if (volumenSemanal > 1000) {
      alertas.add(_buildCardAlerta(
        'Volumen elevado',
        'Tu volumen semanal es muy alto. Monitorea tu recuperación',
        Constantes.colorPeligro,
        Icons.warning_amber,
      ));
    }

    // Mensaje positivo si no hay alertas
    if (alertas.isEmpty) {
      alertas.add(_buildCardAlerta(
        'Todo en orden',
        'Tu entrenamiento está bien balanceado. ¡Sigue así!',
        Constantes.colorExito,
        Icons.check_circle,
      ));
    }

    // Recomendación de descarga
    alertas.add(_buildCardAlerta(
      'Próxima descarga',
      'Recuerda hacer una semana de descarga cada ${Constantes.frecuenciaDescarga} semanas (-40-50% volumen)',
      Constantes.colorSecundario,
      Icons.battery_charging_full,
    ));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildTituloSeccion('Alertas y Recomendaciones'),
        SizedBox(height: 16),
        ...alertas,
      ],
    );
  }

  /// Card de alerta
  Widget _buildCardAlerta(String titulo, String mensaje, Color color, IconData icono) {
    return Card(
      color: color.withOpacity(0.1),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              icono,
              color: color,
              size: 32,
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    titulo,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: color,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    mensaje,
                    style: TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Card vacío con mensaje
  Widget _buildCardVacio(String mensaje) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(32),
        child: Center(
          child: Text(
            mensaje,
            style: Constantes.estiloTextoSecundario,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
