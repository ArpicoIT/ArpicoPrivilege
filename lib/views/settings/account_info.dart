import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../app/app_routes.dart';
import '../../core/utils/validates.dart';
import '../../shared/components/buttons/primary_button.dart';
import '../../shared/components/form/form_widgets.dart';
import '../../shared/customize/custom_toast.dart';
import '../../viewmodels/settings/account_info_viewmodel.dart';

class AccountInfoView extends StatefulWidget {
  const AccountInfoView({super.key});

  @override
  State<AccountInfoView> createState() => _AccountInfoViewState();
}

class _AccountInfoViewState extends State<AccountInfoView> {
  late AccountInfoViewmodel viewmodel;

  final double kLabelWidth = 84.0;

  final Map<String, String> snackBarMessages = {
    "birthday":
        "Birthday is auto-generated from your NIC and cannot be changed.",
    "nic": "This NIC is linked to your account and cannot be modified.",
    "mobile":
        "This mobile number is linked to your account and cannot be modified.",
  };

  @override
  void initState() {
    viewmodel = AccountInfoViewmodel()..setContext(context);
    super.initState();
  }

  void _updateButtonState() {
    // for future development
  }

  // Widget for section titles
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Text(
        title,
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildDropdownField({
    String? selectedValue,
    required List<String> options,
    required ValueChanged<String?> onChanged,
    InputDecoration? decoration,
    FocusNode? focusNode,
  }) =>
      DropdownButtonFormField<String>(
        value: (selectedValue ?? "").isEmpty ? null : selectedValue,
        focusNode: focusNode,
        decoration: decoration,
        items: options.map((option) {
          return DropdownMenuItem<String>(
            value: option,
            child: Text(option),
          );
        }).toList(),
        onChanged: onChanged,
      );

  Widget _buildLabel(String label) =>
      SizedBox(width: kLabelWidth, child: Text(label));

  Widget? _buildSuffixIcon(String key) =>
      (viewmodel.controllers[key] ?? TextEditingController()).text.isNotEmpty
          ? Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Icon(Icons.check_circle, color: Colors.green, size: 24),
            )
          : null;

