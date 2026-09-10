import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../providers/product_provider.dart';
import '../models/product.dart';
import 'cart_page.dart';

class ProductListPage extends StatelessWidget {
  const ProductListPage({Key? key}) : super(key: key);

  Color _ddrColor(String title) {
    final t = title.toLowerCase();
    if (t.contains('ddr5')) return const Color(0xFF8B5CF6);
    if (t.contains('ddr4')) return const Color(0xFF3B82F6);
    if (t.contains('ddr3')) return const Color(0xFF14B8A6);
    return Colors.indigo;
  }

  String _ddrLabel(String title) {
    final t = title.toLowerCase();
    if (t.contains('ddr5')) return 'DDR5';
    if (t.contains('ddr4')) return 'DDR4';
    if (t.contains('ddr3')) return 'DDR3';
    return 'PRODUK';
  }

  void _showAddProductDialog(BuildContext context) {
    final namaCtrl = TextEditingController();
    final hargaCtrl = TextEditingController();
    final deskripsiCtrl = TextEditingController();
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: const Text('Tambah Produk Baru'),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: namaCtrl,
                decoration: const InputDecoration(labelText: 'Nama Produk'),
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Nama wajib diisi' : null,
              ),
              TextFormField(
                controller: hargaCtrl,
                decoration: const InputDecoration(labelText: 'Harga (Rp)'),
                keyboardType: TextInputType.number,
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'Harga wajib diisi';
                  if (double.tryParse(v) == null) return 'Harga harus berupa angka';
                  return null;
                },
              ),
              TextFormField(
                controller: deskripsiCtrl,
                decoration: const InputDecoration(labelText: 'Deskripsi'),
                maxLines: 2,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Batal'),
          ),
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [Color(0xFF4338CA), Color(0xFF6366F1)]),
              borderRadius: BorderRadius.circular(10),
            ),
            child: TextButton(
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  await context.read<ProductProvider>().addProduct(
                        namaCtrl.text.trim(),
                        double.parse(hargaCtrl.text.trim()),
                        deskripsiCtrl.text.trim(),
                      );
                  if (ctx.mounted) Navigator.of(ctx).pop();
                }
              },
              child: const Text('Simpan', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    final productProvider = Provider.of<ProductProvider>(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF4F5FA),
      appBar: AppBar(
        title: const Text(
          'E-Catalog Ram Tech',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF4338CA), Color(0xFF6366F1), Color(0xFF818CF8)],
            ),
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 4,
        actions: [
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart, color: Colors.white),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const CartPage()),
                  );
                },
              ),
              if (cart.items.isNotEmpty)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.orangeAccent,
                      shape: BoxShape.circle,
                    ),
                    constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
                    child: Text(
                      '${cart.items.length}',
                      style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 8),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF4338CA),
        onPressed: () => _showAddProductDialog(context),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: productProvider.products.isEmpty
          ? const Center(child: Text('Belum ada produk'))
          : GridView.builder(
              padding: const EdgeInsets.all(12),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.68,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: productProvider.products.length,
              itemBuilder: (ctx, i) {
                final Product product = productProvider.products[i];
                final ddrColor = _ddrColor(product.title);
                final adaFoto = product.imageUrl.isNotEmpty;

                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 12, offset: const Offset(0, 4)),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [ddrColor.withOpacity(0.12), ddrColor.withOpacity(0.04)],
                                    ),
                                  ),
                                  child: adaFoto
                                      ? Image.asset(
                                          product.imageUrl,
                                          fit: BoxFit.cover,
                                          width: double.infinity,
                                          errorBuilder: (ctx, error, stackTrace) => Center(
                                            child: Icon(Icons.memory, size: 40, color: ddrColor.withOpacity(0.6)),
                                          ),
                                        )
                                      : Center(
                                          child: Icon(Icons.inventory_2_outlined, size: 40, color: ddrColor.withOpacity(0.6)),
                                        ),
                                ),
                              ),
                              Positioned(
                                top: 6,
                                left: 6,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(color: ddrColor, borderRadius: BorderRadius.circular(20)),
                                  child: Text(
                                    _ddrLabel(product.title),
                                    style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          product.title,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Rp ${product.price.toStringAsFixed(0)}',
                          style: const TextStyle(color: Color(0xFF4338CA), fontWeight: FontWeight.w700, fontSize: 14),
                        ),
                        const SizedBox(height: 8),
                        SizedBox(
                          width: double.infinity,
                          height: 36,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(colors: [Color(0xFF4338CA), Color(0xFF6366F1)]),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              ),
                              onPressed: () {
                                context.read<CartProvider>().addItem(product);
                                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    backgroundColor: ddrColor,
                                    behavior: SnackBarBehavior.floating,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                    content: Text('${product.title} ditambahkan!'),
                                    duration: const Duration(seconds: 1),
                                  ),
                                );
                              },
                              icon: const Icon(Icons.add_shopping_cart, size: 14),
                              label: const Text('TAMBAH', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}