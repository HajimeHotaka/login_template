// logger.dart
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

/// ビルドモードに応じてログレベルを切り替え
/// Switch log level based on build mode:
/// - In release mode: show warnings and errors only
/// - In debug/profile mode: show full debug logs
const Level debugLevel = kReleaseMode ? Level.warning : Level.debug;

// アプリ全体で使用する Logger インスタンス
/// Global logger instance with consistent configuration
final log = Logger(
  // ログ出力レベル（上記で設定） / Sets the output log level
  level: debugLevel,
  printer: PrettyPrinter(
    // スタックトレースの出力数 / Number of stack trace lines to print
    methodCount: 2,
    // カラフルな出力を有効に / Enables colorful logs
    colors: true,
    // 絵文字を無効化（虫キライ用）/ Disables emojis in log output (bug-averse friendly)
    printEmojis: false,
  ),
);
