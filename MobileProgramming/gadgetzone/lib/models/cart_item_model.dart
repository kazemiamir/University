import 'product_model.dart';

class CartItem {
  final Product product;
  int quantity;

  CartItem({
    required this.product,
    this.quantity = 1,
  });

  double get totalPrice => product.price * quantity;
  
  double? get savedAmount {
    if (product.originalPrice != null) {
      return (product.originalPrice! - product.price) * quantity;
    }
    return null;
  }
} 