import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tracking_positive_mobile/core/network/dio_client.dart';

import '../../data/datasources/remote/auth_remote_datasource.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/social_login_usecase.dart';
import '../viewmodels/auth_viewmodel.dart';


final dioProvider = Provider<Dio>((ref) => DioClient.create());
final authRemoteDatasourceProvider = Provider<AuthRemoteDatasource>((ref) => AuthRemoteDatasource(ref.watch(dioProvider)));
final authRepositoryProvider = Provider<AuthRepository>((ref) => AuthRepositoryImpl(ref.watch(authRemoteDatasourceProvider)));
final socialLoginUseCaseProvider = Provider<SocialLoginUseCase>((ref) => SocialLoginUseCase(ref.watch(authRepositoryProvider)));
final authViewModelProvider = ChangeNotifierProvider<AuthViewModel>((ref) => AuthViewModel(ref.watch(socialLoginUseCaseProvider)));