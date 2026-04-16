import 'dart:io';

import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

import '../../domain/entities/produto.dart';
import '../../domain/repositories/i_preference_repository.dart';

class PreferenceRepositoryImpl implements IPreferenceRepository {
  final Dio _dio;
  final Logger _logger;

  PreferenceRepositoryImpl({Dio? dio, Logger? logger})
      : _dio = dio ?? Dio(),
        _logger = logger ?? Logger(printer: PrettyPrinter(), output: ConsoleOutput());

  @override
  Future<String> createPreference(List<Produto> cartItems) async {
    final accessToken = Platform.isAndroid
        ? const String.fromEnvironment('MP_ACCESS_TOKEN_SELLER')
        : '';

    final host = Platform.isAndroid
        ? const String.fromEnvironment('MP_CREATE_PREFERENCE_HOST')
        : '';

    final url = '$host/create_preference';

    final response = await _dio.post(
      url,
      data: {
        'items': cartItems
            .map((p) => {
                  'title': p.nome,
                  'quantity': p.quantidade,
                  'unit_price': p.preco,
                  'currency_id': 'BRL',
                })
            .toList(),
        'payer': {'email': 'test_user@example.com'},
      },
      options: Options(
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      ),
    );

    if (response.statusCode == HttpStatus.ok) {
      final id = response.data['preference_id'] as String;
      _logger.d('Preference ID: $id');
      return id;
    }

    throw Exception('Failed to create preference: ${response.statusMessage}');
  }
}
