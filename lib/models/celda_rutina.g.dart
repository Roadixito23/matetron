// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'celda_rutina.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CeldaRutinaAdapter extends TypeAdapter<CeldaRutina> {
  @override
  final int typeId = 1;

  @override
  CeldaRutina read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CeldaRutina(
      series: fields[0] as int,
      repeticiones: fields[1] as int,
    );
  }

  @override
  void write(BinaryWriter writer, CeldaRutina obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.series)
      ..writeByte(1)
      ..write(obj.repeticiones);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CeldaRutinaAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
