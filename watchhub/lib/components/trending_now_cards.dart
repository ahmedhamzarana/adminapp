import 'package:flutter/material.dart';
import 'package:watchhub/utils/appconstant.dart';

class TrendingNow extends StatelessWidget {
  const TrendingNow({super.key});

  static final List<Map<String, String>> trendingProducts = [
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

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 210,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: trendingProducts.length,
        itemBuilder: (context, index) {
          final product = trendingProducts[index];

          return Container(
            width: 160,
            margin: const EdgeInsets.only(right: 14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade300,
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
                  child: Image.network(
                    product["image"]!,
                    height: 120,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 120,
                        width: double.infinity,
                        color: Colors.grey.shade200,
                        child: const Icon(Icons.broken_image, size: 40, color: Colors.grey),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product["name"] ?? "Unknown",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Appconstant.appmaincolor,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        product["price"] ?? "",
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
          );
        },
      ),
    );
  }
}
