import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'models/user.dart';
import 'screens/home_screen.dart';
import 'screens/history_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/admin_screen.dart';
import 'screens/auth_screen.dart';
import 'providers/cart_provider.dart';
import 'providers/order_provider.dart';
import 'utils/constants.dart';
import 'services/auth_service.dart' as authService;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => OrderProvider()),
      ],
      child: const CravingsApp(),
    ),
  );
}

class CravingsApp extends StatelessWidget {
  const CravingsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cravings',
      theme: ThemeData(
        primaryColor: kPrimaryColor,
        scaffoldBackgroundColor: kBackgroundColor,
        textTheme: const TextTheme(bodyMedium: TextStyle(color: kTextColor)),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(backgroundColor: kPrimaryColor),
        ),
      ),
      home: FutureBuilder<User?>(
        future: authService.AuthService.getCurrentUserWithRole(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            print("Waiting for user role check...");
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            print("Error fetching user: ${snapshot.error}");
            return const Center(child: Text("Error loading user data"));
          }
          if (!snapshot.hasData || snapshot.data == null) {
            print("No user logged in, redirecting to AuthScreen");
            return const AuthScreen();
          }
          final user = snapshot.data!;
          print("User loaded: ${user.email}, isAdmin: ${user.isAdmin}");
          return MainScreen(isAdmin: user.isAdmin);
        },
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MainScreen extends StatefulWidget {
  final bool isAdmin;

  const MainScreen({required this.isAdmin, super.key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  late List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    print("Initializing MainScreen with isAdmin: ${widget.isAdmin}");
    _screens = [
      HomeScreen(),
      HistoryScreen(),
      ProfileScreen(),
    ];
    if (widget.isAdmin) {
      print("Adding AdminScreen to navigation tabs");
      _screens.add(AdminScreen());
    } else {
      print("User is not an admin, skipping AdminScreen");
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      print("Switching to tab index: $index");
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: [
          const BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          const BottomNavigationBarItem(icon: Icon(Icons.history), label: 'History'),
          const BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          if (widget.isAdmin)
            const BottomNavigationBarItem(icon: Icon(Icons.admin_panel_settings), label: 'Admin'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: kPrimaryColor,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
      ),
    );
  }
}