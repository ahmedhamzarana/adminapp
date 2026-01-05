import 'package:flutter/material.dart';

class Sidebar extends StatelessWidget {
  final IconData icon; // Added strict types
  final String title;
  final VoidCallback onTap; // Added callback
  final bool isActive; // Added state check

  const Sidebar({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          // Change color based on selection
          color: isActive ? Colors.white.withOpacity(0.2) : Colors.transparent,
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isActive ? Colors.white : Colors.white70,
              size: 22,
            ),
            const SizedBox(width: 15),
            Text(
              title,
              style: TextStyle(
                color: isActive ? Colors.white : Colors.white70,
                fontSize: 16,
                fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
