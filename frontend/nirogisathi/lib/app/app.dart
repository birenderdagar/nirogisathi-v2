import 'package:flutter/material.dart';



import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:nirogisathi/app/router/app_router.dart';
import 'package:nirogisathi/app/theme/app_theme.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  

  @override
  Widget build(BuildContext context) {
    return     MaterialApp.router(
      title: 'Nirogisathi_new',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: ThemeMode.system,
            localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', ''),
      ],
      routerConfig: router,
    );
  }
}
