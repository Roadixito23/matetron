// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'registro_progreso.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RegistroProgresoAdapter extends TypeAdapter<RegistroProgreso> {
  @override
  final int typeId = 3;

  @override
  RegistroProgreso read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RegistroProgreso(
      id: fields[0] as String,
      ejercicioId: fields[1] as String,
      fecha: fields[2] as DateTime,
      rendimiento: fields[3] as double,
      unidad: fields[4] as String,
      notas: fields[5] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, RegistroProgreso obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.ejercicioId)
      ..writeByte(2)
      ..write(obj.fecha)
      ..writeByte(3)
      ..write(obj.rendimiento)
      ..writeByte(4)
      ..write(obj.unidad)
      ..writeByte(5)
      ..write(obj.notas);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RegistroProgresoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
