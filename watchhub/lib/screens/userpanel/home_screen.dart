// ignore_for_file: unnecessary_underscores

import 'package:flutter/material.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:provider/provider.dart';
import 'package:watchhub/components/running_orders_widget.dart';
import 'package:watchhub/provider/home_provider.dart';
import 'package:watchhub/provider/orderprovider.dart';
import 'package:watchhub/screens/auth-ui/brandwise_screen.dart';
import 'package:watchhub/utils/app_routes.dart';
import 'package:watchhub/utils/appconstant.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HomeProvider>().fetchBrands();
      context.read<HomeProvider>().fetchAllProducts();
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.resumed) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.read<OrderProvider>().fetchOrders();
      });
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final homeProvider = Provider.of<HomeProvider>(context);

    return Scaffold(
      backgroundColor: Colors.grey[50],

      // ================= APP BAR =================
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Appconstant.appmaincolor,
        title: const Text(
          "WatchHub",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Appconstant.barcolor,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.search,
              color: Appconstant.barcolor,
            ),
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.searchroute);
            },
          ),
          IconButton(
            icon: const Icon(Icons.explore, color: Appconstant.barcolor),
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.browseproductsroute);
            },
          ),
        ],
      ),

      // ================= BODY =================
      body: ListView(
        padding: const EdgeInsets.all(0),
        children: [
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: buildCarousel(homeProvider),
          ),
          const SizedBox(height: 24),
          buildBrandSlider(homeProvider),
          const SizedBox(height: 24),
          
          // ================= RUNNING ORDERS SECTION =================
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(13),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: buildSectionTitle("Running Orders"),
                ),
                const Padding(
                  padding: EdgeInsets.only(bottom: 16),
                  child: RunningOrdersWidget(),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),

      // ================= FAB =================
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, AppRoutes.cartroute);
        },
        backgroundColor: Appconstant.barcolor,
        elevation: 4,
        child: const Icon(Icons.add_shopping_cart, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      // ================= BOTTOM NAV =================
      bottomNavigationBar: AnimatedBottomNavigationBar.builder(
        itemCount: homeProvider.iconList.length,
        tabBuilder: (index, isActive) {
          return Icon(
            homeProvider.iconList[index],
            size: 26,
            color: isActive ? Appconstant.barcolor : Colors.grey,
          );
        },
        backgroundColor: Appconstant.appmaincolor,
        activeIndex: homeProvider.bottomNavIndex,
        gapLocation: GapLocation.center,
        notchSmoothness: NotchSmoothness.verySmoothEdge,
        onTap: (index) {
          homeProvider.bottomNavIndex = index;

          if (index == 1) {
            Navigator.pushNamed(context, AppRoutes.orderhistoryroute);
          } else if (index == 2) {
            Navigator.pushNamed(context, AppRoutes.favoriteroute);
          } else if (index == 3) {
            Navigator.pushNamed(context, AppRoutes.profileroute);
          }
        },
      ),
    );
  }

  // ================= CAROUSEL =================
  Widget buildCarousel(HomeProvider provider) {
    return CarouselSlider(
      items: provider.carouselImages.map((img) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(25),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: Image.network(
              img,
              fit: BoxFit.cover,
              width: double.infinity,
            ),
          ),
        );
      }).toList(),
      options: CarouselOptions(
        autoPlay: true,
        enlargeCenterPage: true,
        viewportFraction: 0.9,
        aspectRatio: 2.1,
        autoPlayInterval: const Duration(seconds: 4),
        autoPlayAnimationDuration: const Duration(milliseconds: 800),
      ),
    );
  }

  // ================= BRAND SLIDER =================
  Widget buildBrandSlider(HomeProvider provider) {
    if (provider.isLoading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (provider.errorMessage.isNotEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Text(
            provider.errorMessage,
            style: const TextStyle(color: Colors.red),
          ),
        ),
      );
    }

    if (provider.brands.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Text("No brands found"),
        ),
      );
    }

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              "Top Brands",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 100,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              scrollDirection: Axis.horizontal,
              itemCount: provider.brands.length,
              separatorBuilder: (_, __) => const SizedBox(width: 16),
              itemBuilder: (context, index) {
                final brand = provider.brands[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => BrandWiseScreen(
                          brandId: brand.id,
                          brandName: brand.name,
                          brandLogo: brand.imageUrl,
                        ),
                      ),
                    );
                  },
                  child: Column(
                    children: [
                      Container(
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.grey[200]!,
                            width: 2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withAlpha(20),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: ClipOval(
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: Image.network(
                              brand.imageUrl,
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) {
                                return Icon(
                                  Icons.watch,
                                  color: Appconstant.appmaincolor,
                                  size: 30,
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      SizedBox(
                        width: 70,
                        child: Text(
                          brand.name,
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // ================= SECTION TITLE =================
  Widget buildSectionTitle(String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              width: 4,
              height: 24,
              decoration: BoxDecoration(
                color: Appconstant.barcolor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 10),
            Text(
              title,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Appconstant.appmaincolor,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
        GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, AppRoutes.orderhistoryroute);
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Appconstant.barcolor.withAlpha(25),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                Text(
                  "View All",
                  style: TextStyle(
                    color: Appconstant.barcolor,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(width: 4),
                Icon(
                  Icons.arrow_forward_ios,
                  color: Appconstant.barcolor,
                  size: 12,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}