# Flutter Kiosk App — MVVM + MobX + Firebase

Aplicativo Flutter originalmente desenvolvido para rodar em **totens de autoatendimento**, com fluxo completo de vitrine de produtos, carrinho e checkout via Mercado Pago. O projeto não foi a frente como produto, mas está sendo mantido como **portfólio técnico** por demonstrar uma stack sólida e padrões de arquitetura aplicados em um contexto real.

---

## Contexto

A ideia inicial era um totem físico onde o cliente visualizava um vídeo promocional em loop, navegava pelo catálogo de produtos e finalizava a compra pelo Mercado Pago — tudo sem intervenção de atendente. A tela inicial reflete isso: um player de vídeo nativo em fullscreen com botões sobrepostos para acessar o catálogo ou os posts.

---

## Arquitetura

O projeto segue **Clean Architecture** com separação em três camadas:

```
lib/
├── features/
│   ├── data/          # Implementações dos repositórios (Firebase, API)
│   ├── domain/        # Entidades e interfaces dos repositórios
│   └── presentation/  # Stores (MobX) e Pages (UI)
```

- **MVVM:** UI (View) desacoplada da lógica de negócio (ViewModel/Store)
- **MobX:** estado reativo com `@observable`, `@action` e `@computed`
- **Provider:** injeção de dependência e distribuição das stores pela árvore de widgets
- **Interfaces no domínio:** `IPostRepository`, `IProdutoRepository`, `IPreferenceRepository` — facilitam mock e testabilidade

---

## Funcionalidades

- **Player de vídeo nativo** em fullscreen como tela inicial (totem-style), com package local `native_video_view` adaptado para remover embedding v1 e corrigir `LifecycleOwner` para AndroidX
- **Catálogo de produtos** carregado do Firestore com estados de loading/erro via MobX
- **Carrinho de compras** reativo com cálculo de total via `@computed`
- **Checkout com Mercado Pago** — cria preferência de pagamento via backend e abre o fluxo em Custom Tabs
- **Deep links** (`app_links`) para capturar retorno do Mercado Pago (`/success`, `/pending`, `/failure`)
- **Posts** consumidos de API REST com controle de estado (LOADING / SUCCESS / ERROR)
- **Firebase Crashlytics** para monitoramento de erros em produção
- **Firebase Storage** para assets remotos

---

## Tech Stack

| Categoria         | Tecnologia                              |
|-------------------|-----------------------------------------|
| Linguagem         | Dart                                    |
| Framework         | Flutter                                 |
| Arquitetura       | MVVM + Clean Architecture               |
| State Management  | MobX + Flutter MobX                     |
| DI                | Provider                                |
| Backend / DB      | Firebase Firestore + Storage            |
| Monitoramento     | Firebase Crashlytics                    |
| Pagamentos        | Mercado Pago (via backend de preferência) |
| Networking        | Dio                                     |
| Deep Links        | app_links                               |
| Player de Vídeo   | native_video_view (package local)       |
| Testes            | flutter_test + mockito                  |
| CI/CD             | GitHub Actions → Google Play (internal track) |

---

## Testes

O projeto conta com testes unitários das stores, cobrindo lógica de negócio isolada da UI:

```
test/
└── stores/
    ├── cart_store_test.dart          # 8 testes — lógica do carrinho e totalPrice
    ├── post_view_model_test.dart     # 6 testes — fluxo de estados com mock do repositório
    └── produto_store_test.dart       # 5 testes — fetch de produtos e tratamento de erro
```

Para rodar:
```bash
flutter test
```

---

## CI/CD

O workflow em `.github/workflows/distribute.yml` é disparado a cada push na `master` e executa:

1. Geração de `google-services.json` a partir de secret (Base64)
2. Decodificação do keystore de assinatura
3. `flutter analyze` no código
4. Build do `.aab` release com credenciais via `--dart-define`
5. Assinatura com `jarsigner`
6. Upload do artefato e publicação na **internal track** do Google Play

---

## Configuração local

1. **Dependências:**
   ```bash
   flutter pub get
   ```

2. **Código gerado (MobX + mocks):**
   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```

3. **Firebase:** obtenha os arquivos do console Firebase e coloque-os nos caminhos esperados:
   - `android/app/google-services.json`
   - `ios/Runner/GoogleService-Info.plist`

4. **Variáveis de ambiente (`--dart-define`):** o app espera as variáveis listadas em `.cursor/rules/flutter-run-params.mdc.example`. Copie o arquivo, preencha com os valores do seu ambiente e **não commite** o arquivo final se contiver chaves reais.

5. **Rodar:**
   ```bash
   flutter run \
     --dart-define=FIREBASE_API_KEY=... \
     --dart-define=FIREBASE_APP_ID=... \
     --dart-define=MP_CREATE_PREFERENCE_HOST=http://seu-backend/...
   ```
