import 'package:equatable/equatable.dart';

class CompanyEntity extends Equatable {
  final String companyId;
  final String companyName;
  final DateTime createdAt;

  const CompanyEntity({
    required this.companyId,
    required this.companyName,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [companyId, companyName, createdAt];
}
