import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../components/buttons/primary_button.dart';
import '../draggable_bottom_sheet.dart';


class EBillFilter extends StatefulWidget {
  final Map<String, dynamic>? initialValue;
  final ScrollController? scrollController;
  final Function(Map<String, dynamic>)? onFiltered;

  const EBillFilter({super.key, this.initialValue, this.scrollController, this.onFiltered});

  static Future<T?> show<T extends Map<String, dynamic>>(
      BuildContext context, {
        T? initialValue,
      }) async {
    // GlobalKey of EBillFilter
    final filterKey = GlobalKey<_EBillFilterState>();

    return await DraggableBottomSheet.show<T>(
      context: context,
      title: "Filters",
      onReset: (){
        filterKey.currentState?.resetFilters();
      },
      builder: (ctx, scl) {
        return EBillFilter(
          key: filterKey,
          initialValue: initialValue,
          scrollController: scl,
          onFiltered: (value) => DraggableBottomSheet.close(context, value),
        );
      },
    );
  }

  @override
  State<EBillFilter> createState() => _EBillFilterState();
}

class _EBillFilterState extends State<EBillFilter> {
  final double kLabelWidth = 84.0;
  late final Map<String, Map<String, dynamic>> fields;

  Map<String, dynamic>? initialValue;

  @override
  void initState() {
    super.initState();
    initialValue = widget.initialValue;
    fields = {
      "ebillNo": _generateField("E-Bill No.", initialValue?["ebillNo"] ?? "", "Enter eBill number"),
      "receiptNo": _generateField("Receipt No.", initialValue?["receiptNo"] ?? "", "Enter receipt number"),
      "curDate": _generateField("Date", initialValue?["curDate"] ?? "", "Select date"),
    };
  }

  Map<String, dynamic> _generateField(String label, String initialValue, String hintText) {
    return {
      "label": label,
      "controller": TextEditingController(text: initialValue),
      "focusNode": FocusNode(),
      "hintText": hintText
    };
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: widget.scrollController,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildTextField("ebillNo", keyboardType: TextInputType.number),
          _buildTextField("receiptNo", keyboardType: TextInputType.number),
          _buildDatePickerField("curDate"),
          const SizedBox(height: 24),

          PrimaryButton.filled(text: "Filter", onPressed: ()=> widget.onFiltered?.call(fields.map(
                (key, value) => MapEntry(key, (value["controller"] as TextEditingController).text),
          ))),
        ],
      ),
    );
  }

  Widget _buildTextField(String key, {bool readOnly = false, TextInputType? keyboardType}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        controller: fields[key]!["controller"] as TextEditingController,
        focusNode: fields[key]!["focusNode"] as FocusNode,
        readOnly: readOnly,
        keyboardType: keyboardType,
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          hintText: fields[key]!["hintText"] as String,
          icon: SizedBox(width: kLabelWidth, child: Text(fields[key]!["label"] as String)),
        ),
      ),
    );
  }

  Widget _buildDatePickerField(String key) {
    final TextEditingController controller = fields[key]!["controller"] as TextEditingController;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        controller: controller,
        focusNode: fields[key]!["focusNode"] as FocusNode,
        readOnly: true,
        decoration: InputDecoration(
          hintText: fields[key]!["hintText"] as String,
          icon: SizedBox(width: kLabelWidth, child: Text(fields[key]!["label"] as String)),
          border: const OutlineInputBorder(),
          suffixIcon: const Icon(Icons.calendar_today),
        ),
        onTap: () async {
          unFocusAll();
          final pickedDate = await _selectDate(DateTime.tryParse(controller.text));
          if (pickedDate != null) {
            controller.text = DateFormat('yyyy-MM-dd').format(pickedDate);
          }
        },
      ),
    );
  }

  Future<DateTime?> _selectDate(DateTime? initialDate) async {
    return await showDatePicker(
      context: context,
      initialDate: initialDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
  }

  void unFocusAll() {
    for (var field in fields.values) {
      (field["focusNode"] as FocusNode).unfocus();
    }
    FocusScope.of(context).unfocus();
  }

  void resetFilters() {
    for (var field in fields.values) {
      (field["controller"] as TextEditingController).clear();
    }
  }
}





/*
class KeyboardResponsiveDraggableSheet extends StatefulWidget {
  const KeyboardResponsiveDraggableSheet({super.key});

  @override
  State<KeyboardResponsiveDraggableSheet> createState() => _KeyboardResponsiveDraggableSheetState();
}

class _KeyboardResponsiveDraggableSheetState
    extends State<KeyboardResponsiveDraggableSheet>
    with WidgetsBindingObserver {
  double bottomPadding = 0.0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    final bottomInset = WidgetsBinding.instance.window.viewInsets.bottom;
    // final bottomInset = View.of(context).viewInsets.bottom;
    setState(() {
      bottomPadding = bottomInset; // Exactly matches keyboard height
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: bottomPadding), // No extra gaps
      child: DraggableScrollableSheet(
        initialChildSize: 0.5, // Start at 50% height
        minChildSize: 0.5, // Minimum height (50%)
        maxChildSize: 1.0, // Can expand to full screen
        expand: false,
        builder: (context, scrollController) {
          return GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(), // Hide keyboard on tap outside
            child: Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              ),
              child: Column(
                children: [
                  Container(
                    width: 50,
                    height: 5,
                    margin: EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                      color: Colors.grey[400],
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      controller: scrollController, // Enables scrolling
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Enter Details",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold)),
                          SizedBox(height: 16),
                          TextField(
                            autofocus: true,
                            decoration: InputDecoration(
                              labelText: "Your Name",
                              border: OutlineInputBorder(),
                            ),
                          ),
                          SizedBox(height: 16),
                          TextField(
                            decoration: InputDecoration(
                              labelText: "Your Email",
                              border: OutlineInputBorder(),
                            ),
                          ),
                          SizedBox(height: 16),
                          TextField(
                            decoration: InputDecoration(
                              labelText: "Your Email",
                              border: OutlineInputBorder(),
                            ),
                          ),
                          SizedBox(height: 16),
                          TextField(
                            decoration: InputDecoration(
                              labelText: "Your Email",
                              border: OutlineInputBorder(),
                            ),
                          ),
                          SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text("Submit"),
                          ),
                        ],
                      ),
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
}*/
