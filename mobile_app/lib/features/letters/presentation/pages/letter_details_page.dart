import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:iconsax/iconsax.dart';
import 'package:share_plus/share_plus.dart';
import 'package:get_it/get_it.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/services/pdf_service.dart';
import '../../../company/data/datasources/company_remote_datasource.dart';
import '../../data/datasources/letters_remote_datasource.dart';

/// صفحة تفاصيل الخطاب مع خيارات المشاركة
class LetterDetailsPage extends StatefulWidget {
  final int letterId;

  const LetterDetailsPage({super.key, required this.letterId});

  @override
  State<LetterDetailsPage> createState() => _LetterDetailsPageState();
}

class _LetterDetailsPageState extends State<LetterDetailsPage> {
  bool _isLoading = true;
  bool _isPdfLoading = false;
  Map<String, dynamic>? _letterData;
  Map<String, dynamic>? _companyData;
  Map<String, dynamic>? _letterheadSettings;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final lettersDs = GetIt.instance<LettersRemoteDataSource>();
      final companyDs = GetIt.instance<CompanyRemoteDataSource>();

      final letter = await lettersDs.getLetter(widget.letterId);
      final company = await companyDs.getCompany();
      final letterhead = await companyDs.getLetterheadSettings();

      if (mounted) {
        setState(() {
          _letterData = letter.toJson();
          _companyData = company;
          _letterheadSettings = letterhead;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('خطأ في تحميل البيانات: $e')),
        );
      }
    }
  }

  Future<void> _generateAndSharePdf() async {
    if (_letterData == null) return;

    setState(() => _isPdfLoading = true);

    try {
      final pdfBytes = await PdfService.generateLetterPdf(
        letter: _letterData!,
        company: {
          ..._companyData ?? {},
          ..._letterheadSettings ?? {},
        },
        hijriDate: PdfService.convertToHijri(DateTime.now()),
        gregorianDate: PdfService.formatGregorianDate(DateTime.now()),
      );

      await PdfService.sharePdf(
        pdfBytes,
        'خطاب_${_letterData!['reference_number'] ?? widget.letterId}',
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('خطأ في إنشاء PDF: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isPdfLoading = false);
    }
  }

  Future<void> _printPdf() async {
    if (_letterData == null) return;

    setState(() => _isPdfLoading = true);

    try {
      final pdfBytes = await PdfService.generateLetterPdf(
        letter: _letterData!,
        company: {
          ..._companyData ?? {},
          ..._letterheadSettings ?? {},
        },
        hijriDate: PdfService.convertToHijri(DateTime.now()),
        gregorianDate: PdfService.formatGregorianDate(DateTime.now()),
      );

      await PdfService.printPdf(pdfBytes);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('خطأ في الطباعة: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isPdfLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final refNumber =
        _letterData?['reference_number'] ?? 'OUT-${widget.letterId}';
    final subject =
        _letterData?['subject'] ?? 'طلب تعاون في مشروع التحول الرقمي';
    final content = _letterData?['content'] ??
        'نتقدم إليكم بخالص التحية والتقدير، ونود إعلامكم برغبتنا في التعاون معكم في مشروع التحول الرقمي الذي تعمل عليه شركتكم الموقرة.\n\nنأمل منكم التكرم بالموافقة على عقد اجتماع لمناقشة تفاصيل التعاون المقترح.';
    final recipientName = _letterData?['recipient_name'] ?? 'محمد أحمد العلي';
    final recipientTitle = _letterData?['recipient_title'] ?? 'المدير العام';
    final recipientOrg =
        _letterData?['recipient_organization'] ?? 'شركة التقنية المتقدمة';
    final status = _letterData?['status'] ?? 'issued';
    final hijriDate = PdfService.convertToHijri(DateTime.now());
    final gregorianDate = PdfService.formatGregorianDate(DateTime.now());

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: FadeInDown(
          duration: const Duration(milliseconds: 500),
          child: Text('خطاب #${widget.letterId}'),
        ),
        actions: [
          if (_isPdfLoading)
            const Padding(
              padding: EdgeInsets.all(12),
              child: SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            )
          else
            IconButton(
              icon: const Icon(Iconsax.printer),
              onPressed: _printPdf,
              tooltip: 'طباعة',
            ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            onSelected: (value) => _handleMenuAction(context, value),
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'pdf',
                child: Row(
                  children: [
                    Icon(Iconsax.document_download, size: 20),
                    SizedBox(width: 12),
                    Text('تحميل PDF'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'print',
                child: Row(
                  children: [
                    Icon(Iconsax.printer, size: 20),
                    SizedBox(width: 12),
                    Text('طباعة'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'email',
                child: Row(
                  children: [
                    Icon(Iconsax.sms, size: 20),
                    SizedBox(width: 12),
                    Text('إرسال بالبريد'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'whatsapp',
                child: Row(
                  children: [
                    Icon(Icons.message, size: 20),
                    SizedBox(width: 12),
                    Text('واتساب'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'share',
                child: Row(
                  children: [
                    Icon(Iconsax.share, size: 20),
                    SizedBox(width: 12),
                    Text('مشاركة الرابط'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // بطاقة معلومات الخطاب
                  FadeInUp(
                    duration: const Duration(milliseconds: 400),
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Header
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 8,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColors.primary,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      refNumber,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: status == 'issued'
                                        ? AppColors.success.withOpacity(0.1)
                                        : Colors.orange.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    status == 'issued' ? 'صادر' : 'مسودة',
                                    style: TextStyle(
                                      color: status == 'issued'
                                          ? AppColors.success
                                          : Colors.orange,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 20),
                            const Divider(),
                            const SizedBox(height: 16),

                            // التواريخ
                            _buildInfoRow(
                              icon: Iconsax.calendar,
                              label: 'التاريخ الميلادي',
                              value: gregorianDate,
                            ),
                            _buildInfoRow(
                              icon: Iconsax.calendar_1,
                              label: 'التاريخ الهجري',
                              value: hijriDate,
                            ),

                            const SizedBox(height: 16),
                            const Divider(),
                            const SizedBox(height: 16),

                            // المستلم
                            _buildInfoRow(
                              icon: Iconsax.user,
                              label: 'المستلم',
                              value: recipientName,
                            ),
                            _buildInfoRow(
                              icon: Iconsax.user_tag,
                              label: 'الصفة',
                              value: recipientTitle,
                            ),
                            _buildInfoRow(
                              icon: Iconsax.building,
                              label: 'الجهة',
                              value: recipientOrg,
                            ),

                            const SizedBox(height: 16),
                            const Divider(),
                            const SizedBox(height: 16),

                            // الموضوع
                            const Text(
                              'الموضوع',
                              style: TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 12,
                                fontFamily: 'Cairo',
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              subject,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Cairo',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // محتوى الخطاب
                  FadeInUp(
                    delay: const Duration(milliseconds: 200),
                    duration: const Duration(milliseconds: 400),
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(Iconsax.document_text,
                                    color: AppColors.primary),
                                const SizedBox(width: 8),
                                const Text(
                                  'محتوى الخطاب',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'Cairo',
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'السلام عليكم ورحمة الله وبركاته،\n\n$content\n\nوتفضلوا بقبول فائق الاحترام والتقدير.',
                              style: const TextStyle(
                                fontSize: 14,
                                height: 1.8,
                                fontFamily: 'Cairo',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // أزرار الإجراءات
                  FadeInUp(
                    delay: const Duration(milliseconds: 400),
                    duration: const Duration(milliseconds: 400),
                    child: Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed:
                                _isPdfLoading ? null : _generateAndSharePdf,
                            icon: _isPdfLoading
                                ? const SizedBox(
                                    width: 18,
                                    height: 18,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                : const Icon(Iconsax.document_download),
                            label: Text(_isPdfLoading
                                ? 'جاري الإنشاء...'
                                : 'تحميل PDF'),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () =>
                                _handleMenuAction(context, 'share'),
                            icon: const Icon(Iconsax.share),
                            label: const Text('مشاركة'),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppColors.textSecondary),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 11,
                    fontFamily: 'Cairo',
                  ),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Cairo',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _handleMenuAction(BuildContext context, String action) async {
    switch (action) {
      case 'pdf':
        _generateAndSharePdf();
        break;
      case 'print':
        _printPdf();
        break;
      case 'email':
        final email = _letterData?['recipient_email'] ?? '';
        final subject = _letterData?['subject'] ?? '';
        final uri =
            Uri.parse('mailto:$email?subject=${Uri.encodeComponent(subject)}');
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri);
        }
        break;
      case 'whatsapp':
        final text = 'خطاب: ${_letterData?['subject'] ?? ''}';
        final uri =
            Uri.parse('https://wa.me/?text=${Uri.encodeComponent(text)}');
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
        }
        break;
      case 'share':
        Share.share(
          'رابط الخطاب: https://emsg.elite-center-ld.com/share/${_letterData?['share_token'] ?? widget.letterId}',
          subject: 'مشاركة خطاب',
        );
        break;
    }
  }
}
