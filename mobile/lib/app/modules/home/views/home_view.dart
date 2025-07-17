// // import 'package:flutter/material.dart';

// // import 'package:get/get.dart';
// // import 'package:get_storage/get_storage.dart';
// // import 'package:http/http.dart' as http;
// // import 'package:mobile/app/modules/keranjang/controllers/keranjang_controller.dart';

// // import 'package:mobile/app/routes/app_pages.dart';
// // import 'package:mobile/constant/base_url.dart';

// // import 'package:mobile/thema.dart';
// // import '../controllers/home_controller.dart';

// // class HomeView extends GetView<HomeController> {
// //   const HomeView({super.key});

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       body: ListView(
// //         padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
// //         children: [
// //           Row(
// //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //             children: [
// //               Obx(
// //                 () => Text(
// //                   'Welcome, ${controller.name.value}',
// //                   style: BlackTextStyle.copyWith(fontSize: 20),
// //                 ),
// //               ),
// //               IconButton(
// //                 onPressed: () {
// //                   Get.defaultDialog(
// //                     title: 'Logout',
// //                     middleText: 'Yakin ingin logout?',
// //                     textCancel: 'Batal',
// //                     textConfirm: 'Logout',
// //                     confirmTextColor: Colors.white,
// //                     // onConfirm: () {
// //                     //   final box = GetStorage();
// //                     //   final keranjangC = Get.find<KeranjangController>();
// //                     //   keranjangC.kosongkanMemori();
// //                     //   box.remove('token');
// //                     //   box.remove('name');
// //                     //   box.remove('email');
// //                     //   box.remove('role');
// //                     //   Get.offAllNamed(Routes.LOGIN);
// //                     // },
// //                     onConfirm: () async {
// //                       final box = GetStorage();
// //                       final token = box.read('token');

// //                       try {
// //                         final res = await http.post(
// //                           Uri.parse('$bASEURL/api/auth/logout'),
// //                           headers: {
// //                             'Content-Type': 'application/json',
// //                             'Authorization': 'Bearer $token',
// //                           },
// //                         );

// //                         if (res.statusCode == 200) {
// //                           print(
// //                             '✅ Logout dan hapus FCM token berhasil di backend',
// //                           );
// //                         } else {
// //                           print('⚠️ Gagal hapus FCM token di backend');
// //                         }
// //                       } catch (e) {
// //                         print('❌ Error logout backend: $e');
// //                       }

// //                       final keranjangC = Get.find<KeranjangController>();
// //                       keranjangC.kosongkanMemori();

// //                       box.remove('token');
// //                       box.remove('name');
// //                       box.remove('email');
// //                       box.remove('role');

// //                       Get.offAllNamed(Routes.LOGIN);
// //                     },
// //                   );
// //                 },
// //                 icon: Icon(Icons.logout, size: 30, color: KCoklatColor),
// //               ),
// //               IconButton(
// //                 onPressed: () {
// //                   Get.toNamed(Routes.KERANJANG);
// //                 },
// //                 icon: Icon(Icons.shopping_cart, size: 30, color: KCoklatColor),
// //               ),
// //             ],
// //           ),
// //           const SizedBox(height: 5),
// //           Container(
// //             width: double.infinity,
// //             height: 50,
// //             decoration: BoxDecoration(
// //               borderRadius: BorderRadius.circular(15),
// //               color: KWhiteGreyColor,
// //             ),
// //             child: TextField(
// //               controller:
// //                   controller.searchController, // ✅ pakai controller di sini
// //               onChanged: (value) => controller.searchText.value = value,
// //               decoration: InputDecoration(
// //                 contentPadding: const EdgeInsets.symmetric(
// //                   horizontal: 10,
// //                   vertical: 12,
// //                 ),
// //                 prefixIcon: const Icon(Icons.search),
// //                 suffixIcon: Obx(
// //                   () => controller.searchText.value.isNotEmpty
// //                       ? IconButton(
// //                           icon: const Icon(Icons.clear),
// //                           onPressed: () {
// //                             controller.searchController
// //                                 .clear(); // ✅ hapus teks tampilan
// //                             controller.searchText.value = ''; // ✅ reset filter
// //                           },
// //                         )
// //                       : const SizedBox(),
// //                 ),
// //                 hintText: 'Cari Produk',
// //                 border: InputBorder.none,
// //               ),
// //             ),
// //           ),
// //           SizedBox(height: 20),

// //           //produk tampil disini
// //           Obx(() {
// //             if (controller.isLoading.value) {
// //               return const Center(child: CircularProgressIndicator());
// //             }

// //             if (controller.filteredProducts.isEmpty) {
// //               return const Center(child: Text('Produk tidak ditemukan'));
// //             }

// //             return GridView.builder(
// //               shrinkWrap: true,
// //               physics: const NeverScrollableScrollPhysics(),
// //               itemCount: controller.filteredProducts.length,
// //               gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
// //                 crossAxisCount: 2,
// //                 mainAxisSpacing: 20,
// //                 crossAxisSpacing: 20,
// //                 childAspectRatio: 3 / 3.6,
// //               ),
// //               itemBuilder: (context, index) {
// //                 final product =
// //                     controller.filteredProducts[index]; // ✅ yang dicari
// //                 return GestureDetector(
// //                   onTap: () {
// //                     Get.toNamed(Routes.DETAIL_PRODUK, arguments: product);
// //                   },
// //                   child: Container(
// //                     decoration: BoxDecoration(
// //                       borderRadius: BorderRadius.circular(20),
// //                       color: KCok,
// //                     ),
// //                     child: Padding(
// //                       padding: const EdgeInsets.symmetric(
// //                         horizontal: 8,
// //                         vertical: 15,
// //                       ),
// //                       child: Column(
// //                         crossAxisAlignment: CrossAxisAlignment.start,
// //                         children: [
// //                           Center(
// //                             child: Container(
// //                               width: 120,
// //                               height: 120,
// //                               decoration: BoxDecoration(
// //                                 borderRadius: BorderRadius.circular(20),
// //                                 color: KWhiteGreyColor,
// //                               ),
// //                               child: ClipRRect(
// //                                 borderRadius: BorderRadius.circular(20),
// //                                 child: Image.network(
// //                                   product.fullImageUrl,
// //                                   fit: BoxFit.cover,
// //                                   errorBuilder: (context, error, stackTrace) =>
// //                                       const Icon(Icons.broken_image),
// //                                 ),
// //                               ),
// //                             ),
// //                           ),
// //                           const SizedBox(height: 6),
// //                           Text(
// //                             product.name,
// //                             style: WhiteTextStyle.copyWith(
// //                               fontSize: 16,
// //                               fontWeight: bold,
// //                             ),
// //                             overflow: TextOverflow.ellipsis,
// //                           ),
// //                         ],
// //                       ),
// //                     ),
// //                   ),
// //                 );
// //               },
// //             );
// //           }),

// //         ],
// //       ),
// //     );
// //   }
// // }

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:get_storage/get_storage.dart';
// import 'package:http/http.dart' as http;

// import 'package:mobile/app/modules/keranjang/controllers/keranjang_controller.dart';
// import 'package:mobile/app/routes/app_pages.dart';
// import 'package:mobile/constant/base_url.dart';
// import 'package:mobile/thema.dart';
// import '../controllers/home_controller.dart';

// class HomeView extends GetView<HomeController> {
//   const HomeView({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: ListView(
//         padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Obx(
//                 () => Text(
//                   'Hello, ${controller.name.value}',
//                   style: BlackTextStyle.copyWith(fontSize: 17),
//                 ),
//               ),
//               IconButton(
//                 onPressed: () {
//                   Get.defaultDialog(
//                     title: 'Logout',
//                     middleText: 'Yakin ingin logout?',
//                     textCancel: 'Batal',
//                     textConfirm: 'Logout',
//                     confirmTextColor: Colors.white,
//                     onConfirm: () async {
//                       final box = GetStorage();
//                       final token = box.read('token');

//                       try {
//                         final res = await http.post(
//                           Uri.parse('$bASEURL/api/auth/logout'),
//                           headers: {
//                             'Content-Type': 'application/json',
//                             'Authorization': 'Bearer $token',
//                           },
//                         );
//                         if (res.statusCode == 200) {
//                           print(
//                             '✅ Logout dan hapus FCM token berhasil di backend',
//                           );
//                         }
//                       } catch (e) {
//                         print('❌ Error logout backend: $e');
//                       }

//                       final keranjangC = Get.find<KeranjangController>();
//                       keranjangC.kosongkanMemori();

//                       box.remove('token');
//                       box.remove('name');
//                       box.remove('email');
//                       box.remove('role');

//                       Get.offAllNamed(Routes.LOGIN);
//                     },
//                   );
//                 },
//                 icon: Icon(Icons.logout, size: 30, color: KCoklatColor),
//               ),
//               IconButton(
//                 onPressed: () {
//                   Get.toNamed(Routes.KERANJANG);
//                 },
//                 icon: Icon(Icons.shopping_cart, size: 30, color: KCoklatColor),
//               ),
//             ],
//           ),
//           const SizedBox(height: 5),
//           Container(
//             width: double.infinity,
//             height: 50,
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(15),
//               color: KWhiteGreyColor,
//             ),
//             child: TextField(
//               controller: controller.searchController,
//               onChanged: (value) => controller.searchText.value = value,
//               decoration: InputDecoration(
//                 contentPadding: const EdgeInsets.symmetric(
//                   horizontal: 10,
//                   vertical: 12,
//                 ),
//                 prefixIcon: const Icon(Icons.search),
//                 suffixIcon: Obx(
//                   () => controller.searchText.value.isNotEmpty
//                       ? IconButton(
//                           icon: const Icon(Icons.clear),
//                           onPressed: () {
//                             controller.searchController.clear();
//                             controller.searchText.value = '';
//                           },
//                         )
//                       : const SizedBox(),
//                 ),
//                 hintText: 'Cari Produk',
//                 border: InputBorder.none,
//               ),
//             ),
//           ),
//           // const SizedBox(height: 20),
//           Obx(() {
//             if (controller.isLoading.value) {
//               return const Center(child: CircularProgressIndicator());
//             }

//             if (controller.filteredProducts.isEmpty) {
//               return const Center(child: Text('Produk tidak ditemukan'));
//             }

//             return GridView.builder(
//               shrinkWrap: true,
//               physics: const NeverScrollableScrollPhysics(),
//               itemCount: controller.filteredProducts.length,
//               gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                 crossAxisCount: 2,
//                 mainAxisSpacing: 20,
//                 crossAxisSpacing: 20,
//                 childAspectRatio: 3 / 3.7,
//               ),
//               itemBuilder: (context, index) {
//                 final product = controller.filteredProducts[index];
//                 return GestureDetector(
//                   onTap: () {
//                     Get.toNamed(Routes.DETAIL_PRODUK, arguments: product);
//                   },
//                   child: Container(
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(20),
//                       color: KCok,
//                     ),
//                     child: Padding(
//                       padding: const EdgeInsets.symmetric(
//                         horizontal: 8,
//                         vertical: 15,
//                       ),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Center(
//                             child: Container(
//                               width: 120,
//                               height: 110,
//                               decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.circular(20),
//                                 color: KWhiteGreyColor,
//                               ),
//                               child: ClipRRect(
//                                 borderRadius: BorderRadius.circular(20),
//                                 child: Image.network(
//                                   product.fullImageUrl,
//                                   fit: BoxFit.cover,
//                                   errorBuilder: (context, error, stackTrace) =>
//                                       const Icon(Icons.broken_image),
//                                 ),
//                               ),
//                             ),
//                           ),
//                           const SizedBox(height: 8),
//                           Text(
//                             product.name,
//                             style: WhiteTextStyle.copyWith(
//                               fontSize: 14,
//                               fontWeight: bold,
//                             ),
//                             overflow: TextOverflow.ellipsis,
//                           ),

//                           Text(
//                             'Rp ${product.harga}',
//                             style: WhiteTextStyle.copyWith(
//                               fontSize: 10,
//                               fontWeight: FontWeight.w500,
//                               color: Colors.white70,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 );
//               },
//             );
//           }),
//         ],
//       ),

//       // 🔻 Bottom Navigation Bar
//       bottomNavigationBar: Obx(
//         () => Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
//           child: ClipRRect(
//             borderRadius: BorderRadius.circular(20),
//             child: BottomNavigationBar(
//               backgroundColor: KCoklatColor.withOpacity(0.95),
//               selectedItemColor: Colors.white,
//               unselectedItemColor: Colors.white70,
//               currentIndex: controller.currentIndex.value,
//               onTap: (index) {
//                 controller.currentIndex.value = index;
//                 switch (index) {
//                   case 0:
//                     break;
//                   case 1:
//                     Get.toNamed(Routes.HISTORY);
//                     break;
//                   case 2:
//                     Get.toNamed(Routes.PROFILE);
//                     break;
//                 }
//               },
//               items: const [
//                 BottomNavigationBarItem(
//                   icon: Icon(Icons.home_outlined),
//                   activeIcon: Icon(Icons.home),
//                   label: 'Home',
//                 ),
//                 BottomNavigationBarItem(
//                   icon: Icon(Icons.history_outlined),
//                   activeIcon: Icon(Icons.history),
//                   label: 'Riwayat',
//                 ),
//                 BottomNavigationBarItem(
//                   icon: Icon(Icons.person_outline),
//                   activeIcon: Icon(Icons.person),
//                   label: 'Profil',
//                 ),
//               ],
//               type: BottomNavigationBarType.fixed,
//               elevation: 10,
//               selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import 'package:mobile/app/modules/keranjang/controllers/keranjang_controller.dart';
import 'package:mobile/app/routes/app_pages.dart';
import 'package:mobile/constant/base_url.dart';
import 'package:mobile/thema.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 40.h),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Obx(
                () => Text(
                  'Hello, ${controller.name.value}',
                  style: BlackTextStyle.copyWith(fontSize: 17.sp),
                ),
              ),
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Get.defaultDialog(
                        title: 'Logout',
                        middleText: 'Yakin ingin logout?',
                        textCancel: 'Batal',
                        textConfirm: 'Logout',
                        confirmTextColor: Colors.white,
                        onConfirm: () async {
                          final box = GetStorage();
                          final token = box.read('token');

                          try {
                            final res = await http.post(
                              Uri.parse('$bASEURL/api/auth/logout'),
                              headers: {
                                'Content-Type': 'application/json',
                                'Authorization': 'Bearer $token',
                              },
                            );
                            if (res.statusCode == 200) {
                              print('✅ Logout berhasil');
                            }
                          } catch (e) {
                            print('❌ Error logout: $e');
                          }

                          final keranjangC = Get.find<KeranjangController>();
                          keranjangC.kosongkanMemori();

                          box.erase();
                          Get.offAllNamed(Routes.LOGIN);
                        },
                      );
                    },
                    icon: Icon(Icons.logout, size: 28.sp, color: KCoklatColor),
                  ),
                  IconButton(
                    onPressed: () => Get.toNamed(Routes.KERANJANG),
                    icon: Icon(
                      Icons.shopping_cart,
                      size: 28.sp,
                      color: KCoklatColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 10.h),
          Container(
            width: double.infinity,
            height: 50.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.r),
              color: KWhiteGreyColor,
            ),
            child: TextField(
              controller: controller.searchController,
              onChanged: (value) => controller.searchText.value = value,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 10.w,
                  vertical: 12.h,
                ),
                prefixIcon: const Icon(Icons.search),
                suffixIcon: Obx(
                  () => controller.searchText.value.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            controller.searchController.clear();
                            controller.searchText.value = '';
                          },
                        )
                      : const SizedBox(),
                ),
                hintText: 'Cari Produk',
                border: InputBorder.none,
              ),
            ),
          ),
          SizedBox(height: 20.h),
          Obx(() {
            if (controller.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            }

            if (controller.filteredProducts.isEmpty) {
              return const Center(child: Text('Produk tidak ditemukan'));
            }

            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: controller.filteredProducts.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: ScreenUtil().screenWidth > 600 ? 3 : 2,
                mainAxisSpacing: 16.h,
                crossAxisSpacing: 16.w,
                childAspectRatio:
                    3 /
                    4, // kamu bisa sesuaikan 3 / 3.7 jika ingin lebih pendek
              ),
              itemBuilder: (context, index) {
                final product = controller.filteredProducts[index];
                return GestureDetector(
                  onTap: () =>
                      Get.toNamed(Routes.DETAIL_PRODUK, arguments: product),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.r),
                      color: KCok,
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: 8.w,
                      vertical: 15.h,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20.r),
                              color: KWhiteGreyColor,
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20.r),
                              child: Image.network(
                                product.fullImageUrl,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    const Icon(Icons.broken_image),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          product.name,
                          style: WhiteTextStyle.copyWith(
                            fontSize: 14.sp,
                            fontWeight: bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          'Rp ${product.harga}',
                          style: WhiteTextStyle.copyWith(
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w500,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }),
        ],
      ),
      bottomNavigationBar: Obx(
        () => Padding(
          padding: EdgeInsets.symmetric(horizontal: 50.w, vertical: 10.h),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20.r),
            child: BottomNavigationBar(
              backgroundColor: KCoklatColor.withOpacity(0.95),
              selectedItemColor: Colors.white,
              unselectedItemColor: Colors.white70,
              currentIndex: controller.currentIndex.value,
              onTap: (index) {
                controller.currentIndex.value = index;
                switch (index) {
                  case 0:
                    break;
                  case 1:
                    Get.toNamed(Routes.HISTORY);
                    break;
                  case 2:
                    Get.toNamed(Routes.PROFILE);
                    break;
                }
              },
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home_outlined),
                  activeIcon: Icon(Icons.home),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.history_outlined),
                  activeIcon: Icon(Icons.history),
                  label: 'Riwayat',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person_outline),
                  activeIcon: Icon(Icons.person),
                  label: 'Profil',
                ),
              ],
              type: BottomNavigationBarType.fixed,
              elevation: 10,
              selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }
}
