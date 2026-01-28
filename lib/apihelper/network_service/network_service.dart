//
//
//
//
// import 'dart:async';
//
//
// import 'package:connectivity_plus/connectivity_plus.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:lottie/lottie.dart';
// import 'package:shimmer/shimmer.dart';
//
// import '../../../app_manager/utils/app_color.dart';
// import '../../../app_manager/getx_snackbar.dart';
//
//
//
// class NetworkService extends GetxService {
//   final Connectivity _connectivity = Connectivity();
//   RxBool isConnected = false.obs;
//
//   // Future<NetworkService> init() async {
//   //   _connectivity.onConnectivityChanged.listen(updateConnection);
//   //   return this;
//   // }
//
//
//
//
//   void updateConnection(ConnectivityResult result){
//     if(result == ConnectivityResult.none){
//      Get.showSnackbar(Ui.ErrorSnackBar(message: 'No Internet Connection'));
//      isConnected.value = false;
//      ShowWidgetOnConnectionChange().show();
//     }else{
//        Get.showSnackbar(Ui.SuccessSnackBar(message: 'Connection Restored'));
//        isConnected.value = true;
//        if(Get.isDialogOpen == true){
//           ShowWidgetOnConnectionChange().hide();
//        }
//
//     }
//   }
// }
//
//
//
// class ShowWidgetOnConnectionChangeController extends GetxController {
//   RxBool isBack = false .obs;
//
//  RxBool readValue(){
//     return isBack;
//   }
//
//   changeValue(val){
//     isBack = RxBool(val);
//      update();
//   }
//
//
// }
//
// class ShowWidgetOnConnectionChange{
//
//   final ShowWidgetOnConnectionChangeController widgetController =
//   Get.put(ShowWidgetOnConnectionChangeController ());
//
//    show( ){
//     widgetController.changeValue(true);
//     return noInternet( );
//   }
//
//   hide(){
//     if(widgetController.readValue().value){
//      Navigator.of(Get.overlayContext!).pop();
//       widgetController.changeValue(false);
//     }
//   }
// }
//
//
//  noInternet(){
//   return Get.dialog(
//       WillPopScope(
//         onWillPop: (){
//           return Future.value(false);
//         },
//         child: Container(
//           height: Get.height,
//           width: Get.width,
//           decoration:   BoxDecoration(
//             color: AppColor.primary
//             // image: DecorationImage(
//             //   image: AssetImage('assets/json/77124-nointernet.json'),
//             //   fit: BoxFit.fill,
//             // ),
//           ),
//           child: Scaffold(
//             backgroundColor: Colors.transparent,
//             body: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 Center(
//                   child: SizedBox( height: 300, child: Lottie.asset('assets/json/no_internet.json')),
//                 ),
//                 Center(
//                   child: shimmerEffect(
//                     shimmer: true,
//                     child: Text(
//                         'No Internet Connection',
//                         // style: MyTextTheme
//                         //     .mediumPCB
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 20),
//                 Center(
//                   child: Text('Please Enable Mobile Data Or Wifi',
//                     // style: MyTextTheme.mediumBCB.copyWith(
//                     //   color: Colors.black
//                     // ),
//                   ),
//                 ),
//
//               ],
//             ),
//
//           ),
//         ),
//       )
//   );
//  }
//
//   shimmerEffect({
//     required Widget child,
//     required bool shimmer,
//   }) {
//     return (shimmer)
//         ? Shimmer.fromColors(
//         baseColor: Colors.black, highlightColor: Colors.white, child: child)
//         : child;
//   }
