import 'package:adminapp/utils/app_colors.dart';
import 'package:flutter/material.dart';

typedef RowBuilder =
    Widget Function(
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
        // Switch to Mobile View if width is less than 600px
        bool isMobile = constraints.maxWidth < 600;

        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade200),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildHeader(context),
              if (isMobile) _buildMobileList() else _buildDesktopTable(context),
            ],
          ),
        );
      },
    );
  }

  // --- Header UI ---
  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
        border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Row(
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.secondary,
            ),
          ),
          const Spacer(),
          ...headerActions,
        ],
      ),
    );
  }

  // --- Desktop Table View ---
  Widget _buildDesktopTable(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        headingRowHeight: 56,
        dataRowMaxHeight: 64,
        columnSpacing: 40,
        headingRowColor: WidgetStateProperty.all(Colors.transparent),
        columns: headers
            .map(
              (h) => DataColumn(
                label: Text(
                  h.toUpperCase(),
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: Colors.grey.shade600,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            )
            .toList(),
        rows: data.map((item) {
          return DataRow(
            cells: headers.map((header) {
              final key = _getKeyFromHeader(header);
              final value = item[key] ?? '-';
              return DataCell(
                rowBuilder != null
                    ? rowBuilder!(context, header, value, item)
                    : Text(
                        value.toString(),
                        style: const TextStyle(color: Colors.black87),
                      ),
              );
            }).toList(),
          );
        }).toList(),
      ),
    );
  }

  // --- Mobile Card View ---
  Widget _buildMobileList() {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: data.length,
      separatorBuilder: (_, __) =>
          Divider(height: 1, color: Colors.grey.shade100),
      itemBuilder: (context, index) {
        final item = data[index];
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: headers.map((header) {
              final key = _getKeyFromHeader(header);
              final value = item[key] ?? '-';
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      header,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade500,
                        fontSize: 13,
                      ),
                    ),
                    Flexible(
                      child: rowBuilder != null
                          ? rowBuilder!(context, header, value, item)
                          : Text(
                              value.toString(),
                              textAlign: TextAlign.right,
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }

  String _getKeyFromHeader(String header) =>
      header.toLowerCase().replaceAll(' ', '_');
}
