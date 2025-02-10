import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import '../view-model/cart_store.dart';
import '../view-model/preference_view_model.dart';
import 'package:app_links/app_links.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({Key? key}) : super(key: key);

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();

}

class _CheckoutPageState extends State<CheckoutPage> {
  final PreferenceViewModel _preferenceViewModel = PreferenceViewModel();
  late AppLinks _appLinks;
  StreamSubscription<Uri>? _sub;

  @override
  void initState() {
    super.initState();
    _handleIncomingLinks();
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cartStore = Provider.of<CartStore>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
      ),
      body: Observer(builder: (_) {
        return Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: cartStore.cartItems.length,
                itemBuilder: (context, index) {
                  final item = cartStore.cartItems[index];
                  return ListTile(
                    title: Text(item.nome ?? ''),
                    subtitle: Text('R\$ ${item.preco?.toStringAsFixed(2) ?? ''}'),
                    trailing: IconButton(
                      icon: const Icon(Icons.remove_shopping_cart),
                      onPressed: () {
                        cartStore.removeFromCart(item);
                      },
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Text(
                    'Total: R\$ ${cartStore.totalPrice.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      _preferenceViewModel.createPreference(cartStore.cartItems);
                    },
                    child: const Text('Proceed to Payment'),
                  ),
                  Observer(builder: (_) {
                    if (_preferenceViewModel.isLoading) {
                      return const CircularProgressIndicator();
                    } else if (_preferenceViewModel.errorMessage != null) {
                      return Text(
                        'Error: ${_preferenceViewModel.errorMessage}',
                        style: const TextStyle(color: Colors.red),
                      );
                    } else if (_preferenceViewModel.preferenceId != null) {
                      // Construa a URL do checkout
                      String checkoutUrl =
                          'https://www.mercadopago.com.br/checkout/v1/redirect?pref_id=${_preferenceViewModel.preferenceId}';
                      // Start Mercado Pago checkout with _preferenceViewModel.preferenceId
                      _launchURL(context, checkoutUrl);
                      return Text(
                        'Preference created: ${_preferenceViewModel.preferenceId}',
                        style: const TextStyle(color: Colors.green),
                      );
                    } else {
                      return const SizedBox.shrink(); // Or any other default widget
                    }
                  }),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }

  Future<void> _handleIncomingLinks() async {
    _appLinks = AppLinks();

    // final logger = Logger();
    final logger = Logger(
      printer: PrettyPrinter(),
      output: ConsoleOutput(), // Ensure logs are sent to the console
    );

    // ... lógica para tratar os links recebidos
    _sub = _appLinks.uriLinkStream.listen((Uri? uri) {
      if (uri != null) {
        debugPrint('onAppLink: $uri');
        if (uri.path == '/success') {
          // Redirecionar para a tela de sucesso
          Navigator.pushNamed(context, '/success', arguments: uri.queryParameters);
        } else if (uri.path == '/pending') {
          // Redirecionar para a tela de pendente
          Navigator.pushNamed(context, '/pending', arguments: uri.queryParameters);
        } else if (uri.path == '/failure') {
          // Redirecionar para a tela de falha
          Navigator.pushNamed(context, '/failure', arguments: uri.queryParameters);
        }
      }
    }, onError: (err) {
      // Handle exception
      logger.e("Error message: $err"); // Error
      debugPrint('error: ${err.toString()}');
    });
  }

  void _launchURL(BuildContext context, String url) async {
    try {
      await launch(
        url,
        customTabsOption: CustomTabsOption(
          toolbarColor: Theme.of(context).primaryColor,
          enableDefaultShare: true,
          enableUrlBarHiding: true,
          showPageTitle: true,
          // animation: CustomTabsAnimation.slideIn(),
          // or user defined animation.
          // animation: const CustomTabsAnimation(
          //   startEnter: 'slide_up',
          //   startExit: 'android:anim/fade_out',
          //   endEnter: 'android:anim/fade_in',
          //   endExit: 'slide_down',
          // ),
          extraCustomTabs: const <String>[
            // ref. https://play.google.com/store/apps/details?id=org.mozilla.firefox
            'org.mozilla.firefox',
            // ref. https://play.google.com/store/apps/details?id=com.microsoft.emmx
            'com.microsoft.emmx',
          ],
        ),
        safariVCOption: SafariViewControllerOption(
          preferredBarTintColor: Theme.of(context).primaryColor,
          preferredControlTintColor: Colors.white,
          barCollapsingEnabled: true,
          entersReaderIfAvailable: false,
          dismissButtonStyle: SafariViewControllerDismissButtonStyle.close,
        ),
      );
    } catch (e) {
      // An exception is thrown if browser app is not installed on Android device.
      debugPrint(e.toString());
    }
  }
}