import 'package:dartz/dartz.dart';
import 'package:scan_o_matic/core/error/exceptions.dart';
import 'package:scan_o_matic/src/application/scan_mapper.dart';
import 'package:scan_o_matic/src/data/datasrc/scan_local.dart';
import 'package:scan_o_matic/src/domain/repos/scan_repo_interface.dart';
import 'package:scan_o_matic/core/error/failures.dart';
import 'package:scan_o_matic/src/domain/entities/scan_entity.dart';

class ScanRepo implements ScanRepoInterface {
  final _localSource = ScanLocal();
  final _mapper = ScanMapper();

  @override
  Future<Either<DatabaseFailure, ScanEntity>> select(int id) async {
    try {
      final res = await _localSource.select(id);
      return Right(_mapper.toEntity(res));
    } on DatabaseExcpetion {
      return Left(DatabaseFailure(message: "Could not read database"));
    }
  }

  @override
  Future<Either<DatabaseFailure, List<ScanEntity>>> selectAll() async {
    try {
      final res = await _localSource.selectAll();
      return Right(res.map((s) => _mapper.toEntity(s)).toList());
    } on DatabaseExcpetion {
      return Left(DatabaseFailure(message: "Could not read database."));
    }
  }

  @override
  Future<Either<DatabaseFailure, void>> delete(int id) async {
    try {
      await _localSource.delete(id);
      return const Right(null);
    } on DatabaseExcpetion {
      return Left(DatabaseFailure(message: "Could not delete."));
    }
  }

  @override
  Future<Either<DatabaseFailure, void>> insert(ScanEntity s) async {
    try {
      await _localSource.insert(_mapper.fromEntity(s));
      return const Right(null);
    } on DatabaseExcpetion {
      return Left(DatabaseFailure(message: "Could not insert."));
    }
  }

  @override
  Future<Either<DatabaseFailure, String>> takeScan() async {
    try {
      final res = await _localSource.takeScan();
      return Right(res);
    } on DatabaseExcpetion {
      return Left(DatabaseFailure(message: "Failed to take scan"));
    }
  }
}
