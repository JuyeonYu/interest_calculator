// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'calculator_input.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CalculatorInputAdapter extends TypeAdapter<CalculatorInput> {
  @override
  final int typeId = 0;

  @override
  CalculatorInput read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CalculatorInput(
      principal: fields[0] as double,
      interestRate: fields[1] as double,
      term: fields[2] as int,
      delayTerm: fields[4] as int?,
      variableInterestRates: (fields[5] as List?)?.cast<VariableInterestRate>(),
      repaymentType: fields[3] as int,
      description: fields[6] as String,
    );
  }

  @override
  void write(BinaryWriter writer, CalculatorInput obj) {
    writer
      ..writeByte(8)
      ..writeByte(7)
      ..write(obj.id)
      ..writeByte(0)
      ..write(obj.principal)
      ..writeByte(1)
      ..write(obj.interestRate)
      ..writeByte(2)
      ..write(obj.term)
      ..writeByte(3)
      ..write(obj.repaymentType)
      ..writeByte(4)
      ..write(obj.delayTerm)
      ..writeByte(5)
      ..write(obj.variableInterestRates)
      ..writeByte(6)
      ..write(obj.description);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CalculatorInputAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
