import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/restaurant.dart';
import '../models/food_item.dart';
import '../providers/cart_provider.dart';
import 'cart_screen.dart';
import '../utils/constants.dart';

class MenuScreen extends StatelessWidget {
  final Restaurant restaurant;

  MenuScreen({required this.restaurant});

  // Fake vegetarian menu data in Indian Rupees (₹83 ≈ 1 USD)
  final Map<String, List<FoodItem>> fakeMenus = {
    "1": [
      FoodItem(id: "1", name: "Margherita Pizza", price: 9.99 * 83, imageUrl: "https://media.istockphoto.com/id/451865971/photo/margherita-pizza.webp?a=1&b=1&s=612x612&w=0&k=20&c=jp5qC8fhdGsaE3eg7A5lPhqSHcOVEOCC9xv-KUfPLTU="),
      FoodItem(id: "2", name: "Veggie Supreme Pizza", price: 11.49 * 83, imageUrl: "https://media.istockphoto.com/id/1412292752/photo/hawaiian-pizza-with-tomato-onion-chili-powder-and-black-pepper-isolated-on-wooden-cutting.webp?a=1&b=1&s=612x612&w=0&k=20&c=w38Dknli4PJc79iAJJP5zlEZlgaO_QMawEkE_XM1K7c="),
    ],
    "2": [
      FoodItem(id: "3", name: "Veggie Burger", price: 8.49 * 83, imageUrl: "https://media.istockphoto.com/id/1266980508/photo/burger-food-photography.webp?a=1&b=1&s=612x612&w=0&k=20&c=cyUGwhzdupDYbP5T1oLkORToWZgNp_A5EtUheLy5dSs="),
      FoodItem(id: "4", name: "Paneer Burger", price: 9.99 * 83, imageUrl: "https://media.istockphoto.com/id/1393177807/photo/juicy-paneer-burger-hamburger-or-cheeseburger-with-one-paneer-patties-with-sauce-concept-of.webp?a=1&b=1&s=612x612&w=0&k=20&c=lotB0zN2uK_sRepFSZFLfBE8uD80qUsJBy0J-_wB4Yg="),
    ],
    "3": [
      FoodItem(id: "5", name: "Samosa", price: 0.99 * 83, imageUrl: "https://media.istockphoto.com/id/980106992/photo/samosa-snack-served-with-tomato-ketchup-and-mint-chutney.webp?a=1&b=1&s=612x612&w=0&k=20&c=kLqY6RY-uvHPdGqExrUzas9n4V6GOgoa3XY7ApquWmM="),
      FoodItem(id: "6", name: "Aloo Tikki", price: 1.49 * 83, imageUrl: "https://media.istockphoto.com/id/1204866788/photo/aloo-tikki%C2%A0is-a-popular-snack-across-india-made-using-mashed-potatoes-close-up-in-a-plate.webp?a=1&b=1&s=612x612&w=0&k=20&c=OVznHR_QxXooof487H3u2CzZgQHsO0elbp0CYlCQvNo="),
    ],
    "4": [
      FoodItem(id: "7", name: "Veggie Taco", price: 5.49 * 83, imageUrl: "https://media.istockphoto.com/id/1148365682/photo/three-pork-tacos-in-shells-on-stone-background.webp?a=1&b=1&s=612x612&w=0&k=20&c=L5Juswoah_hPSn8Cwd18_PvyIM_3XHGyMtquoY_0lUA="),
      FoodItem(id: "8", name: "Bean Burrito", price: 6.99 * 83, imageUrl: "https://media.istockphoto.com/id/1300212146/photo/homemade-healthy-chicken-burrito-bowl.webp?a=1&b=1&s=612x612&w=0&k=20&c=Zybq-9z35rDHmjSomfvLDCN268Azpbc-97HAJXiHetI="),
    ],
    "5": [
      FoodItem(id: "9", name: "Spaghetti Aglio e Olio", price: 10.99 * 83, imageUrl: "https://media.istockphoto.com/id/2060246407/photo/fettuccine-aglio-e-olio-with-chilli-peppers-directly-above-photo.webp?a=1&b=1&s=612x612&w=0&k=20&c=L2b5tBvB2ztQnvMTOLohKJF5kgzy1I-cK37US5y2m-U="),
      FoodItem(id: "10", name: "Penne Arrabbiata", price: 10.49 * 83, imageUrl: "https://media.istockphoto.com/id/484190075/photo/arrabiata-pasta.webp?a=1&b=1&s=612x612&w=0&k=20&c=7GqOWLnFi_0FGtWogP4ja-UrGACXjC-FCk4wnYrJ3io="),
    ],
    "6": [
      FoodItem(id: "11", name: "Chhole Bhature", price: 2.99 * 83, imageUrl: "https://media.istockphoto.com/id/1328524212/photo/katlambe-chole.webp?a=1&b=1&s=612x612&w=0&k=20&c=TAIktSQ7PNsrwBuf4UBWDC7HNxbHvRdX7R0R0mVqcdo="),
      FoodItem(id: "12", name: "Pav Bhaji", price: 3.49 * 83, imageUrl: "https://media.istockphoto.com/id/1327433011/photo/pav-bhaji-indian-street-food-bharuch-gujarat-india.webp?a=1&b=1&s=612x612&w=0&k=20&c=wuk8_FqsHJwFTKvpAMt6iA7fsN0zROVmeSpJ9O9_cmE="),
    ],
    "7": [
      FoodItem(id: "13", name: "Vanilla Ice Cream", price: 3.99 * 83, imageUrl: "https://images.unsplash.com/photo-1560008581-09826d1de69e?w=1000&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8VmFuaWxsYSUyMEljZSUyMENyZWFtfGVufDB8fDB8fHww"),
      FoodItem(id: "14", name: "Mango Sorbet", price: 4.99 * 83, imageUrl: "https://media.istockphoto.com/id/103980450/photo/orange-sorbet-served-on-a-plate-with-slices-of-orange.webp?a=1&b=1&s=612x612&w=0&k=20&c=F9emqHfJ_wNASYxLXRiIHtpdbbPl8z1Oc0ibrr-i9LQ="),
    ],
    "8": [
      FoodItem(id: "15", name: "Veg Pad Thai", price: 9.49 * 83, imageUrl: "https://media.istockphoto.com/id/1224360172/photo/veg-pad-woon-sen-or-thai-glass-noodle-stir-fry-or-pad-thai-in-bowl-on-gray-concrete-backdrop.webp?a=1&b=1&s=612x612&w=0&k=20&c=6f5og2106Tn9s0xPQx7WEc6WuRtO0JUZjNWpGrCQDpI="),
      FoodItem(id: "16", name: "Green Veg Curry", price: 10.99 * 83, imageUrl: "https://media.istockphoto.com/id/1088329282/photo/dal-palak-or-lentil-spinach-curry-popular-indian-main-course-healthy-recipe-served-in-a.webp?a=1&b=1&s=612x612&w=0&k=20&c=bep_ox-n_WycgL2IvScwPknqJxf4fw5tWui2f2CrnlQ="),
    ],
    "9": [
      FoodItem(id: "17", name: "Grilled Veggie Platter", price: 12.99 * 83, imageUrl: "https://media.istockphoto.com/id/2195870938/photo/kebabs.webp?a=1&b=1&s=612x612&w=0&k=20&c=dXlxABz09XEPXiY-g31xv9Y_87B28vaSNMMVKcI_DNg="),
      FoodItem(id: "18", name: "Corn on the Cob", price: 0.49 * 83, imageUrl: "https://media.istockphoto.com/id/1264078821/photo/grilled-sweet-corn-with-lime-and-salt.webp?a=1&b=1&s=612x612&w=0&k=20&c=9QbkD6FnnioEot7ThZLRuzFdLWo1aZ6dAiAT97Ui9E0="),
    ],
    "10": [
      FoodItem(id: "19", name: "Veg Chow Mein", price: 8.49 * 83, imageUrl: "https://media.istockphoto.com/id/1405552715/photo/chinese-fast-food-noddle-and-veg-balls.webp?a=1&b=1&s=612x612&w=0&k=20&c=Hg_OQSTKXpOnMyAf_ku1SMJrNliVmnOuV3QWOm0xquU="),
      FoodItem(id: "20", name: "Veg Fried Rice", price: 6.49 * 83, imageUrl: "https://media.istockphoto.com/id/2198480737/photo/image-of-egg-fried-rice-with-mixed-veg-sweet-sour-peppers-crispy-chicken-strips-classic.webp?a=1&b=1&s=612x612&w=0&k=20&c=tearh1SJHMA5l_RXxOHqBgfHhFiBsAroWR9wjcgxEQ8="),
    ],
    "11": [
      FoodItem(id: "21", name: "Falafel Wrap", price: 7.49 * 83, imageUrl: "https://media.istockphoto.com/id/1139093193/photo/tortilla-wrap-with-falafel-and-fresh-salad-vegan-tacos-vegetarian-healthy-food.webp?a=1&b=1&s=612x612&w=0&k=20&c=vE-8f9qh7ljASHx4hw1EWvtkuIGqb8fDdEEARl7Ed_Q="),
      FoodItem(id: "22", name: "Hummus Plate", price: 5.99 * 83, imageUrl: "https://plus.unsplash.com/premium_photo-1672517336925-20b3deac59dc?w=1000&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MXx8SHVtbXVzJTIwUGxhdGV8ZW58MHx8MHx8fDA%3D"),
    ],
    "12": [
      FoodItem(id: "23", name: "Paneer Masala", price: 5.99 * 83, imageUrl: "https://media.istockphoto.com/id/1325272041/photo/green-peas-or-matar-paneer-curry.webp?a=1&b=1&s=612x612&w=0&k=20&c=7PK66_rtELkYCBtrkBXtTLAp85zSlPQnibh01NNXYE4="),
      FoodItem(id: "24", name: "Vegetable Biryani", price: 4.49 * 83, imageUrl: "https://media.istockphoto.com/id/1355635210/photo/pilau-or-vegetable-biryani.webp?a=1&b=1&s=612x612&w=0&k=20&c=7hOtPRWJf9fDrlOsfRkEbeQxZX_0V6ebCYX4Ewde14E="),
    ],
    "13": [
      FoodItem(id: "25", name: "Veggie Sandwich", price: 3.49 * 83, imageUrl: "https://media.istockphoto.com/id/1085139228/photo/paneer-tikka-sandwich-is-a-popular-indian-version-of-sandwich-using-cottage-cheese-curry-with.webp?a=1&b=1&s=612x612&w=0&k=20&c=gOlul1WNGJqjf-zaEOa1SyF52pFWPI8XHro7aSWi75g="),
      FoodItem(id: "26", name: "Paneer Sub", price: 3.49 * 83, imageUrl: "https://media.istockphoto.com/id/1125149518/photo/sandwich-on-slate.webp?a=1&b=1&s=612x612&w=0&k=20&c=ZGpykzsuRd6thGLW0ZnnvdDlTqTG9IJAEsfc0mkNebE="),
    ],
  };

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final menuItems = fakeMenus[restaurant.id] ?? [];

