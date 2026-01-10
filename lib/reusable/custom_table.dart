import 'package:adminapp/utils/app_colors.dart';
import 'package:flutter/material.dart';

typedef RowBuilder = Widget Function(
  BuildContext context,
  String header,
  dynamic value,
  Map<String, dynamic> item,
);

class ResponsiveTableView extends StatelessWidget {
  final String title;
  final List<String> headers;
  final List<Map<String, dynamic>> data;
  final List<Widget> headerActions;
  final RowBuilder? rowBuilder;

  const ResponsiveTableView({
    super.key,
    required this.title,
    required this.headers,
    required this.data,
    this.headerActions = const [],
    this.rowBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        bool isMobile = constraints.maxWidth < 600;

        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 20,
                offset: const Offset(0, 4),
                spreadRadius: 0,
              ),
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 8,
                offset: const Offset(0, 2),
                spreadRadius: 0,
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildHeader(context),
              if (data.isEmpty)
                _buildEmptyState()
              else if (isMobile)
                _buildMobileList()
              else
                _buildDesktopTable(context),
            ],
          ),
        );
      },
    );
  }

  // --- Professional Header with Gradient ---
  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary,
            AppColors.primary.withOpacity(0.85),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              _getIconForTitle(title),
              color: Colors.white,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Colors.white,
              letterSpacing: 0.3,
            ),
          ),
          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.white.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Text(
              '${data.length} ${data.length == 1 ? 'item' : 'items'}',
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
          const Spacer(),
          ...headerActions.map((action) => Padding(
                padding: const EdgeInsets.only(left: 8),
                child: action,
              )),
        ],
      ),
    );
  }

  // --- Empty State ---
  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 80),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.inbox_outlined,
              size: 48,
              color: Colors.grey.shade400,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'No data available',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Add new items to see them here',
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }

  // --- Modern Desktop Table ---
  Widget _buildDesktopTable(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Container(
        constraints: BoxConstraints(
          minWidth: MediaQuery.of(context).size.width,
        ),
        child: Theme(
          data: Theme.of(context).copyWith(
            dividerColor: Colors.grey.shade100,
          ),
          child: DataTable(
            headingRowHeight: 52,
            dataRowMinHeight: 60,
            dataRowMaxHeight: 80,
            columnSpacing: 24,
            horizontalMargin: 24,
            headingRowColor: WidgetStateProperty.all(
              Colors.grey.shade50,
            ),
            dataRowColor: WidgetStateProperty.resolveWith<Color>(
              (Set<WidgetState> states) {
                if (states.contains(WidgetState.hovered)) {
                  return AppColors.primary.withOpacity(0.04);
                }
                return Colors.transparent;
              },
            ),
            columns: headers.map((h) {
              return DataColumn(
                label: Row(
                  children: [
                    Text(
                      h.toUpperCase(),
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        color: Colors.grey.shade700,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
            rows: data.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              
              return DataRow(
                cells: headers.map((header) {
                  final key = _getKeyFromHeader(header);
                  final value = item[key] ?? '-';
                  return DataCell(
                    rowBuilder != null
                        ? rowBuilder!(context, header, value, item)
                        : Text(
                            value.toString(),
                            style: TextStyle(
                              color: Colors.grey.shade800,
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                  );
                }).toList(),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  // --- Enhanced Mobile Cards ---
  Widget _buildMobileList() {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(16),
      itemCount: data.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final item = data[index];
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.grey.shade200,
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(12),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        '#${index + 1}',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Icon(
                      Icons.more_vert,
                      size: 18,
                      color: Colors.grey.shade400,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: headers.map((header) {
                    final key = _getKeyFromHeader(header);
                    final value = item[key] ?? '-';
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 2,
                            child: Text(
                              header,
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.grey.shade600,
                                fontSize: 12,
                                letterSpacing: 0.3,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            flex: 3,
                            child: rowBuilder != null
                                ? rowBuilder!(context, header, value, item)
                                : Text(
                                    value.toString(),
                                    textAlign: TextAlign.right,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: Colors.grey.shade800,
                                      fontSize: 13,
                                    ),
                                  ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  String _getKeyFromHeader(String header) =>
      header.toLowerCase().replaceAll(' ', '_');

  IconData _getIconForTitle(String title) {
    final lowerTitle = title.toLowerCase();
    if (lowerTitle.contains('product') || lowerTitle.contains('inventory')) {
      return Icons.inventory_2_outlined;
    } else if (lowerTitle.contains('order')) {
      return Icons.shopping_bag_outlined;
    } else if (lowerTitle.contains('review')) {
      return Icons.star_outline;
    } else if (lowerTitle.contains('user') || lowerTitle.contains('customer')) {
      return Icons.people_outline;
    }
    return Icons.table_chart_outlined;
  }
}