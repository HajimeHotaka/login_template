// localization.dart
// localization.dart
import 'package:flutter/material.dart';
import 'package:katana_localization/katana_localization.dart';

// 自動生成されたローカライズファイルを結合するための part 指定
// Include the generated localization file
part 'localization.localize.dart';

// Google スプレッドシートから翻訳データを取得するアノテーション
// Annotation to fetch localization data from a Google Spreadsheet
@GoogleSpreadSheetLocalize(
  ['https://docs.google.com/spreadsheets/d/1PFlAQfT8-2C_4zPdKqi30H1SWEGRV2X_Fw_BEqgDoOQ/edit#gid=551986808'],
  version: 1,
)

// ローカライズ用のクラス定義（自動生成クラス _$AppLocalize を継承）
// Class for accessing localized strings (extends the generated _$AppLocalize)
class AppLocalize extends _$AppLocalize {}

// グローバルに使用するローカライズインスタンス
// Global instance for accessing localized text
final localize = AppLocalize();
