// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rutina_matriz.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RutinaMatrizAdapter extends TypeAdapter<RutinaMatriz> {
  @override
  final int typeId = 2;

  @override
  RutinaMatriz read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RutinaMatriz(
      id: fields[0] as String,
      nombre: fields[1] as String,
      ejercicioIds: (fields[2] as List).cast<String>(),
      matriz: (fields[3] as List)
          .map((dynamic e) => (e as List).cast<CeldaRutina>())
          .toList(),
      createdAt: fields[4] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, RutinaMatriz obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.nombre)
      ..writeByte(2)
      ..write(obj.ejercicioIds)
      ..writeByte(3)
      ..write(obj.matriz)
      ..writeByte(4)
      ..write(obj.createdAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RutinaMatrizAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