    return Scaffold(
      appBar: AppBar(
        title: Text("${restaurant.name} Menu"),
        backgroundColor: kPrimaryColor,
        elevation: 0,
      ),
      body: SafeArea(
        child: menuItems.isEmpty
            ? Center(child: Text("No menu items available", style: TextStyle(fontSize: 18, color: kTextColor)))
            : ListView.builder(
          padding: EdgeInsets.all(kPadding),
          itemCount: menuItems.length,
          itemBuilder: (context, index) {
            return _buildMenuItemCard(context, menuItems[index], screenWidth);
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => CartScreen())),
        child: Icon(Icons.shopping_cart),
        backgroundColor: kPrimaryColor,
      ),
    );
  }

  Widget _buildMenuItemCard(BuildContext context, FoodItem item, double screenWidth) {
    return Card(
      elevation: kCardElevation,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: EdgeInsets.symmetric(vertical: kPadding / 2),
      child: Padding(
        padding: EdgeInsets.all(kPadding),
        child: Row(
          children: [
            // Food Image
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                item.imageUrl,
                width: screenWidth * 0.2,
                height: screenWidth * 0.2,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Icon(Icons.fastfood, size: screenWidth * 0.2),
              ),
            ),
            SizedBox(width: kPadding),

            // Food Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: kTextColor),
                  ),
                  SizedBox(height: kPadding / 4),
                  Text(
                    "Tasty ${item.name.toLowerCase()} with authentic flavors",
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: kPadding / 4),
                  Text(
                    "₹${item.price.toStringAsFixed(2)}", // Price in Indian Rupees
                    style: TextStyle(fontSize: 14, color: kPrimaryColor, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),

            // Add to Cart Button
            IconButton(
              icon: Icon(Icons.add_shopping_cart, color: kPrimaryColor),
              onPressed: () {
                Provider.of<CartProvider>(context, listen: false).addToCart(item);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("${item.name} added to cart")),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}