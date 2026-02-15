import 'package:flutter/material.dart';
import '../models/cart_item.dart';

class CartPage extends StatefulWidget {
  final List<CartItem> cart;

  const CartPage({super.key, required this.cart});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  int get totalPrice {
    int sum = 0;
    for (final item in widget.cart) {
      sum += item.lineTotal;
    }
    return sum;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sepet"),
        actions: [
          if (widget.cart.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_sweep),
              onPressed: () {
                setState(() {
                  widget.cart.clear();
                });
              },
            ),
        ],
      ),
      body: widget.cart.isEmpty
          ? const Center(child: Text("Sepet boş"))
          : Column(
              children: [
                Expanded(
                  child: ListView.separated(
                    itemCount: widget.cart.length,
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final item = widget.cart[index];
                      final p = item.product;

                      return ListTile(
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.asset(
                            p.image,
                            width: 56,
                            height: 56,
                            fit: BoxFit.cover,
                          ),
                        ),
                        title: Text(p.title),
                        subtitle: Text(
                          "${p.price} ₺ x ${item.quantity} = ${item.lineTotal} ₺",
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove),
                              onPressed: () {
                                setState(() {
                                  item.quantity -= 1;
                                  if (item.quantity <= 0) {
                                    widget.cart.removeAt(index);
                                  }
                                });
                              },
                            ),
                            Text(
                              item.quantity.toString(),
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.add),
                              onPressed: () {
                                setState(() {
                                  item.quantity += 1;
                                });
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Toplam",
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      Text(
                        "$totalPrice ₺",
                        style: const TextStyle(fontWeight: FontWeight.w800),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
