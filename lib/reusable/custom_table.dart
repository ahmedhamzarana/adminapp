import 'package:flutter/material.dart';

class CustomTable extends StatelessWidget {
  final List<String> headers;
  final List<List<dynamic>> rows;

  const CustomTable({super.key, required this.headers, required this.rows});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal, // horizontal scroll if table wider
      child: IntrinsicWidth(
        child: Table(
          defaultColumnWidth: const IntrinsicColumnWidth(), // auto adjust per column
          border: TableBorder.all(color: Colors.grey.shade300),
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          children: [
            // HEADER ROW
            TableRow(
              decoration: BoxDecoration(color: Colors.grey.shade200),
              children: headers
                  .map(
                    (header) => Padding(
                      padding: const EdgeInsets.all(12),
                      child: Center(
                        child: Text(
                          header,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),

            // DATA ROWS
            ...rows.map(
              (row) => TableRow(
                children: row
                    .map(
                      (cell) => Padding(
                        padding: const EdgeInsets.all(12),
                        child: _buildCell(cell),
                      ),
                    )
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to decide if we show a Widget or a Text
  Widget _buildCell(dynamic cell) {
    if (cell is Widget) {
      return cell;
    }
    return Text(
      cell.toString(),
      style: const TextStyle(fontSize: 14),
    );
  }
}
