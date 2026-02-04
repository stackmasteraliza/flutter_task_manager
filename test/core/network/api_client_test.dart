import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:task_manager_app/core/errors/app_exception.dart';
import 'package:task_manager_app/core/network/api_client.dart';

class _MockDio extends Mock implements Dio {}

void main() {
  late Dio dio;
  late ApiClient apiClient;

  setUp(() {
    dio = _MockDio();
    apiClient = ApiClient(dio);
  });

  test('returns parsed map for successful get', () async {
    when(
      () => dio.get<Map<String, dynamic>>(
        any(),
        queryParameters: any(named: 'queryParameters'),
        options: any(named: 'options'),
      ),
    ).thenAnswer(
      (_) async => Response<Map<String, dynamic>>(
        requestOptions: RequestOptions(path: '/todos'),
        data: <String, dynamic>{'total': 1},
      ),
    );

    final result = await apiClient.get('/todos');

    expect(result['total'], 1);
  });

  test('throws AppException with API message on DioException', () async {
    when(
      () => dio.get<Map<String, dynamic>>(
        any(),
        queryParameters: any(named: 'queryParameters'),
        options: any(named: 'options'),
      ),
    ).thenThrow(
      DioException(
        requestOptions: RequestOptions(path: '/todos'),
        response: Response<Map<String, dynamic>>(
          requestOptions: RequestOptions(path: '/todos'),
          data: <String, dynamic>{'message': 'Bad request'},
        ),
      ),
    );

    expect(() => apiClient.get('/todos'), throwsA(isA<AppException>()));
  });
}
