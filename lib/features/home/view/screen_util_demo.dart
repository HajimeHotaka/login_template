import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ScreenUtilDemo extends StatelessWidget {
  const ScreenUtilDemo({super.key});

  @override
  Widget build(BuildContext context) {
    final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;

    return Scaffold(
      appBar: AppBar(title: const Text('ScreenUtil 比較デモ')),
      body: isLandscape
          ? Row(
              children: [
                Expanded(child: _buildContent()),
                const SizedBox(width: 16),
                _buildDebugInfo(),
              ],
            )
          : LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minHeight: constraints.maxHeight),
                    child: IntrinsicHeight(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildContent(),
                            const SizedBox(height: 24),
                            _buildDebugInfo(),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }

  Widget _buildContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('❌ 固定サイズUI（非スケーリング）', style: TextStyle(fontWeight: FontWeight.bold)),
        Container(
          width: 200, // 固定幅
          height: 100,
          color: Colors.red[100],
          child: const Center(
            child: Text(
              'Font 16 (固定)',
              style: TextStyle(fontSize: 16),
            ),
          ),
        ),
        const SizedBox(height: 24),
        const Text('✅ ScreenUtil使用UI（スケーリング）', style: TextStyle(fontWeight: FontWeight.bold)),
        Container(
          width: 200.w,
          height: 100.h,
          color: Colors.green[100],
          child: Center(
            child: Text(
              'Font 16.sp',
              style: TextStyle(fontSize: 16.sp),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDebugInfo() {
    return Padding(
      padding: const EdgeInsets.only(top: 24),
      child: Text(
        '📱 現在の画面サイズ: ${ScreenUtil().screenWidth.toStringAsFixed(0)} x ${ScreenUtil().screenHeight.toStringAsFixed(0)}\n'
        '📏 PixelRatio: ${ScreenUtil().pixelRatio?.toStringAsFixed(2)}\n'
        '🧠 スケーリング係数: width=${ScreenUtil().scaleWidth.toStringAsFixed(2)}, height=${ScreenUtil().scaleHeight.toStringAsFixed(2)}',
        style: TextStyle(fontSize: 12.sp),
      ),
    );
  }
}
