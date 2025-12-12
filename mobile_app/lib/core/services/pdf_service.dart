import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

/// خدمة توليد PDF مع دعم اللغة العربية والباركود
class PdfService {
  static const String _arabicFontPath = 'fonts/NotoSansArabic-Regular.ttf';
  static const String _arabicBoldFontPath = 'fonts/NotoSansArabic-Bold.ttf';

  /// توليد PDF للخطاب مع الورق الرسمي والباركود
  static Future<Uint8List> generateLetterPdf({
    required Map<String, dynamic> letter,
    required Map<String, dynamic> company,
    Uint8List? letterheadImage,
    String? hijriDate,
    String? gregorianDate,
  }) async {
    final pdf = pw.Document();

    // تحميل الخطوط العربية
    final arabicFont = await _loadArabicFont();
    final arabicBoldFont = await _loadArabicBoldFont();

    // توليد الباركود
    final barcodeImage =
        await _generateBarcode(letter['reference_number'] ?? '');

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(0),
        textDirection: pw.TextDirection.rtl,
        build: (pw.Context context) {
          return pw.Stack(
            children: [
              // خلفية الورق الرسمي
              if (letterheadImage != null)
                pw.Positioned.fill(
                  child: pw.Image(
                    pw.MemoryImage(letterheadImage),
                    fit: pw.BoxFit.contain,
                  ),
                ),

              // منطقة الباركود والمعلومات
              _buildBarcodeSection(
                company: company,
                letter: letter,
                barcodeImage: barcodeImage,
                hijriDate: hijriDate,
                gregorianDate: gregorianDate,
                arabicFont: arabicFont,
                arabicBoldFont: arabicBoldFont,
              ),

              // محتوى الخطاب
              pw.Positioned(
                top: 80 * PdfPageFormat.mm,
                left: 25 * PdfPageFormat.mm,
                right: 25 * PdfPageFormat.mm,
                child: _buildLetterContent(
                  letter: letter,
                  arabicFont: arabicFont,
                  arabicBoldFont: arabicBoldFont,
                ),
              ),
            ],
          );
        },
      ),
    );

    return pdf.save();
  }

  /// بناء قسم الباركود والمعلومات
  static pw.Widget _buildBarcodeSection({
    required Map<String, dynamic> company,
    required Map<String, dynamic> letter,
    required Uint8List barcodeImage,
    String? hijriDate,
    String? gregorianDate,
    required pw.Font arabicFont,
    required pw.Font arabicBoldFont,
  }) {
    final isRight = (company['barcode_position'] ?? 'right') == 'right';
    final topMargin = (company['barcode_top_margin'] ?? 20).toDouble();
    final sideMargin = (company['barcode_side_margin'] ?? 15).toDouble();

    return pw.Positioned(
      top: topMargin * PdfPageFormat.mm,
      right: isRight ? sideMargin * PdfPageFormat.mm : null,
      left: !isRight ? sideMargin * PdfPageFormat.mm : null,
      child: pw.Container(
        width: 50 * PdfPageFormat.mm,
        padding: const pw.EdgeInsets.all(8),
        decoration: pw.BoxDecoration(
          color: PdfColors.white,
          borderRadius: pw.BorderRadius.circular(5),
          border: pw.Border.all(color: PdfColors.grey300),
        ),
        child: pw.Column(
          children: [
            // الباركود
            if (company['show_barcode'] ?? true)
              pw.Container(
                width: 45 * PdfPageFormat.mm,
                height: 15 * PdfPageFormat.mm,
                child: pw.Image(pw.MemoryImage(barcodeImage)),
              ),

            // الرقم الصادر
            if (company['show_reference_number'] ?? true)
              pw.Padding(
                padding: const pw.EdgeInsets.only(top: 5),
                child: pw.Text(
                  letter['reference_number'] ?? '',
                  style: pw.TextStyle(
                    font: arabicBoldFont,
                    fontSize: 11,
                    color: PdfColors.grey800,
                  ),
                  textAlign: pw.TextAlign.center,
                ),
              ),

            // التاريخ الهجري
            if (company['show_hijri_date'] ?? true)
              pw.Padding(
                padding: const pw.EdgeInsets.only(top: 3),
                child: pw.Text(
                  hijriDate ?? '',
                  style: pw.TextStyle(
                    font: arabicFont,
                    fontSize: 10,
                    color: PdfColors.grey600,
                  ),
                  textAlign: pw.TextAlign.center,
                ),
              ),

            // التاريخ الميلادي
            if (company['show_gregorian_date'] ?? true)
              pw.Padding(
                padding: const pw.EdgeInsets.only(top: 2),
                child: pw.Text(
                  gregorianDate ?? '',
                  style: pw.TextStyle(
                    font: arabicFont,
                    fontSize: 10,
                    color: PdfColors.grey600,
                  ),
                  textAlign: pw.TextAlign.center,
                ),
              ),

            // الموضوع
            if (company['show_subject_in_header'] ?? true)
              pw.Padding(
                padding: const pw.EdgeInsets.only(top: 5),
                child: pw.Text(
                  _limitText(letter['subject'] ?? '', 50),
                  style: pw.TextStyle(
                    font: arabicBoldFont,
                    fontSize: 9,
                    color: PdfColors.blue,
                  ),
                  textAlign: pw.TextAlign.center,
                ),
              ),
          ],
        ),
      ),
    );
  }

  /// بناء محتوى الخطاب
  static pw.Widget _buildLetterContent({
    required Map<String, dynamic> letter,
    required pw.Font arabicFont,
    required pw.Font arabicBoldFont,
  }) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        // المستلم
        if (letter['recipient_name'] != null ||
            letter['recipient_organization'] != null)
          pw.Container(
            margin: const pw.EdgeInsets.only(bottom: 15),
            child: pw.RichText(
              textDirection: pw.TextDirection.rtl,
              text: pw.TextSpan(
                style: pw.TextStyle(font: arabicFont, fontSize: 14),
                children: [
                  pw.TextSpan(
                    text: 'إلى: ',
                    style: pw.TextStyle(font: arabicBoldFont),
                  ),
                  pw.TextSpan(
                    text:
                        '${letter['recipient_title'] ?? ''} ${letter['recipient_name'] ?? ''}',
                  ),
                  if (letter['recipient_organization'] != null)
                    pw.TextSpan(text: '\n${letter['recipient_organization']}'),
                ],
              ),
            ),
          ),

        // الموضوع
        pw.Container(
          margin: const pw.EdgeInsets.only(bottom: 20),
          padding: const pw.EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: pw.BoxDecoration(
            color: PdfColors.grey100,
            borderRadius: pw.BorderRadius.circular(5),
            border: pw.Border(
              right: pw.BorderSide(color: PdfColors.blue, width: 4),
            ),
          ),
          child: pw.RichText(
            textDirection: pw.TextDirection.rtl,
            text: pw.TextSpan(
              style: pw.TextStyle(font: arabicFont, fontSize: 14),
              children: [
                pw.TextSpan(
                  text: 'الموضوع: ',
                  style:
                      pw.TextStyle(font: arabicBoldFont, color: PdfColors.blue),
                ),
                pw.TextSpan(text: letter['subject'] ?? ''),
              ],
            ),
          ),
        ),

        // المحتوى
        pw.Container(
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                'السلام عليكم ورحمة الله وبركاته،',
                style: pw.TextStyle(
                  font: arabicFont,
                  fontSize: 14,
                  lineSpacing: 2,
                ),
                textAlign: pw.TextAlign.justify,
              ),
              pw.SizedBox(height: 10),
              pw.Text(
                letter['content'] ?? '',
                style: pw.TextStyle(
                  font: arabicFont,
                  fontSize: 14,
                  lineSpacing: 2,
                ),
                textAlign: pw.TextAlign.justify,
                textDirection: pw.TextDirection.rtl,
              ),
              pw.SizedBox(height: 10),
              pw.Text(
                'وتقبلوا فائق الاحترام والتقدير،،،',
                style: pw.TextStyle(
                  font: arabicFont,
                  fontSize: 14,
                  lineSpacing: 2,
                ),
                textAlign: pw.TextAlign.justify,
                textDirection: pw.TextDirection.rtl,
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// توليد الباركود
  static Future<Uint8List> _generateBarcode(String value) async {
    // تحويل SVG إلى صورة
    final recorder = ui.PictureRecorder();
    final canvas = ui.Canvas(recorder);

    // رسم الباركود (مبسط - يمكن استخدام مكتبة أخرى للتحويل الدقيق)
    final paint = ui.Paint()
      ..color = const ui.Color(0xFF000000)
      ..strokeWidth = 2;

    // رسم خطوط الباركود بشكل مبسط
    for (int i = 0; i < 50; i++) {
      if (i % 3 == 0 || i % 7 == 0) {
        // نمط مبسط للباركود
        canvas.drawLine(
          ui.Offset(i * 4.0, 0),
          ui.Offset(i * 4.0, 80),
          paint,
        );
      }
    }

    final picture = recorder.endRecording();
    final img = await picture.toImage(200, 80);
    final byteData = await img.toByteData(format: ui.ImageByteFormat.png);

    return byteData!.buffer.asUint8List();
  }

  /// تحميل الخط العربي العادي
  static Future<pw.Font> _loadArabicFont() async {
    try {
      final fontData = await rootBundle.load(_arabicFontPath);
      return pw.Font.ttf(fontData);
    } catch (e) {
      // إذا لم يتم العثور على الخط العربي، استخدم الخط الافتراضي
      return pw.Font.helvetica();
    }
  }

  /// تحميل الخط العربي الغامق
  static Future<pw.Font> _loadArabicBoldFont() async {
    try {
      final fontData = await rootBundle.load(_arabicBoldFontPath);
      return pw.Font.ttf(fontData);
    } catch (e) {
      // إذا لم يتم العثور على الخط العربي، استخدم الخط الافتراضي
      return pw.Font.helveticaBold();
    }
  }

  /// تحديد النص بعدد معين من الأحرف
  static String _limitText(String text, int limit) {
    if (text.length <= limit) return text;
    return '${text.substring(0, limit)}...';
  }

  /// تحويل التاريخ الميلادي إلى هجري (مبسط)
  static String convertToHijri(DateTime gregorianDate) {
    // هذا تحويل مبسط - يمكن استخدام مكتبة أكثر دقة
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

    // تحويل مبسط (يحتاج تحسين للدقة)
    final hijriYear = gregorianDate.year - 622;
    final hijriMonth = hijriMonths[gregorianDate.month - 1];

    return '${gregorianDate.day} $hijriMonth ${hijriYear}هـ';
  }

  /// تنسيق التاريخ الميلادي
  static String formatGregorianDate(DateTime date) {
    return DateFormat('yyyy/MM/dd').format(date);
  }
}
