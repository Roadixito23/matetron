// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'proyeccion_lineal.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ProyeccionLinealAdapter extends TypeAdapter<ProyeccionLineal> {
  @override
  final int typeId = 4;

  @override
  ProyeccionLineal read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ProyeccionLineal(
      p0: fields[0] as double,
      r: fields[1] as double,
      pf: fields[2] as double,
      semanas: fields[3] as int,
      nivelDeportista: fields[4] as String,
      proyeccion: (fields[5] as List).cast<double>(),
      semanasDescarga: (fields[6] as List).cast<int>(),
    );
  }

  @override
  void write(BinaryWriter writer, ProyeccionLineal obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.p0)
      ..writeByte(1)
      ..write(obj.r)
      ..writeByte(2)
      ..write(obj.pf)
      ..writeByte(3)
      ..write(obj.semanas)
      ..writeByte(4)
      ..write(obj.nivelDeportista)
      ..writeByte(5)
      ..write(obj.proyeccion)
      ..writeByte(6)
      ..write(obj.semanasDescarga);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProyeccionLinealAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
