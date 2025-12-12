import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';

/// خدمة توليد الباركود مع التواريخ الهجرية والميلادية
class BarcodeService {
  /// توليد باركود من النص المعطى
  static Future<Uint8List> generateBarcodeImage(String value) async {
    try {
      // إنشاء صورة الباركود
      final recorder = ui.PictureRecorder();
      final canvas = ui.Canvas(recorder);
      const size = Size(200, 80);

      // رسم خلفية بيضاء
      final backgroundPaint = Paint()..color = Colors.white;
      canvas.drawRect(
          Rect.fromLTWH(0, 0, size.width, size.height), backgroundPaint);

      // رسم الباركود باستخدام مكتبة barcode
      final paint = Paint()..color = Colors.black;

      // رسم باركود مبسط يدوياً
      final barWidth = size.width / value.length;
      for (int i = 0; i < value.length; i++) {
        // نمط بسيط للباركود بناءً على قيمة الأحرف
        final charCode = value.codeUnitAt(i);
        if (charCode % 3 == 0 || charCode % 5 == 0) {
          canvas.drawRect(
            Rect.fromLTWH(i * barWidth, 0, barWidth * 0.8, size.height),
            paint,
          );
        }
      }

      // تحويل إلى صورة
      final picture = recorder.endRecording();
      final image =
          await picture.toImage(size.width.toInt(), size.height.toInt());
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);

      return byteData!.buffer.asUint8List();
    } catch (e) {
      // في حالة فشل توليد الباركود، إرجاع صورة فارغة
      return _generateEmptyBarcodeImage();
    }
  }

  /// توليد صورة باركود فارغة في حالة الخطأ
  static Future<Uint8List> _generateEmptyBarcodeImage() async {
    final recorder = ui.PictureRecorder();
    final canvas = ui.Canvas(recorder);
    const size = Size(200, 80);

    // رسم مستطيل أبيض مع حدود
    final backgroundPaint = Paint()..color = Colors.white;
    final borderPaint = Paint()
      ..color = Colors.grey
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    canvas.drawRect(rect, backgroundPaint);
    canvas.drawRect(rect, borderPaint);

    // تحويل إلى صورة
    final picture = recorder.endRecording();
    final image =
        await picture.toImage(size.width.toInt(), size.height.toInt());
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);

    return byteData!.buffer.asUint8List();
  }

  /// تحويل التاريخ الميلادي إلى هجري مبسط
  static String convertToHijri(DateTime gregorianDate) {
    // خوارزمية تحويل مبسطة
    final hijriMonths = [
      'محرم',
      'صفر',
      'ربيع الأول',
      'ربيع الثاني',
      'جمادى الأولى',
      'جمادى الآخرة',
      'رجب',
      'شعبان',
      'رمضان',
      'شوال',
      'ذو القعدة',
      'ذو الحجة'
    ];

    // تحويل تقريبي (يمكن تحسينه باستخدام مكتبة متخصصة)
    int hijriYear = gregorianDate.year - 622;
    int hijriMonth = gregorianDate.month;
    int hijriDay = gregorianDate.day;

    // تعديل بسيط للشهر والسنة
    if (gregorianDate.month > 6) {
      hijriYear += 1;
      hijriMonth -= 6;
    } else {
      hijriMonth += 6;
    }

    // التأكد من أن الشهر في النطاق الصحيح
    if (hijriMonth > 12) {
      hijriMonth = hijriMonth - 12;
      hijriYear += 1;
    }

    final monthName = hijriMonths[hijriMonth - 1];
    return '$hijriDay $monthName ${hijriYear}هـ';
  }

  /// تنسيق التاريخ الميلادي
  static String formatGregorianDate(DateTime date) {
    return '${date.year}/${date.month.toString().padLeft(2, '0')}/${date.day.toString().padLeft(2, '0')}';
  }

  /// إنشاء widget للباركود مع المعلومات
  static Widget buildBarcodeWidget({
    required String referenceNumber,
    required DateTime date,
    required String subject,
    required String position, // 'right' أو 'left'
    bool showBarcode = true,
    bool showReferenceNumber = true,
    bool showHijriDate = true,
    bool showGregorianDate = true,
    bool showSubject = true,
  }) {
    return Container(
      width: 150,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // الباركود
          if (showBarcode)
            FutureBuilder<Uint8List>(
              future: generateBarcodeImage(referenceNumber),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Image.memory(
                    snapshot.data!,
                    width: 130,
                    height: 50,
                    fit: BoxFit.contain,
                  );
                }
                return Container(
                  width: 130,
                  height: 50,
                  color: Colors.grey.shade200,
                  child: const Center(
                    child: Text('باركود', style: TextStyle(fontSize: 12)),
                  ),
                );
              },
            ),

          // الرقم الصادر
          if (showReferenceNumber) ...[
            const SizedBox(height: 5),
            Text(
              referenceNumber,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
          ],

          // التاريخ الهجري
          if (showHijriDate) ...[
            const SizedBox(height: 3),
            Text(
              convertToHijri(date),
              style: TextStyle(
                fontSize: 9,
                color: Colors.grey.shade700,
              ),
              textAlign: TextAlign.center,
            ),
          ],

          // التاريخ الميلادي
          if (showGregorianDate) ...[
            const SizedBox(height: 2),
            Text(
              formatGregorianDate(date),
              style: TextStyle(
                fontSize: 9,
                color: Colors.grey.shade700,
              ),
              textAlign: TextAlign.center,
            ),
          ],

          // الموضوع
          if (showSubject && subject.isNotEmpty) ...[
            const SizedBox(height: 5),
            Text(
              subject.length > 20 ? '${subject.substring(0, 20)}...' : subject,
              style: const TextStyle(
                fontSize: 8,
                color: Colors.blue,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ],
      ),
    );
  }
}
