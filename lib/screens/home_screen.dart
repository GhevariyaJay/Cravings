import 'package:flutter/material.dart';
import '../models/restaurant.dart';
import 'menu_screen.dart';
import '../utils/constants.dart';

class HomeScreen extends StatelessWidget {
  // Fake restaurant data (13 restaurants)
  final List<Restaurant> fakeRestaurants = [
    Restaurant(
      id: "1",
      name: "Pizza Palace",
      cuisine: "Italian",
      imageUrl: "https://images.unsplash.com/photo-1513104890138-7c749659a591?w=1000&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8M3x8cGl6emElMjBwYWxhY2V8ZW58MHx8MHx8fDA%3D",
    ),
    Restaurant(
      id: "2",
      name: "Burger Bonanza",
      cuisine: "American",
      imageUrl: "https://media.istockphoto.com/id/1391966291/photo/home-made-aloo-tikki-burger-with-lettuce-and-sauce.webp?a=1&b=1&s=612x612&w=0&k=20&c=1CsZGEsadcSKj_UZLxOV6dreQ1_5_Wba16cttQBJJPo=",
    ),
    Restaurant(
      id: "3",
      name: "Samosa Stop",
      cuisine: "Indian",
      imageUrl: "https://media.istockphoto.com/id/178729963/photo/samosa-with-mushroom-snack.webp?a=1&b=1&s=612x612&w=0&k=20&c=uDLrAm7potXScQwodbOApPH_gtBtgk_NPbcuTDUigLI=",
    ),
    Restaurant(
      id: "4",
      name: "Taco Fiesta",
      cuisine: "Mexican",
      imageUrl: "https://images.unsplash.com/photo-1604467715878-83e57e8bc129?w=1000&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8VGFjbyUyMEZpZXN0YXxlbnwwfHwwfHx8MA%3D%3D",
    ),
    Restaurant(
      id: "5",
      name: "Pasta Paradise",
      cuisine: "Italian",
      imageUrl: "https://media.istockphoto.com/id/1159438262/photo/one-pot-chicken-alfredo-pasta-directly-above-photo.webp?a=1&b=1&s=612x612&w=0&k=20&c=v6EXwu1MjSVMPWdNDiK5UjFm2WI4q7QkW0300_NQCF4=",
    ),
    Restaurant(
      id: "6",
      name: "Chhole Bhature House",
      cuisine: "Indian",
      imageUrl: "https://media.istockphoto.com/id/979914742/photo/chole-bhature-or-chick-pea-curry-and-fried-puri-served-in-terracotta-crockery-over-white.webp?a=1&b=1&s=612x612&w=0&k=20&c=8pmBVIcNb-GIFnsBT0sYqfy-YtzNq7pOqc6lQZgFOPo=",
    ),
    Restaurant(
      id: "7",
      name: "Ice Cream Delight",
      cuisine: "Desserts",
      imageUrl: "https://media.istockphoto.com/id/157472912/photo/ice-cream-composition-on-a-bowl.webp?a=1&b=1&s=612x612&w=0&k=20&c=e1yPCusQJl2scx955yuv9LUcbx5e7OcARC_VgEDdz5Y=",
    ),
    Restaurant(
      id: "8",
      name: "Thai Spice",
      cuisine: "Thai",
      imageUrl: "https://plus.unsplash.com/premium_photo-1661484957728-7370b773c669?w=1000&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MXx8VGhhaSUyMHNwaWNlfGVufDB8fDB8fHww",
    ),
    Restaurant(
      id: "9",
      name: "Veggie Grill",
      cuisine: "American",
      imageUrl: "https://images.unsplash.com/photo-1529358183242-45c61f3e1628?w=1000&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8M3x8dmVnZ2llJTIwZ3JpbGx8ZW58MHx8MHx8fDA%3D",
    ),
    Restaurant(
      id: "10",
      name: "Noodle Nest",
      cuisine: "Chinese",
      imageUrl: "https://media.istockphoto.com/id/1292637257/photo/veg-hakka-noodles-a-popular-oriental-dish-made-with-noodles-and-vegetables-served-over-a.webp?a=1&b=1&s=612x612&w=0&k=20&c=0xbbDCOhb_rLXHueLmoc0zBzmE8FR7xrDyvjflUlEQ8=",
    ),
    Restaurant(
      id: "11",
      name: "Falafel Feast",
      cuisine: "Middle Eastern",
      imageUrl: "https://plus.unsplash.com/premium_photo-1663853051820-128971c46c4c?w=1000&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MXx8ZmFsYWZlbCUyMGZlYXN0fGVufDB8fDB8fHww",
    ),
    Restaurant(
      id: "12",
      name: "Curry Corner",
      cuisine: "Indian",
      imageUrl: "https://plus.unsplash.com/premium_photo-1669831177863-864e75c8cbad?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1yZWxhdGVkfDF8fHxlbnwwfHx8fHw%3D",
    ),
    Restaurant(
      id: "13",
      name: "Sandwich Stop",
      cuisine: "Fast Food",
      imageUrl: "https://plus.unsplash.com/premium_photo-1664472757995-3260cd26e477?q=80&w=1061&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text("Cravings"),
        backgroundColor: kPrimaryColor,
        elevation: 0,
        actions: [
          // Help & Support Button
          IconButton(
            icon: Icon(Icons.support_agent, color: Colors.white),
            tooltip: "Help & Support",
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  title: Text("Help & Support", style: TextStyle(color: kTextColor)),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Email: support@cravings.com", style: TextStyle(color: kTextColor)),
                      Text("Phone: +91 6353734559", style: TextStyle(color: kTextColor)),
                    ],
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text("Close", style: TextStyle(color: kPrimaryColor)),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: ListView.builder(
          padding: EdgeInsets.all(kPadding),
          itemCount: fakeRestaurants.length,
          itemBuilder: (context, index) {
            return _buildRestaurantCard(context, fakeRestaurants[index], screenWidth);
          },
        ),
      ),
    );
  }

  Widget _buildRestaurantCard(BuildContext context, Restaurant restaurant, double screenWidth) {
    return Card(
      elevation: kCardElevation,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: EdgeInsets.symmetric(vertical: kPadding / 2),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => MenuScreen(restaurant: restaurant)),
          );
        },
        child: Padding(
          padding: EdgeInsets.all(kPadding),
          child: Row(
            children: [
              // Restaurant Image
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  restaurant.imageUrl,
                  width: screenWidth * 0.25,
                  height: screenWidth * 0.25,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Icon(Icons.error, size: screenWidth * 0.25),
                ),
              ),
              SizedBox(width: kPadding),

              // Restaurant Info (Simplified)
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      restaurant.name,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: kTextColor,
                      ),
                    ),
                    SizedBox(height: kPadding / 2),
                    Text(
                      restaurant.cuisine,
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ],
                ),
              ),

              // Navigation Icon
              Icon(Icons.arrow_forward_ios, color: kPrimaryColor),
            ],
          ),
        ),
      ),
    );
  }
}