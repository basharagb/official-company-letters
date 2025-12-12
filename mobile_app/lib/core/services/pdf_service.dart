import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:barcode/barcode.dart';
import 'package:printing/printing.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

/// خدمة توليد PDF مع دعم كامل للغة العربية والباركود
class PdfService {
  static pw.Font? _arabicFont;
  static pw.Font? _arabicBoldFont;

  /// تحميل الخطوط العربية مرة واحدة
  static Future<void> _initFonts() async {
    if (_arabicFont != null && _arabicBoldFont != null) return;

    try {
      // محاولة تحميل خط Amiri العربي
      final fontData = await rootBundle.load('assets/fonts/Amiri-Regular.ttf');
      _arabicFont = pw.Font.ttf(fontData);

      final boldFontData = await rootBundle.load('assets/fonts/Amiri-Bold.ttf');
      _arabicBoldFont = pw.Font.ttf(boldFontData);
    } catch (e) {
      // استخدام الخط الافتراضي في حالة الفشل
      _arabicFont = pw.Font.helvetica();
      _arabicBoldFont = pw.Font.helveticaBold();
    }
  }

  /// توليد PDF للخطاب مع الورق الرسمي والباركود
  static Future<Uint8List> generateLetterPdf({
    required Map<String, dynamic> letter,
    required Map<String, dynamic> company,
    Uint8List? letterheadImage,
    String? hijriDate,
    String? gregorianDate,
  }) async {
    await _initFonts();

    final pdf = pw.Document();

    // بيانات الباركود
    final barcodeData = letter['reference_number'] ?? 'NO-REF';

    // تحديد موقع الباركود
    final barcodePosition = company['barcode_position'] ?? 'right';
    final isRight = barcodePosition == 'right';

    // إعدادات العرض
    final showBarcode = company['show_barcode'] ?? true;
    final showReferenceNumber = company['show_reference_number'] ?? true;
    final showHijriDate = company['show_hijri_date'] ?? true;
    final showGregorianDate = company['show_gregorian_date'] ?? true;
    final showSubjectInHeader = company['show_subject_in_header'] ?? true;

    // تحديد التواريخ
    final actualHijriDate = hijriDate ?? convertToHijri(DateTime.now());
    final actualGregorianDate =
        gregorianDate ?? formatGregorianDate(DateTime.now());

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(0),
        textDirection: pw.TextDirection.rtl,
        build: (pw.Context context) {
          return pw.Stack(
            children: [
              // خلفية الورق الرسمي (إن وجدت)
              if (letterheadImage != null)
                pw.Positioned.fill(
                  child: pw.Image(
                    pw.MemoryImage(letterheadImage),
                    fit: pw.BoxFit.fill,
                  ),
                ),

              // منطقة الباركود والمعلومات
              pw.Positioned(
                top: 20 * PdfPageFormat.mm,
                right: isRight ? 15 * PdfPageFormat.mm : null,
                left: !isRight ? 15 * PdfPageFormat.mm : null,
                child: pw.Container(
                  width: 55 * PdfPageFormat.mm,
                  padding: const pw.EdgeInsets.all(10),
                  decoration: pw.BoxDecoration(
                    color: PdfColors.white,
                    borderRadius:
                        const pw.BorderRadius.all(pw.Radius.circular(8)),
                    border: pw.Border.all(color: PdfColors.grey300, width: 0.5),
                    boxShadow: [
                      pw.BoxShadow(
                        color: PdfColors.grey200,
                        blurRadius: 4,
                        offset: const PdfPoint(0, 2),
                      ),
                    ],
                  ),
                  child: pw.Column(
                    mainAxisSize: pw.MainAxisSize.min,
                    children: [
                      // الباركود
                      if (showBarcode)
                        pw.Container(
                          height: 18 * PdfPageFormat.mm,
                          child: pw.BarcodeWidget(
                            barcode: Barcode.code128(),
                            data: barcodeData,
                            width: 48 * PdfPageFormat.mm,
                            height: 15 * PdfPageFormat.mm,
                            drawText: false,
                          ),
                        ),

                      // الرقم الصادر
                      if (showReferenceNumber)
                        pw.Padding(
                          padding: const pw.EdgeInsets.only(top: 6),
                          child: pw.Text(
                            barcodeData,
                            style: pw.TextStyle(
                              font: _arabicBoldFont,
                              fontSize: 12,
                              color: PdfColors.grey800,
                              letterSpacing: 0.5,
                            ),
                            textAlign: pw.TextAlign.center,
                          ),
                        ),

                      // التاريخ الهجري
                      if (showHijriDate)
                        pw.Padding(
                          padding: const pw.EdgeInsets.only(top: 4),
                          child: pw.Text(
                            actualHijriDate,
                            style: pw.TextStyle(
                              font: _arabicFont,
                              fontSize: 10,
                              color: PdfColors.grey700,
                            ),
                            textAlign: pw.TextAlign.center,
                            textDirection: pw.TextDirection.rtl,
                          ),
                        ),

                      // التاريخ الميلادي
                      if (showGregorianDate)
                        pw.Padding(
                          padding: const pw.EdgeInsets.only(top: 2),
                          child: pw.Text(
                            actualGregorianDate,
                            style: pw.TextStyle(
                              font: _arabicFont,
                              fontSize: 10,
                              color: PdfColors.grey600,
                            ),
                            textAlign: pw.TextAlign.center,
                          ),
                        ),

                      // الموضوع
                      if (showSubjectInHeader &&
                          (letter['subject'] ?? '').isNotEmpty)
                        pw.Padding(
                          padding: const pw.EdgeInsets.only(top: 6),
                          child: pw.Container(
                            padding: const pw.EdgeInsets.symmetric(
                                horizontal: 6, vertical: 3),
                            decoration: pw.BoxDecoration(
                              color: PdfColors.blue50,
                              borderRadius: const pw.BorderRadius.all(
                                  pw.Radius.circular(4)),
                            ),
                            child: pw.Text(
                              _limitText(letter['subject'] ?? '', 30),
                              style: pw.TextStyle(
                                font: _arabicBoldFont,
                                fontSize: 9,
                                color: PdfColors.blue800,
                              ),
                              textAlign: pw.TextAlign.center,
                              textDirection: pw.TextDirection.rtl,
                              maxLines: 2,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),

              // محتوى الخطاب
              pw.Positioned(
                top: 85 * PdfPageFormat.mm,
                left: 25 * PdfPageFormat.mm,
                right: 25 * PdfPageFormat.mm,
                bottom: 30 * PdfPageFormat.mm,
                child: _buildLetterContent(letter: letter),
              ),
            ],
          );
        },
      ),
    );

    return pdf.save();
  }

  /// بناء محتوى الخطاب
  static pw.Widget _buildLetterContent({
    required Map<String, dynamic> letter,
  }) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.stretch,
      children: [
        // المستلم
        if (letter['recipient_name'] != null ||
            letter['recipient_organization'] != null)
          pw.Container(
            margin: const pw.EdgeInsets.only(bottom: 15),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.RichText(
                  textDirection: pw.TextDirection.rtl,
                  text: pw.TextSpan(
                    style: pw.TextStyle(font: _arabicFont, fontSize: 13),
                    children: [
                      pw.TextSpan(
                        text: 'إلى: ',
                        style: pw.TextStyle(
                          font: _arabicBoldFont,
                          color: PdfColors.grey800,
                        ),
                      ),
                      pw.TextSpan(
                        text:
                            '${letter['recipient_title'] ?? ''} ${letter['recipient_name'] ?? ''}'
                                .trim(),
                      ),
                    ],
                  ),
                ),
                if (letter['recipient_organization'] != null &&
                    letter['recipient_organization'].toString().isNotEmpty)
                  pw.Padding(
                    padding: const pw.EdgeInsets.only(top: 4, right: 25),
                    child: pw.Text(
                      letter['recipient_organization'],
                      style: pw.TextStyle(
                        font: _arabicFont,
                        fontSize: 12,
                        color: PdfColors.grey700,
                      ),
                      textDirection: pw.TextDirection.rtl,
                    ),
                  ),
              ],
            ),
          ),

        // الموضوع
        pw.Container(
          margin: const pw.EdgeInsets.only(bottom: 20),
          padding: const pw.EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: pw.BoxDecoration(
            color: PdfColors.grey100,
            borderRadius: const pw.BorderRadius.all(pw.Radius.circular(6)),
            border: pw.Border(
              right: pw.BorderSide(color: PdfColors.blue700, width: 4),
            ),
          ),
          child: pw.RichText(
            textDirection: pw.TextDirection.rtl,
            text: pw.TextSpan(
              style: pw.TextStyle(font: _arabicFont, fontSize: 13),
              children: [
                pw.TextSpan(
                  text: 'الموضوع: ',
                  style: pw.TextStyle(
                    font: _arabicBoldFont,
                    color: PdfColors.blue800,
                  ),
                ),
                pw.TextSpan(
                  text: letter['subject'] ?? '',
                  style: pw.TextStyle(
                    font: _arabicBoldFont,
                  ),
                ),
              ],
            ),
          ),
        ),

        // المحتوى
        pw.Text(
          'السلام عليكم ورحمة الله وبركاته،',
          style: pw.TextStyle(
            font: _arabicFont,
            fontSize: 13,
          ),
          textDirection: pw.TextDirection.rtl,
        ),

        pw.SizedBox(height: 12),

        pw.Text(
          letter['content'] ?? '',
          style: pw.TextStyle(
            font: _arabicFont,
            fontSize: 13,
            lineSpacing: 6,
          ),
          textAlign: pw.TextAlign.justify,
          textDirection: pw.TextDirection.rtl,
        ),

        pw.SizedBox(height: 15),

        pw.Text(
          'وتقبلوا فائق الاحترام والتقدير،،،',
          style: pw.TextStyle(
            font: _arabicFont,
            fontSize: 13,
          ),
          textDirection: pw.TextDirection.rtl,
        ),
      ],
    );
  }

