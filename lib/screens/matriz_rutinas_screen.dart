import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../models/rutina_matriz.dart';
import '../models/celda_rutina.dart';
import '../models/ejercicio.dart';
import '../providers/rutinas_provider.dart';
import '../providers/ejercicios_provider.dart';
import '../utils/constantes.dart';

/// Pantalla del Módulo 1: Matriz de Rutinas
///
/// Permite organizar ejercicios × días en formato matricial R(n×7)
/// donde n = número de ejercicios (3-10) y 7 = días de la semana
class MatrizRutinasScreen extends StatefulWidget {
  const MatrizRutinasScreen({super.key});

  @override
  State<MatrizRutinasScreen> createState() => _MatrizRutinasScreenState();
}

class _MatrizRutinasScreenState extends State<MatrizRutinasScreen> {
  RutinaMatriz? _rutinaActual;
  List<Ejercicio> _todosEjercicios = [];
  final _nombreController = TextEditingController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _cargarDatos();
  }

  void _cargarDatos() {
    final rutinasProvider = Provider.of<RutinasProvider>(context, listen: false);
    final ejerciciosProvider = Provider.of<EjerciciosProvider>(context, listen: false);

    _todosEjercicios = ejerciciosProvider.ejercicios;

    if (rutinasProvider.rutinaActual != null) {
      _rutinaActual = rutinasProvider.rutinaActual;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _rutinaActual == null
          ? _buildPantallaVacia()
          : _buildMatrizRutina(),
      floatingActionButton: FloatingActionButton(
        onPressed: _mostrarDialogoNuevaRutina,
        child: Icon(Icons.add),
        tooltip: 'Nueva Rutina',
      ),
    );
  }

  /// Pantalla cuando no hay rutina seleccionada
  Widget _buildPantallaVacia() {
    final rutinasProvider = Provider.of<RutinasProvider>(context);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.fitness_center,
            size: 100,
            color: Constantes.colorPrimario.withOpacity(0.5),
          ),
          SizedBox(height: 24),
          Text(
            'No hay rutinas creadas',
            style: Constantes.estiloTituloMediano,
          ),
          SizedBox(height: 12),
          Text(
            'Toca el botón + para crear tu primera rutina',
            style: Constantes.estiloTextoSecundario,
          ),
          if (rutinasProvider.rutinas.isNotEmpty) ...[
            SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => _seleccionarRutina(context),
              icon: Icon(Icons.list),
              label: Text('Ver Rutinas Guardadas'),
            ),
          ],
        ],
      ),
    );
  }

  /// Vista principal de la matriz de rutina
  Widget _buildMatrizRutina() {
    if (_rutinaActual == null) return Container();

    return Column(
      children: [
        _buildEncabezado(),
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: _buildTablaMatriz(),
            ),
          ),
        ),
        _buildResumenVolumen(),
      ],
    );
  }

  /// Encabezado con nombre de rutina y opciones
  Widget _buildEncabezado() {
    return Container(
      padding: EdgeInsets.all(16),
      color: Color(0xFF1E1E1E),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _rutinaActual!.nombre,
                      style: Constantes.estiloTituloMediano,
                    ),
                    SizedBox(height: 4),
                    Text(
                      '${_rutinaActual!.ejercicioIds.length} ejercicios',
                      style: Constantes.estiloTextoSecundario,
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () => _seleccionarRutina(context),
                icon: Icon(Icons.list),
                tooltip: 'Cambiar rutina',
              ),
              IconButton(
                onPressed: _agregarEjercicio,
                icon: Icon(Icons.add_circle),
                tooltip: 'Agregar ejercicio',
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Construye la tabla de la matriz
  Widget _buildTablaMatriz() {
    if (_rutinaActual == null) return Container();

    return DataTable(
      columnSpacing: 12,
      horizontalMargin: 8,
      columns: [
        DataColumn(label: Text('Ejercicio', style: TextStyle(fontWeight: FontWeight.bold))),
        ...Constantes.diasSemana.map((dia) => DataColumn(
          label: Text(dia, style: TextStyle(fontWeight: FontWeight.bold)),
        )),
        DataColumn(label: Text('Total', style: TextStyle(fontWeight: FontWeight.bold))),
      ],
      rows: List.generate(_rutinaActual!.matriz.length, (i) {
        final ejercicioId = _rutinaActual!.ejercicioIds[i];
        final ejercicio = _todosEjercicios.firstWhere(
          (e) => e.id == ejercicioId,
          orElse: () => Ejercicio(id: ejercicioId, nombre: 'Desconocido'),
        );

        int volumenTotal = 0;
        for (var celda in _rutinaActual!.matriz[i]) {
          volumenTotal += celda.volumen;
        }

        return DataRow(
          cells: [
            DataCell(
              Container(
                width: 100,
                child: Text(
                  ejercicio.nombre,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              onLongPress: () => _eliminarEjercicio(i),
            ),
            ...List.generate(7, (j) {
              final celda = _rutinaActual!.matriz[i][j];
              return DataCell(
                _buildCeldaVolumen(celda),
                onTap: () => _editarCelda(i, j),
              );
            }),
            DataCell(
              Text(
                '$volumenTotal',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Constantes.colorPrimario,
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  /// Widget para mostrar una celda de volumen
  Widget _buildCeldaVolumen(CeldaRutina celda) {
    if (celda.estaVacia) {
      return Center(
        child: Text(
          '-',
          style: TextStyle(color: Constantes.textoSecundario),
        ),
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '${celda.series}×${celda.repeticiones}',
          style: TextStyle(fontSize: 12),
        ),
        Text(
          '${celda.volumen}',
          style: TextStyle(
            fontSize: 10,
            color: Constantes.colorSecundario,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  /// Resumen de volumen total semanal
  Widget _buildResumenVolumen() {
    if (_rutinaActual == null) return Container();

    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFF1E1E1E),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 4,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Volumen Semanal',
                style: Constantes.estiloTextoSecundario,
              ),
              SizedBox(height: 4),
              Text(
                '${_rutinaActual!.volumenTotalSemanal}',
                style: Constantes.estiloNumeroGrande,
              ),
            ],
          ),
          ElevatedButton.icon(
            onPressed: _guardarRutina,
            icon: Icon(Icons.save),
            label: Text('Guardar'),
          ),
        ],
      ),
    );
  }

  /// Muestra diálogo para crear nueva rutina
  void _mostrarDialogoNuevaRutina() {
    _nombreController.clear();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Nueva Rutina'),
        content: TextField(
          controller: _nombreController,
          decoration: InputDecoration(
            labelText: 'Nombre de la rutina',
            hintText: 'ej: Rutina Fuerza',
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              if (_nombreController.text.isNotEmpty) {
                _crearNuevaRutina(_nombreController.text);
                Navigator.pop(context);
              }
            },
            child: Text('Crear'),
          ),
        ],
      ),
    );
  }

  /// Crea una nueva rutina vacía
  void _crearNuevaRutina(String nombre) {
    final rutina = RutinaMatriz.vacia(
      id: Uuid().v4(),
      nombre: nombre,
      numeroEjercicios: 3,
    );

    // Asignar ejercicios de ejemplo si existen
    if (_todosEjercicios.length >= 3) {
      for (int i = 0; i < 3 && i < _todosEjercicios.length; i++) {
        rutina.ejercicioIds.add(_todosEjercicios[i].id);
      }
    }

    setState(() {
      _rutinaActual = rutina;
    });

    _guardarRutina();
  }

  /// Agrega un nuevo ejercicio a la rutina
  void _agregarEjercicio() {
    if (_rutinaActual == null) return;

    if (_rutinaActual!.matriz.length >= Constantes.maxEjercicios) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Máximo ${Constantes.maxEjercicios} ejercicios')),
      );
      return;
    }

    // Mostrar lista de ejercicios disponibles
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Seleccionar Ejercicio'),
        content: Container(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: _todosEjercicios.length,
            itemBuilder: (context, index) {
              final ejercicio = _todosEjercicios[index];
              final yaAgregado = _rutinaActual!.ejercicioIds.contains(ejercicio.id);

              return ListTile(
                title: Text(ejercicio.nombre),
                enabled: !yaAgregado,
                trailing: yaAgregado
                    ? Icon(Icons.check, color: Constantes.colorExito)
                    : null,
                onTap: yaAgregado
                    ? null
                    : () {
                        setState(() {
                          _rutinaActual!.agregarEjercicio(ejercicio.id);
                        });
                        Navigator.pop(context);
                        _guardarRutina();
                      },
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cerrar'),
          ),
        ],
      ),
    );
  }

  /// Elimina un ejercicio de la rutina
  void _eliminarEjercicio(int index) {
    if (_rutinaActual == null) return;

    if (_rutinaActual!.matriz.length <= Constantes.minEjercicios) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Mínimo ${Constantes.minEjercicios} ejercicios')),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Eliminar Ejercicio'),
        content: Text('¿Seguro que deseas eliminar este ejercicio?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _rutinaActual!.eliminarEjercicio(index);
              });
              Navigator.pop(context);
              _guardarRutina();
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

  /// Edita una celda de la matriz
  void _editarCelda(int ejercicioIndex, int diaIndex) {
    if (_rutinaActual == null) return;

    final celda = _rutinaActual!.matriz[ejercicioIndex][diaIndex];
    final seriesController = TextEditingController(
      text: celda.series > 0 ? celda.series.toString() : '',
    );
    final repsController = TextEditingController(
      text: celda.repeticiones > 0 ? celda.repeticiones.toString() : '',
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Editar ${Constantes.diasSemanaCompletos[diaIndex]}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: seriesController,
              decoration: InputDecoration(labelText: 'Series'),
              keyboardType: TextInputType.number,
              autofocus: true,
            ),
            SizedBox(height: 12),
            TextField(
              controller: repsController,
              decoration: InputDecoration(labelText: 'Repeticiones'),
              keyboardType: TextInputType.number,
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
              int series = int.tryParse(seriesController.text) ?? 0;
              int reps = int.tryParse(repsController.text) ?? 0;

              setState(() {
                _rutinaActual!.actualizarCelda(
                  ejercicioIndex,
                  diaIndex,
                  CeldaRutina(series: series, repeticiones: reps),
                );
              });

              Navigator.pop(context);
              _guardarRutina();
            },
            child: Text('Guardar'),
          ),
        ],
      ),
    );
  }

  /// Guarda la rutina actual
  void _guardarRutina() {
    if (_rutinaActual == null) return;

    final rutinasProvider = Provider.of<RutinasProvider>(context, listen: false);
    rutinasProvider.actualizarRutina(_rutinaActual!);
    rutinasProvider.setRutinaActual(_rutinaActual);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Rutina guardada')),
    );
  }

  /// Muestra diálogo para seleccionar una rutina existente
  void _seleccionarRutina(BuildContext context) {
    final rutinasProvider = Provider.of<RutinasProvider>(context, listen: false);

    if (rutinasProvider.rutinas.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No hay rutinas guardadas')),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Seleccionar Rutina'),
        content: Container(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: rutinasProvider.rutinas.length,
            itemBuilder: (context, index) {
              final rutina = rutinasProvider.rutinas[index];
              return ListTile(
                title: Text(rutina.nombre),
                subtitle: Text(
                  '${rutina.ejercicioIds.length} ejercicios • Volumen: ${rutina.volumenTotalSemanal}',
                ),
                onTap: () {
                  setState(() {
                    _rutinaActual = rutina;
                  });
                  rutinasProvider.setRutinaActual(rutina);
                  Navigator.pop(context);
                },
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cerrar'),
          ),
        ],
      ),
    );
  }
}
