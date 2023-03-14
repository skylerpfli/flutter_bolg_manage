import 'package:blog/app/app_theme.dart';
import 'package:blog/res/strings.dart';
import 'package:blog/ui/page/splash_page/splash_binding.dart';
import 'package:blog/ui/page/splash_page/splash_page.dart';
import 'package:blog/util/injection_init.dart';
import 'package:blog/util/locale_util.dart';
import 'package:flutter/material.dart';
import 'package:blog/routes/routes.dart';
import 'package:blog/util/keyboard_util.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter_conch_plugin/annotation/patch_scope.dart';
import 'package:flutter_conch_plugin/conch_dispatch.dart';

var useConch = true;

/// @class : main
/// @date : 2021/08/11
/// @name : jhf
/// @description :入口
@PatchScope()
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (useConch) {
    var source = await rootBundle.load('assets/conch_build/patch_dat/conch_result.dat');
    ConchDispatch.instance.loadByteSource(source);
    await ConchDispatch.instance.callStaticFun(library: 'package:blog/main.dart', funcName: 'mainInner');
    return;
  }
  await mainInner();
}

mainInner() async {
  await Injection.init();
  runApp(GetMaterialApp(
    getPages: Routes.routePage,
    debugShowCheckedModeBanner: false,
    initialRoute: '/',
    builder: (context, child) => Scaffold(
      // Global GestureDetector that will dismiss the keyboard
      body: GestureDetector(
        onTap: () {
          KeyboardUtils.hideKeyboard(context);
        },
        child: child,
      ),
    ),

    ///主题颜色
    theme: appThemeData,

    ///国际化支持-来源配置
    translations: Messages(),

    ///国际化支持-默认语言
    locale: LocaleOptions.getDefault(),

    ///国际化支持-备用语言
    fallbackLocale: const Locale('en', 'US'),

    defaultTransition: Transition.fade,
    initialBinding: SplashBinding(),
    home: const SplashPage(),
  ));
}
