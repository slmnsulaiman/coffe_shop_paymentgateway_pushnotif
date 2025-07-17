import 'package:get/get.dart';

import '../modules/checkout/bindings/checkout_binding.dart';
import '../modules/checkout/views/checkout_view.dart';
import '../modules/detail_produk/bindings/detail_produk_binding.dart';
import '../modules/detail_produk/views/detail_produk_view.dart';
import '../modules/history/bindings/history_binding.dart';
import '../modules/history/views/history_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/kasir_home/bindings/kasir_home_binding.dart';
import '../modules/kasir_home/views/kasir_home_view.dart';
import '../modules/kasir_ringkasan_penjual/bindings/kasir_ringkasan_penjual_binding.dart';
import '../modules/kasir_ringkasan_penjual/views/kasir_ringkasan_penjual_view.dart';
import '../modules/keranjang/bindings/keranjang_binding.dart';
import '../modules/keranjang/views/keranjang_view.dart';
import '../modules/login/bindings/login_binding.dart';
import '../modules/login/views/login_view.dart';
import '../modules/profile/bindings/profile_binding.dart';
import '../modules/profile/views/profile_view.dart';
import '../modules/register/bindings/register_binding.dart';
import '../modules/register/views/register_view.dart';
import '../modules/snap/bindings/snap_binding.dart';
import '../modules/snap/views/snap_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.LOGIN;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.REGISTER,
      page: () => const RegisterView(),
      binding: RegisterBinding(),
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => const LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.DETAIL_PRODUK,
      page: () => const DetailProdukView(),
      binding: DetailProdukBinding(),
    ),
    GetPage(
      name: _Paths.KERANJANG,
      page: () => const KeranjangView(),
      binding: KeranjangBinding(),
    ),
    GetPage(
      name: _Paths.CHECKOUT,
      page: () => const CheckoutView(),
      binding: CheckoutBinding(),
    ),
    GetPage(
      name: _Paths.SNAP,
      page: () => const SnapView(),
      binding: SnapBinding(),
    ),
    GetPage(
      name: _Paths.KASIR_HOME,
      page: () => const KasirHomeView(),
      binding: KasirHomeBinding(),
    ),
    GetPage(
      name: _Paths.KASIR_RINGKASAN_PENJUAL,
      page: () => const KasirRingkasanPenjualView(),
      binding: KasirRingkasanPenjualBinding(),
    ),
    GetPage(
      name: _Paths.PROFILE,
      page: () => const ProfileView(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: _Paths.HISTORY,
      page: () => const HistoryView(),
      binding: HistoryBinding(),
    ),
  ];
}
