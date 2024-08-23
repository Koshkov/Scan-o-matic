import 'package:scan_o_matic/src/data/dtos/scan_dto.dart';
import 'package:scan_o_matic/src/domain/entities/scan_entity.dart';

class ScanMapper {
  ScanEntity toEntity(ScanDto dto) => ScanEntity(id: dto.id, value: dto.value);
  ScanDto fromEntity(ScanEntity entity) =>
      ScanDto(id: entity.id, value: entity.value);
}
