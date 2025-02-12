import 'dart:io';

import 'package:dio/dio.dart';
import 'package:mobx/mobx.dart';
import 'package:logger/logger.dart';
import '../model/produto.dart';

part 'preference_view_model.g.dart';

class PreferenceViewModel = _PreferenceViewModelBase with _$PreferenceViewModel;

abstract class _PreferenceViewModelBase with Store {
  @observable
  bool isLoading = false;

  @observable
  String? preferenceId;

  @observable
  String? errorMessage;

  @action
  Future<void> createPreference(List<Produto> cartItems) async {
    isLoading = true;
    errorMessage = null;

    String accessToken = Platform.isAndroid
        ? const String.fromEnvironment('MP_ACCESS_TOKEN_SELLER') ?? ''
        : '';

    String mpCreatePreferenceHost = Platform.isAndroid
        ? const String.fromEnvironment('MP_CREATE_PREFERENCE_HOST') ?? ''
        : '';

    String url =
        '$mpCreatePreferenceHost/create_preference';

    final dio = Dio();

    final logger = Logger(
      printer: PrettyPrinter(),
      output: ConsoleOutput(), // Ensure logs are sent to the console
    );

    try {
      final response = await dio.post(
        url,
        data: {
          "items": cartItems.map((product) => {
            "title": product.nome,
            "quantity": product.quantidade,
            "unit_price": product.preco,
            "currency_id": "BRL", // or your preferred currency
          }).toList(),
          "payer": {
            "email": "test_user@example.com", // Replace with user's payer email
          },
          // Add other preference details like back_urls, etc. if needed
        },
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $accessToken',
          },
        ),
      );

      if (response.statusCode == HttpStatus.ok) {
        preferenceId = response.data['preference_id'];
        logger.d("Preference ID: $preferenceId");
      } else {
        logger.e("Failed to create preference: ${response.statusMessage}");
        errorMessage = 'Failed to create preference: ${response.statusMessage}';
      }
    } catch (e) {
      logger.e("Error creating preference: $e");
      errorMessage = 'Error creating preference: $e';
    } finally {
      isLoading = false;
    }
  }
}