  void onTapFieldInfo(String key) {
    final toast = CustomToast.of(context);
    toast.showWithAction(snackBarMessages[key]!, "Need Help?",
        () => Navigator.of(context).pushNamed(AppRoutes.helpCenter));
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final mediaQuery = MediaQuery.of(context);

    return Scaffold(
      appBar: AppBar(title: Text("Account Information"), centerTitle: true),
      body: ChangeNotifierProvider(
        create: (context) => viewmodel,
        child: Consumer<AccountInfoViewmodel>(builder: (context, vm, child) {
          return SingleChildScrollView(
            child: GestureDetector(
              onTap: vm.unFocusBackground,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 24),
                    child: Column(
                      children: [
                        // Text("We Value Your Feedback",
                        //     style: textTheme.headlineMedium
                        //         ?.copyWith(fontWeight: FontWeight.w600)),
                        //
                        // const SizedBox(height: 12),
                        Text(
                            "View and update your personal details to keep your account up to date."),
                      ],
                    ),
                  ),
                  // const SizedBox(height: 12),
                  Form(
                    key: vm.formKey,
                    child: Builder(builder: (context) {
                      final personalInfo = Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _buildSectionTitle("Basic Details"),
                          // LayoutBuilder(builder: (context, constraints) {
                          //   return Column(
                          //     crossAxisAlignment: CrossAxisAlignment.start,
                          //     children: [
                          //       SizedBox(
                          //         width: constraints.maxWidth * 0.68,
                          //         child: _buildDropdownField(
                          //           focusNode: vm.focusNodes["title"],
                          //           selectedValue:
                          //           vm.selectedItems["title"],
                          //           onChanged: (value) => setState(() {
                          //             vm.unFocusBackground();
                          //             vm.selectedItems["title"] =
                          //             value!;
                          //           }),
                          //           options: vm.titleOptions,
                          //           decoration: InputDecoration(
                          //               icon: _buildLabel("Title"),
                          //               hintText: "Select your title"
                          //           ),
                          //         ),
                          //       ),
                          //       const SizedBox(height: 16),
                          //       SizedBox(
                          //         width: constraints.maxWidth * 0.68,
                          //         child: _buildDropdownField(
                          //           focusNode: vm.focusNodes["gender"],
                          //           selectedValue:
                          //           vm.selectedItems["gender"],
                          //           onChanged: (value) => setState(() {
                          //             vm.unFocusBackground();
                          //             vm.selectedItems["gender"] =
                          //             value!;
                          //           }),
                          //           options: vm.genderOptions,
                          //           decoration: InputDecoration(
                          //               icon: _buildLabel("Gender"),
                          //               hintText: "Select your gender"
                          //           ),
                          //         ),
                          //       ),
                          //     ],
                          //   );
                          // }),
                          _buildDropdownField(
                            focusNode: vm.focusNodes["title"],
                            selectedValue: vm.selectedItems["title"],
                            onChanged: (value) => setState(() {
                              vm.unFocusBackground();
                              vm.selectedItems["title"] = value!;
                            }),
                            options: vm.titleOptions,
                            decoration: InputDecoration(
                                icon: _buildLabel("Title"),
                                hintText: "Select your title"),
                          ),
                          const SizedBox(height: 16),
                          _buildDropdownField(
                            focusNode: vm.focusNodes["gender"],
                            selectedValue: vm.selectedItems["gender"],
                            onChanged: (value) => setState(() {
                              vm.unFocusBackground();
                              vm.selectedItems["gender"] = value!;
                            }),
                            options: vm.genderOptions,
                            decoration: InputDecoration(
                                icon: _buildLabel("Gender"),
                                hintText: "Select your gender"),
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: vm.controllers["firstName"],
                            focusNode: vm.focusNodes["firstName"],
                            keyboardType: TextInputType.text,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            decoration: InputDecoration(
                                icon: _buildLabel("First Name"),
                                hintText: "Enter your first name"),
                            validator: (value) => Validates.byInputType(
                                value, TextInputType.name),
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: vm.controllers["lastName"],
                            focusNode: vm.focusNodes["lastName"],
                            keyboardType: TextInputType.text,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            decoration: InputDecoration(
                                icon: _buildLabel("Last Name"),
                                hintText: "Enter your last name"),
                            validator: (value) => Validates.byInputType(
                                value, TextInputType.name),
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: vm.controllers["birthday"],
                            focusNode: vm.focusNodes["birthday"],
                            style: TextStyle(color: Colors.grey),
                            onTap: () => onTapFieldInfo("birthday"),
                            decoration: InputDecoration(
                                icon: _buildLabel("Birthday"),
                                suffixIcon: _buildSuffixIcon("birthday"),
                                hintText: "e.g. 1995-01-01"),
                            readOnly: true,
                          ),
                        ],
                      );

                      final contact = Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _buildSectionTitle("Contact Details"),
                          TextFormField(
                            controller: vm.controllers["nic"],
                            focusNode: vm.focusNodes["nic"],
                            style: TextStyle(color: Colors.grey),
                            onTap: () => onTapFieldInfo("nic"),
                            decoration: InputDecoration(
                                icon: _buildLabel("NIC"),
                                suffixIcon: _buildSuffixIcon("nic"),
                                hintText: "Enter your NIC (e.g., 199512345V)"),
                            readOnly: true,
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: vm.controllers["mobile"],
                            focusNode: vm.focusNodes["mobile"],
                            style: TextStyle(color: Colors.grey),
                            onTap: () => onTapFieldInfo("mobile"),
                            decoration: InputDecoration(
                                icon: _buildLabel("Mobile"),
                                suffixIcon: _buildSuffixIcon("mobile"),
                                hintText: "Enter your mobile number"),
                            readOnly: true,
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: vm.controllers["email"],
                            focusNode: vm.focusNodes["email"],
                            keyboardType: TextInputType.emailAddress,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            decoration: InputDecoration(
                              icon: _buildLabel("Email"),
                              suffixIcon:
                                  FormWidgets.verificationIndicatorBuilder(
                                      context,
                                      stateListener: vm.emailStatusNotifier,
                                      hintText: 'email address', onPressed: () {
                                final focus = vm.focusNodes["email"]!;
                                if (focus.hasFocus) {
                                  focus.unfocus();
                                }
                                vm.verifyEmail();
                              }),
                            ),
                            validator: (value) => Validates.byInputType(
                                value, TextInputType.emailAddress, false),
                          ),
                        ],
                      );

                      final address = Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _buildSectionTitle("Residential Address"),
                          TextFormField(
                            controller: vm.controllers["address1"],
                            focusNode: vm.focusNodes["address1"],
                            keyboardType: TextInputType.streetAddress,
                            decoration:
                                InputDecoration(icon: _buildLabel("Address 1")),
                            validator: (value) => Validates.byInputType(
                                value, TextInputType.streetAddress, false),
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: vm.controllers["address2"],
                            focusNode: vm.focusNodes["address2"],
                            keyboardType: TextInputType.streetAddress,
                            decoration: InputDecoration(
                              icon: _buildLabel("Address 2"),
                            ),
                            validator: (value) => Validates.byInputType(
                                value, TextInputType.streetAddress, false),
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: vm.controllers["address3"],
                            focusNode: vm.focusNodes["address3"],
                            keyboardType: TextInputType.streetAddress,
                            decoration: InputDecoration(
                              icon: _buildLabel("Address 3"),
                            ),
                            validator: (value) => Validates.byInputType(
                                value, TextInputType.streetAddress, false),
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: vm.controllers["city"],
                            focusNode: vm.focusNodes["city"],
                            keyboardType: TextInputType.streetAddress,
                            decoration: InputDecoration(
                              icon: _buildLabel("City"),
                            ),
                          ),
                        ],
                      );

                      return Column(
                        children: List.generate(
                          [personalInfo, contact, address].length,
                          (i) => Column(
                            children: [
                              if (i != 0)
                                Divider(
                                  height: 16,
                                  thickness: 16,
                                  color: colorScheme.surfaceContainerLowest,
                                ),
                              Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: 16, horizontal: 16),
                                // color: colorScheme.primary,
                                // margin: EdgeInsets.only(top: i == 0 ? 0 : 16),
                                child: [personalInfo, contact, address][i],
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 24),
                    child: ValueListenableBuilder(
                        valueListenable: vm.buttonNotifier,
                        builder: (context, value, child) {
                          return PrimaryButton.filled(
                            text: "Update",
                            onPressed: vm.onUpdate,
                            width: double.infinity,
                            enable: value,
                          );
                        }),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