  /// تحديد النص بعدد معين من الأحرف
  static String _limitText(String text, int limit) {
    if (text.length <= limit) return text;
    return '${text.substring(0, limit)}...';
  }

  /// تحويل التاريخ الميلادي إلى هجري
  static String convertToHijri(DateTime gregorianDate) {
    // خوارزمية تحويل دقيقة
    final jd = _gregorianToJulian(
        gregorianDate.year, gregorianDate.month, gregorianDate.day);
    final hijri = _julianToHijri(jd);

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

    return '${hijri['day']} ${hijriMonths[hijri['month']! - 1]} ${hijri['year']}هـ';
  }

  /// تحويل التاريخ الميلادي إلى يوليان
  static int _gregorianToJulian(int year, int month, int day) {
    if (month <= 2) {
      year -= 1;
      month += 12;
    }
    final a = (year / 100).floor();
    final b = 2 - a + (a / 4).floor();
    return (365.25 * (year + 4716)).floor() +
        (30.6001 * (month + 1)).floor() +
        day +
        b -
        1524;
  }

  /// تحويل يوليان إلى هجري
  static Map<String, int> _julianToHijri(int jd) {
    final l = jd - 1948440 + 10632;
    final n = ((l - 1) / 10631).floor();
    final l2 = l - 10631 * n + 354;
    final j = ((10985 - l2) / 5316).floor() * ((50 * l2) / 17719).floor() +
        (l2 / 5670).floor() * ((43 * l2) / 15238).floor();
    final l3 = l2 -
        ((30 - j) / 15).floor() * ((17719 * j) / 50).floor() -
        (j / 16).floor() * ((15238 * j) / 43).floor() +
        29;
    final month = ((24 * l3) / 709).floor();
    final day = l3 - ((709 * month) / 24).floor();
    final year = 30 * n + j - 30;

    return {'year': year, 'month': month, 'day': day};
  }

  /// تنسيق التاريخ الميلادي
  static String formatGregorianDate(DateTime date) {
    return DateFormat('yyyy/MM/dd', 'ar').format(date);
  }

  /// حفظ PDF في الملفات المؤقتة وفتحه
  static Future<File> savePdfToFile(Uint8List pdfData, String fileName) async {
    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/$fileName.pdf');
    await file.writeAsBytes(pdfData);
    return file;
  }

  /// مشاركة PDF
  static Future<void> sharePdf(Uint8List pdfData, String fileName) async {
    await Printing.sharePdf(bytes: pdfData, filename: '$fileName.pdf');
  }

  /// طباعة PDF
  static Future<void> printPdf(Uint8List pdfData) async {
    await Printing.layoutPdf(onLayout: (format) async => pdfData);
  }
}
