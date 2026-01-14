import 'package:adminapp/reusable/custom_table.dart';
import 'package:flutter/material.dart';

class ReviewsTableView extends StatelessWidget {
  const ReviewsTableView({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> reviewsData = [
      {
        'product': 'Rolex Submariner',
        'customer': 'Ahmed Ali',
        'rating': 5,
        'comment': 'Excellent quality watch! Worth every penny.',
        'date': 'Jan 08, 2026',
        'status': 'Approved',
      },
      {
        'product': 'Omega Seamaster',
        'customer': 'Sara Khan',
        'rating': 4,
        'comment': 'Great watch but delivery was delayed.',
        'date': 'Jan 07, 2026',
        'status': 'Pending',
      },
      {
        'product': 'TAG Heuer Carrera',
        'customer': 'Bilal Ahmed',
        'rating': 3,
        'comment': 'Good product but price is too high.',
        'date': 'Jan 06, 2026',
        'status': 'Approved',
      },
    ];

    return Align(
            alignment: Alignment.topLeft,

      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: ResponsiveTableView(
            title: 'Product Reviews',
            data: reviewsData,
            headerActions: [
              ElevatedButton.icon(
                onPressed: () {
                  // Filter pending reviews
                },
                icon: const Icon(Icons.filter_list, size: 18),
                label: const Text("Pending Reviews"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  elevation: 0,
                  side: const BorderSide(color: Colors.black12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
            headers: const [
              'Product',
              'Customer',
              'Rating',
              'Comment',
              'Date',
              'Status',
              'Actions',
            ],
            rowBuilder: (context, header, value, item) {
              if (header == 'Product') {
                return Text(
                  item['product'],
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                );
              }
        
              if (header == 'Rating') {
                final int rating = value;
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ...List.generate(
                      5,
                      (index) => Icon(
                        index < rating ? Icons.star : Icons.star_border,
                        size: 16,
                        color: index < rating ? Colors.amber : Colors.grey,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '$rating/5',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                );
              }
        
              if (header == 'Comment') {
                return SizedBox(
                  width: 250,
                  child: Text(
                    value,
                    style: TextStyle(color: Colors.grey.shade700, fontSize: 12),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                );
              }
        
              if (header == 'Status') {
                final Color color = value == 'Approved'
                    ? Colors.green
                    : value == 'Pending'
                    ? Colors.orange
                    : Colors.red;
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: color.withAlpha(100),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    value,
                    style: TextStyle(
                      color: color,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              }
        
              if (header == 'Date') {
                return Text(
                  value,
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                );
              }
        
              if (header == 'Actions') {
                final bool isPending = item['status'] == 'Pending';
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.delete_outline,
                        size: 18,
                        color: Colors.redAccent,
                      ),
                      onPressed: () {
                        // Delete review logic
                      },
                      tooltip: 'Delete Review',
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.visibility_outlined,
                        size: 18,
                        color: Colors.blueGrey,
                      ),
                      onPressed: () {
                        // View full review details
                      },
                      tooltip: 'View Details',
                    ),
                    if (isPending) ...[
                      IconButton(
                        icon: const Icon(
                          Icons.check_circle_outline,
                          size: 18,
                          color: Colors.green,
                        ),
                        onPressed: () {
                          // Approve review logic
                        },
                        tooltip: 'Approve Review',
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.cancel_outlined,
                          size: 18,
                          color: Colors.red,
                        ),
                        onPressed: () {
                          // Reject review logic
                        },
                        tooltip: 'Reject Review',
                      ),
                    ],
                  ],
                );
              }
        
              return Text(value.toString());
            },
          ),
        ),
      ),
    );
  }
}
