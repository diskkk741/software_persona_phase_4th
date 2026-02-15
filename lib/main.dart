import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'pages/cart_page.dart';
import 'models/cart_item.dart';
import 'utils/format.dart';
import 'models/product.dart';
import 'pages/product_detail_page.dart';

void main() {
  runApp(const MiniKatalogApp());
}

class MiniKatalogApp extends StatelessWidget {
  const MiniKatalogApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mini Katalog',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        scaffoldBackgroundColor: const Color(0xFFF7F8FA),
        appBarTheme: const AppBarTheme(centerTitle: false, elevation: 0),
      ),
      home: const ProductListPage(),
    );
  }
}

class ProductListPage extends StatefulWidget {
  const ProductListPage({super.key});

  @override
  State<ProductListPage> createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  final TextEditingController _searchController = TextEditingController();

  List<Product> _allProducts = [];
  List<Product> _filteredProducts = [];
  bool _loading = true;
  final List<CartItem> _cart = [];
  int get _cartCount {
    return _cart.fold<int>(0, (sum, item) => sum + item.quantity);
  }

  @override
  void initState() {
    super.initState();
    _loadProducts();

    _searchController.addListener(() {
      final q = _searchController.text.trim().toLowerCase();
      setState(() {
        if (q.isEmpty) {
          _filteredProducts = List<Product>.from(_allProducts);
        } else {
          _filteredProducts = _allProducts
              .where((p) => p.title.toLowerCase().contains(q))
              .toList();
        }
      });
    });
  }

  Future<void> _loadProducts() async {
    try {
      final raw = await rootBundle.loadString('assets/data/products.json');
      final List<dynamic> decoded = jsonDecode(raw);

      final products = decoded
          .map((e) => Product.fromJson(e as Map<String, dynamic>))
          .toList();

      setState(() {
        _allProducts = products;
        _filteredProducts = List<Product>.from(products);
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _loading = false;
      });

      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("JSON ERROR: $e")));
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ürünler'),
        actions: [
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart),
                onPressed: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => CartPage(cart: _cart)),
                  );
                  setState(() {}); // Sepetten dönüşte badge güncellensin
                },
              ),
              if (_cartCount > 0)
                Positioned(
                  right: 6,
                  top: 6,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      _cartCount.toString(),
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),

      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                hintText: 'Ara (örn: laptop)',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : _filteredProducts.isEmpty
                ? const Center(
                    child: Text(
                      "Ürün bulunamadı",
                      style: TextStyle(fontSize: 16),
                    ),
                  )
                : GridView.builder(
                    padding: const EdgeInsets.all(12),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 0.75,
                        ),
                    itemCount: _filteredProducts.length,
                    itemBuilder: (context, index) {
                      final p = _filteredProducts[index];

                      return GestureDetector(
                        onTap: () async {
                          final result = await Navigator.push<Product>(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ProductDetailPage(product: p),
                            ),
                          );

                          if (result != null) {
                            setState(() {
                              final idx = _cart.indexWhere(
                                (x) => x.product.id == result.id,
                              );

                              if (idx == -1) {
                                _cart.add(
                                  CartItem(product: result, quantity: 1),
                                );
                              } else {
                                _cart[idx].quantity += 1;
                              }
                            });

                            if (!context.mounted) return;
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  "${result.title} sepete eklendi ✅",
                                ),
                              ),
                            );
                          }
                        },

                        child: Card(
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.asset(
                                      p.image,
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  p.title,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  formatPrice(p.price),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
