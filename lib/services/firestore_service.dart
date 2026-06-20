import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/product.dart';

class FirestoreService {
  // final FirebaseFirestore _db = FirebaseFirestore.instance; // DISABLED FOR DEMO
  
  // MOCK: Returns empty stream or error if called inadvertently
  Stream<List<Product>> getProducts() {
     return const Stream.empty();
  }

  // Fallback mock data if Firestore is empty or for testing
  Future<List<Product>> getMockProducts() async {
    await Future.delayed(const Duration(seconds: 1)); // Simulate delay
    return [
      Product(
        id: '1',
        name: 'Wireless Headphones',
        price: 99.99,
        // High quality Unsplash image of headphones
        imageUrl: 'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?auto=format&fit=crop&w=400&q=80',
        description: 'High quality wireless headphones with noise cancellation.',
        category: 'Electronics',
      ),
      Product(
        id: '2',
        name: 'Smart Watch',
        price: 199.99,
        // Smart watch image
        imageUrl: 'https://images.unsplash.com/photo-1523275335684-37898b6baf30?auto=format&fit=crop&w=400&q=80',
        description: 'Track your fitness and notifications.',
        category: 'Electronics',
      ),
      Product(
        id: '3',
        name: 'Running Shoes',
        price: 79.99,
        // Running shoes image
        imageUrl: 'https://images.unsplash.com/photo-1542291026-7eec264c27ff?auto=format&fit=crop&w=400&q=80',
        description: 'Comfortable running shoes for daily use.',
        category: 'Fashion',
      ),
    ];
  }
}
