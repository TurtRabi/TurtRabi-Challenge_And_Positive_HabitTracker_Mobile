import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tracking_positive_mobile/core/network/dio_client.dart';
import 'package:tracking_positive_mobile/data/datasources/remote/redis_remote_datasource.dart';
import 'package:tracking_positive_mobile/data/repositories/redis_repository_impl.dart';
import 'package:tracking_positive_mobile/domain/repositories/redis_repository.dart';
import 'package:tracking_positive_mobile/domain/usecases/redis_cacher_usecase.dart';

import '../viewmodels/redis_viewmodel.dart';

final dioProvider = Provider<Dio>((ref) => DioClient.create());
final redisRemoteDatasourceProvider = Provider<RedisRemoteDatasource>((ref)=>RedisRemoteDatasource(ref.watch(dioProvider)));
final redisRepositoryProvider = Provider<RedisRepository>((ref)=>RedisRepositoryImpl(ref.watch(redisRemoteDatasourceProvider)));
final redisCacherUseCaseProvider = Provider<RedisCacherUseCase>((ref)=>RedisCacherUseCase(ref.watch(redisRepositoryProvider)));
final redisViewModelProvider = ChangeNotifierProvider<RedisViewModel>((ref)=>RedisViewModel(ref.watch(redisCacherUseCaseProvider)));