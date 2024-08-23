import 'package:dartz/dartz.dart';
import 'package:scan_o_matic/core/error/failures.dart';
import 'package:scan_o_matic/src/domain/entities/scan_entity.dart';

abstract class ScanRepoInterface {
  Future<Either<Failure, ScanEntity>> select(int id);
  Future<Either<Failure, List<ScanEntity>>> selectAll();
  Future<Either<Failure, void>> delete(int id);
  Future<Either<Failure, void>> insert(ScanEntity s);
  Future<Either<Failure, String>> takeScan();
}
