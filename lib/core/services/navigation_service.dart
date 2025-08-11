

// class NavigationService {
//   final BuildContext context;
//   NavigationService(this.context);
//
//   Future push(Widget page) async {
//     try {
//       await Navigator.of(context).push(MaterialPageRoute(builder: (context) => page));
//     } catch (e){
//       print(e.toString());
//     }
//   }
//
//   Future pushNamed(String routeName, {Object? arguments}) async {
//     try {
//       await Navigator.of(context).pushNamed(routeName, arguments: arguments);
//     } catch (e){
//       print(e.toString());
//     }
//   }
//
//   void pop([dynamic result]) {
//     try {
//       Navigator.of(context).pop(result);
//     } catch (e){
//       print(e.toString());
//     }
//   }
//
//   static Future pushNamed2(BuildContext context, String routeName, {Object? arguments}) async {
//     try {
//       await Navigator.of(context).pushNamed(routeName, arguments: arguments);
//     } catch (e){
//       print(e.toString());
//     }
//   }
//
//   static void pop2(BuildContext context, [dynamic result]) {
//     try {
//       Navigator.of(context).pop(result);
//     } catch (e){
//       print(e.toString());
//     }
//   }
// }
