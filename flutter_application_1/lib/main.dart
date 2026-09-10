import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/cart_provider.dart';
import 'providers/product_provider.dart';
import 'pages/product_list_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProductProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'E-Catalog Ram Tech',
        theme: ThemeData(
          useMaterial3: true,
          scaffoldBackgroundColor: const Color(0xFFF4F5FA),
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF4338CA),
            brightness: Brightness.light,
          ),
        ),
        home: const StartupLoader(),
      ),
    );
  }
}

class StartupLoader extends StatefulWidget {
  const StartupLoader({super.key});

  @override
  State<StartupLoader> createState() => _StartupLoaderState();
}

class _StartupLoaderState extends State<StartupLoader> {
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    await context.read<ProductProvider>().loadProducts();
    await context.read<CartProvider>().loadCart();
    if (mounted) setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        backgroundColor: Color(0xFFF4F5FA),
        body: Center(child: CircularProgressIndicator(color: Color(0xFF4338CA))),
      );
    }
    return const ProductListPage();
  }
}