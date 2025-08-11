// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
//
// class CallbackNotifier {
//   final BuildContext context;
//   CallbackNotifier(this.context);
//
//   final _LoadingHandler _loader = _LoadingHandler();
//   final _AlertHandler _alert = _AlertHandler();
//
//   void showLoader([String? message]) => _loader.show(context, message: message ?? 'message');
//   void closeLoader() => _loader.close();
//
//   void showAlert([String? message]) => _alert.show(context, message: message ?? 'Alert');
//   void closeAlert() => _alert.close();
// }
//
// class _LoadingHandler {
//   static _LoadingHandler? _instance;
//   static BuildContext? _dialogContext;
//   static bool _isShowing = false;
//   static String _currentMessage = "";
//
//   _LoadingHandler._privateConstructor();
//
//   factory _LoadingHandler() {
//     _instance ??= _LoadingHandler._privateConstructor();
//     return _instance!;
//   }
//
//   /// Show the loading dialog
//   void show(BuildContext context, {required String message}) {
//     if (_isShowing) {
//       // Update the message if the dialog is already showing
//       _updateMessage(message);
//     } else {
//       _isShowing = true;
//       _currentMessage = message;
//
//       // Show the dialog
//       showDialog(
//         context: context,
//         barrierDismissible: false, // Prevent closing by tapping outside
//         builder: (BuildContext dialogContext) {
//           _dialogContext = dialogContext;
//           return PopScope(
//             canPop: false,
//             // onWillPop: () async => false, // Disable back button
//             child: AlertDialog(
//               content: Row(
//                 children: [
//                   CircularProgressIndicator(),
//                   SizedBox(width: 20),
//                   Expanded(
//                     child: Text(
//                       _currentMessage,
//                       key: ValueKey("loadingMessage"), // Unique key for updating message
//                       style: TextStyle(fontSize: 16),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           );
//         },
//       );
//     }
//   }
//
//   /// Close the loading dialog
//   void close() {
//     if (_isShowing && _dialogContext != null) {
//       Navigator.of(_dialogContext!).pop(); // Close the dialog
//       _dialogContext = null;
//       _isShowing = false;
//       _currentMessage = "";
//     }
//   }
//
//   /// Update the message of the currently shown dialog
//   void _updateMessage(String message) {
//     if (_dialogContext != null) {
//       _currentMessage = message;
//       // Trigger rebuild by marking the dialog as needing update
//       (_dialogContext as Element).markNeedsBuild();
//     }
//   }
// }
//
// class _AlertHandler {
//   static _AlertHandler? _instance;
//   static BuildContext? _dialogContext;
//   static bool _isShowing = false;
//
//   _AlertHandler._privateConstructor();
//
//   factory _AlertHandler() {
//     _instance ??= _AlertHandler._privateConstructor();
//     return _instance!;
//   }
//
//   /// Show the loading dialog
//   void show(BuildContext context, {required String message}) {
//     _isShowing = true;
//
//     // Show the dialog
//     showDialog(
//       context: context,
//       barrierDismissible: false, // Prevent closing by tapping outside
//       builder: (BuildContext dialogContext) {
//         _dialogContext = dialogContext;
//         return PopScope(
//           canPop: true,
//           // onWillPop: () async => false, // Disable back button
//           child: AlertDialog(
//             content: Center(
//               child: Text(
//                 message,
//                 key: ValueKey("Alert"), // Unique key for updating message
//                 style: TextStyle(fontSize: 16),
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
//
//   /// Close the loading dialog
//   void close() {
//     if (_isShowing && _dialogContext != null) {
//       Navigator.of(_dialogContext!).pop(); // Close the dialog
//       _dialogContext = null;
//       _isShowing = false;
//     }
//   }
// }
//
// class MyViewmodel extends ChangeNotifier {
//
//   Future onCreate(CallbackNotifier? callback) async {
//
//     callback?.showLoader("Starting...");
//
//     await Future.delayed(Duration(seconds: 2), (){
//       callback?.showLoader("Please wait...");
//       return;
//     });
//
//     await Future.delayed(Duration(seconds: 2), (){
//       callback?.closeLoader();
//       callback?.showAlert("Alert Start");
//       return;
//     });
//
//     await Future.delayed(Duration(seconds: 2), (){
//       callback?.closeLoader();
//       callback?.closeAlert();
//       callback?.showAlert("Alert 2");
//       return;
//     });
//
//     await Future.delayed(Duration(seconds: 2), (){
//       callback?.closeAlert();
//       return;
//     });
//
//   }
//
//
//
// }
//
// class TestPageNew extends StatelessWidget {
//   const TestPageNew({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final callback = CallbackNotifier(context);
//
//     return MultiProvider(
//         providers: [
//           ChangeNotifierProvider(create: (ctx) => MyViewmodel()),
//         ],
//         builder: (context, child){
//           final vm = Provider.of<MyViewmodel>(context);
//
//           return Scaffold(
//             body: Center(
//               child: TextButton(
//                   onPressed: ()=> vm.onCreate(callback),
//                   child: Text('Create')
//               ),
//             ),
//           );
//         }
//     );
//   }
//
// }
