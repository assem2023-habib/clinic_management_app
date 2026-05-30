import 'package:clinic_management_app/data/datasources/data_source.dart';
import 'package:clinic_management_app/data/datasources/remote/dashboard_remote_datasource.dart';
import 'package:clinic_management_app/data/models/dashboard_model.dart';
import 'package:clinic_management_app/domain/entities/dashboard_data.dart';
import 'package:clinic_management_app/domain/repositories/dashboard_repository.dart';

class DashboardRepositoryImpl implements DashboardRepository {
  final DataSource? localDataSource;
  final DashboardRemoteDataSource? remoteDataSource;

  DashboardRepositoryImpl({this.localDataSource, this.remoteDataSource});

  @override
  Future<DashboardData> getDashboard() async {
    if (remoteDataSource != null) {
      final json = await remoteDataSource!.getDashboard();
      return DashboardModel.fromMap(json);
    }
    return localDataSource?.getDashboardData() ?? const DashboardData();
  }
}
