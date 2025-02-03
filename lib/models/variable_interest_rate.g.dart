// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'variable_interest_rate.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class VariableInterestRateAdapter extends TypeAdapter<VariableInterestRate> {
  @override
  final int typeId = 1;

  @override
  VariableInterestRate read(BinaryReader reader) {
    // final numOfFields = reader.readByte();
    // final fields = <int, dynamic>{
    //   for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    // };
    return VariableInterestRate(
      months: reader.read() as int,
      interestRate: reader.read() as double,
      // months: fields[0] as int,
      // interestRate: fields[1] as double,
    );
  }

  @override
  void write(BinaryWriter writer, VariableInterestRate obj) {
    writer
      // ..writeByte(2)
      // ..writeByte(0)
      ..writeInt(obj.months)
      // ..writeByte(1)
      ..writeDouble(obj.interestRate);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VariableInterestRateAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
