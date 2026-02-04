import 'package:flutter/material.dart';
import 'package:watchhub/components/product_detail.dart';
import 'package:watchhub/utils/appconstant.dart';


class ProductViewAll extends StatefulWidget {
  const ProductViewAll({super.key});

  @override
  State<ProductViewAll> createState() => _ProductViewAllState();
}

class _ProductViewAllState extends State<ProductViewAll> {
  List<Map<String, String>> popularProducts = [
    {
      "image":
          "https://i.pinimg.com/736x/71/35/28/713528c16b5c7fe5b2c17e8e0620a89e.jpg",
      "name": "Rolex Submariner",
      "price": "\$320",
    },
    {
      "image":
          "https://i.pinimg.com/736x/db/12/fe/db12fea16a6836ac1a7580921983fa06.jpg",
      "name": "Omega Speedmaster",
      "price": "\$280",
    },
    {
      "image":
          "https://i.pinimg.com/736x/66/01/43/660143948271fc5cf9dc2b7b4769ea12.jpg",
      "name": "Cartier Santos",
      "price": "\$350",
    },
    {
      "image": "https://wallpapercave.com/wp/wp4345512.jpg",
      "name": "Patek Philippe",
      "price": "\$420",
    },
  ];

  void sortProducts(String option) {
    setState(() {
      if (option == "Low to High") {
        popularProducts.sort((a, b) =>
            int.parse(a["price"]!.replaceAll("\$", "")) -
            int.parse(b["price"]!.replaceAll("\$", "")));
      } else if (option == "High to Low") {
        popularProducts.sort((a, b) =>
            int.parse(b["price"]!.replaceAll("\$", "")) -
            int.parse(a["price"]!.replaceAll("\$", "")));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Appconstant.appmaincolor,
        leading: IconButton(
          icon:
              Icon(Icons.arrow_back_ios_new, color: Appconstant.barcolor),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Popular Watches",
          style: TextStyle(
            color: Appconstant.barcolor,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          PopupMenuButton<String>(
            icon: Icon(Icons.filter_alt, color: Appconstant.barcolor),
            onSelected: (value) => sortProducts(value),
            itemBuilder: (context) => const [
              PopupMenuItem(
                value: "Low to High",
                child: Text("Price: Low to High"),
              ),
              PopupMenuItem(
                value: "High to Low",
                child: Text("Price: High to Low"),
              ),
            ],
          ),
        ],
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(12),
        gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 0.90,
        ),
        itemCount: popularProducts.length,
        itemBuilder: (context, index) {
          final product = popularProducts[index];

          return GestureDetector(
            // onTap: () {
            //   Navigator.push(
            //     context,
            //     MaterialPageRoute(
            //       builder: (_) =>
            //           ProductDetailScreen(product: product),
            //     ),
            //   );
            // },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade300,
                    blurRadius: 6,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(18)),
                    child: Image.network(
                      product["image"]!,
                      height: 120,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        Text(
                          product["name"]!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color:
                                Appconstant.appmaincolor,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          product["price"]!,
                          style: TextStyle(
                            color: Appconstant.barcolor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
