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
    return CalculatorInput(
      principal: reader.readDouble(),
      interestRate: reader.readDouble(),
      term: reader.readInt(),
      delayTerm: reader.read(),
      variableInterest: reader.readDouble(),
      variableMonth: reader.readInt(),
      repaymentType: reader.readInt(),
      description: reader.readString(),
    );
  }

  @override
  void write(BinaryWriter writer, CalculatorInput obj) {
    writer
      ..writeDouble(obj.principal)
      ..writeDouble(obj.interestRate)
      ..writeInt(obj.term)
      ..write(obj.delayTerm)
      ..write(obj.variableInterest)
      ..write(obj.variableMonth)
      ..writeInt(obj.repaymentType)
      ..writeString(obj.description);
  }
}
