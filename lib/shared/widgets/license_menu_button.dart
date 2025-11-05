// license_menu_button.dart
import 'package:flutter/material.dart';
import 'package:login_template/localization/localization.dart';

class LicenseMenuButton extends StatelessWidget {
  const LicenseMenuButton({super.key});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      onSelected: (value) {
        if (value == 'license') {
          showLicensePage(
            context: context,
            applicationName: 'login template',
            applicationVersion: '1.0.0',
            applicationLegalese: '© 2025 Hajime Hotaka',
          );
        }
      },
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 'license',
          child: Text(localize().license),
        ),
      ],
    );
  }
}
