# flutter_mvvm_mobx_github

Flutter project with MobX in MVVM

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Configuração local (após clonar)

1. **Dependências:** `flutter pub get`
2. **Código gerado (MobX):** `dart run build_runner build --delete-conflicting-outputs`
3. **Firebase:** obtenha os arquivos do console Firebase e coloque-os onde o projeto espera (ex.: `android/app/google-services.json`). Os caminhos sensíveis costumam estar no `.gitignore` — não versionar.
4. **`dart-define`:** o app espera variáveis de ambiente em tempo de compilação (Firebase + Mercado Pago + URL do backend de preferências). Use os **mesmos nomes** listados em `.cursor/rules/flutter-run-params.mdc.example` e preencha com os valores do seu ambiente.
5. **Cursor (opcional):** copie `.cursor/rules/flutter-run-params.mdc.example` para `.cursor/rules/flutter-run-params.mdc`, substitua os placeholders e **não commite** esse arquivo se contiver tokens ou chaves reais.

**Rodar (exemplo):** acrescente ao `flutter run` / `flutter build` os parâmetros `--dart-define=...` conforme o template; ajuste `MP_CREATE_PREFERENCE_HOST` para a URL do seu backend em rede local ou homologação.
