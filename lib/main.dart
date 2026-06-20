import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'firebase_options.dart';
import 'providers/auth_provider.dart';
import 'providers/cart_provider.dart';
import 'models/product.dart';

import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/product_details_screen.dart';
import 'screens/cart_screen.dart';
import 'screens/checkout_screen.dart';
import 'screens/wishlist_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/chatbot_screen.dart';
import 'screens/change_password_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Load environment variables from .env file
  try {
    await dotenv.load(fileName: ".env");
    debugPrint('[App] Environment variables loaded successfully');
  } catch (e) {
    debugPrint('[App] Warning: Could not load .env file: $e');
  }
  
  // Initialize Firebase
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    debugPrint('[App] Firebase initialized successfully');
  } catch (e) {
    debugPrint('[App] Firebase initialization failed: $e');
    // App will continue in demo mode if Firebase fails
  }
  
  runApp(const MyApp());
}

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
      ],
      child: Builder(
        builder: (context) {
          final authProvider = Provider.of<AuthProvider>(context);
          
          final router = GoRouter(
            navigatorKey: _rootNavigatorKey,
            initialLocation: '/login',
            redirect: (context, state) {
              final isLoggedIn = authProvider.isAuthenticated;
              final isLoggingIn = state.uri.toString() == '/login';

              // If not logged in and not on login page, redirect to login
              if (!isLoggedIn && !isLoggingIn) return '/login';
              
              // If logged in and on login page, redirect to home
              if (isLoggedIn && isLoggingIn) return '/';

              return null;
            },
            routes: [
              GoRoute(
                path: '/login',
                builder: (context, state) => const LoginScreen(),
              ),
              ShellRoute(
                navigatorKey: _shellNavigatorKey,
                builder: (context, state, child) {
                  return ScaffoldWithNavBar(child: child);
                },
                routes: [
                  GoRoute(
                    path: '/',
                    builder: (context, state) => const HomeScreen(),
                  ),
                  GoRoute(
                    path: '/cart',
                    builder: (context, state) => const CartScreen(),
                  ),
                  GoRoute(
                    path: '/wishlist',
                    builder: (context, state) => const WishlistScreen(),
                  ),
                  GoRoute(
                    path: '/chatbot',
                    builder: (context, state) => const ChatbotScreen(),
                  ),
                  GoRoute(
                    path: '/profile',
                    builder: (context, state) => const ProfileScreen(),
                  ),
                ],
              ),
              GoRoute(
                path: '/product/:id',
                parentNavigatorKey: _rootNavigatorKey,
                builder: (context, state) {
                  final product = state.extra as Product;
                  return ProductDetailsScreen(product: product);
                },
              ),
              GoRoute(
                path: '/checkout',
                parentNavigatorKey: _rootNavigatorKey,
                builder: (context, state) => const CheckoutScreen(),
              ),
              GoRoute(
                path: '/change-password',
                parentNavigatorKey: _rootNavigatorKey,
                builder: (context, state) => const ChangePasswordScreen(),
              ),
            ],
          );

          return MaterialApp.router(
            title: 'Project Mobile App',
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
              useMaterial3: true,
            ),
            routerConfig: router,
          );
        }
      ),
    );
  }
}

class ScaffoldWithNavBar extends StatelessWidget {
  final Widget child;

  const ScaffoldWithNavBar({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _calculateSelectedIndex(context),
        onTap: (int idx) => _onItemTapped(idx, context),
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'Cart'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Wishlist'),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Chatbot'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }

  static int _calculateSelectedIndex(BuildContext context) {
    final String location = GoRouterState.of(context).uri.toString();
    if (location.startsWith('/cart')) return 1;
    if (location.startsWith('/wishlist')) return 2;
    if (location.startsWith('/chatbot')) return 3;
    if (location.startsWith('/profile')) return 4;
    return 0;
  }

  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        context.go('/');
        break;
      case 1:
        context.go('/cart');
        break;
      case 2:
        context.go('/wishlist');
        break;
      case 3:
        context.go('/chatbot');
        break;
      case 4:
        context.go('/profile');
        break;
    }
  }
}
