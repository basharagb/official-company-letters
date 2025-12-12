<?php

namespace App\Http\Controllers;

use App\Helpers\HijriDate;
use App\Models\Letter;
use App\Models\LetterTemplate;
use App\Models\LetterVersion;
use App\Models\Recipient;
use App\Models\Organization;
use App\Models\RecipientTitle;
use App\Models\LetterSubject;
use Barryvdh\DomPDF\Facade\Pdf;
use Carbon\Carbon;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Mail;
use Illuminate\Support\Facades\Storage;

class LetterController extends Controller
{
    /**
     * عرض صفحة إنشاء خطاب جديد
     */
    public function create()
    {
        $companyId = Auth::user()->company_id;

        $templates = LetterTemplate::where('company_id', $companyId)
            ->where('is_active', true)
            ->get();

        // جلب البيانات المحفوظة للاختيار
        $recipients = Recipient::where('company_id', $companyId)
            ->active()
            ->orderBy('name')
            ->get();

        $organizations = Organization::where('company_id', $companyId)
            ->active()
            ->orderBy('name')
            ->get();

        $recipientTitles = RecipientTitle::where('company_id', $companyId)
            ->active()
            ->orderBy('title')
            ->get();

        $letterSubjects = LetterSubject::where('company_id', $companyId)
            ->active()
            ->orderBy('subject')
            ->get();
        
        return view('letters.create', compact(
            'templates',
            'recipients',
            'organizations',
            'recipientTitles',
            'letterSubjects'
        ));
    }

    /**
     * حفظ خطاب جديد
     */
    public function store(Request $request)
    {
        $request->validate([
            'subject' => 'required|string|max:255',
            'content' => 'required|string',
            'recipient_name' => 'nullable|string|max:255',
            'recipient_title' => 'nullable|string|max:255',
            'recipient_organization' => 'nullable|string|max:255',
            'template_id' => 'nullable|exists:letter_templates,id',
        ]);

        $company = Auth::user()->company;
        
        // توليد رقم الصادر التلقائي
        $referenceNumber = $company->getNextReferenceNumber();
        
        // التاريخ الميلادي والهجري
        $gregorianDate = Carbon::now();
        $hijriDate = HijriDate::toHijri($gregorianDate);

        $letter = Letter::create([
            'company_id' => $company->id,
            'reference_number' => $referenceNumber,
            'subject' => $request->subject,
            'recipient_name' => $request->recipient_name,
            'recipient_title' => $request->recipient_title,
            'recipient_organization' => $request->recipient_organization,
            'content' => $request->content,
            'author_id' => Auth::id(),
            'creation_date' => $gregorianDate,
            'gregorian_date' => $gregorianDate,
            'hijri_date' => $hijriDate,
            'template_id' => $request->template_id,
            'styles' => $request->styles ?? [],
            'status' => 'draft',
        ]);

        // حفظ الإصدار الأول
        LetterVersion::create([
            'letter_id' => $letter->id,
            'editor_id' => Auth::id(),
            'edited_date' => now(),
            'version_number' => 1,
            'content' => $letter->content,
        ]);

        return redirect()->route('letters.show', $letter->id)
            ->with('success', 'تم إنشاء الخطاب بنجاح. رقم الصادر: ' . $referenceNumber);
    }

    /**
     * عرض خطاب محدد
     */
    public function show($id)
    {
        $letter = Letter::with(['author', 'company', 'versions'])->findOrFail($id);
        
        // التحقق من الصلاحية
        if ($letter->company_id != Auth::user()->company_id) {
            abort(403, 'غير مصرح لك بعرض هذا الخطاب');
        }

        return view('letters.show', compact('letter'));
    }

    /**
     * عرض صفحة تعديل الخطاب
     */
    public function edit($id)
    {
        $letter = Letter::findOrFail($id);
        
        if ($letter->author_id != Auth::id() && !Auth::user()->isAdmin()) {
            return redirect()->route('dashboard')->with('error', 'غير مصرح لك بتعديل هذا الخطاب');
        }

        $templates = LetterTemplate::where('company_id', Auth::user()->company_id)
            ->where('is_active', true)
            ->get();

        return view('letters.edit', compact('letter', 'templates'));
    }

    /**
     * تحديث الخطاب
     */
    public function update(Request $request, $id)
    {
        $letter = Letter::findOrFail($id);

        if ($letter->author_id != Auth::id() && !Auth::user()->isAdmin()) {
            return redirect()->route('dashboard')->with('error', 'غير مصرح لك بتعديل هذا الخطاب');
        }

        $request->validate([
            'subject' => 'required|string|max:255',
            'content' => 'required|string',
        ]);

        // حفظ الإصدار السابق
        $newVersion = $letter->versions()->max('version_number') + 1;
        LetterVersion::create([
            'letter_id' => $letter->id,
            'editor_id' => Auth::id(),
            'edited_date' => now(),
            'version_number' => $newVersion,
            'content' => $request->content,
        ]);

        $letter->update([
            'subject' => $request->subject,
            'content' => $request->content,
            'recipient_name' => $request->recipient_name,
            'recipient_title' => $request->recipient_title,
            'recipient_organization' => $request->recipient_organization,
        ]);

        return redirect()->route('letters.show', $letter->id)
            ->with('success', 'تم تحديث الخطاب بنجاح');
    }

    /**
     * إصدار الخطاب (تغيير الحالة)
     */
    public function issue($id)
    {
        $letter = Letter::findOrFail($id);
        $letter->update(['status' => 'issued']);
        
        // توليد PDF
        $this->generatePdf($letter);

        return redirect()->route('letters.show', $letter->id)
            ->with('success', 'تم إصدار الخطاب بنجاح');
    }

    /**
     * تصدير الخطاب كـ PDF
     */
    public function exportPdf($id)
    {
        $letter = Letter::with(['author', 'company'])->findOrFail($id);
        $company = $letter->company;
        
        // اختيار القالب المناسب بناءً على إعدادات الشركة
        $view = $company->letterhead_file ? 'letters.pdf-letterhead' : 'letters.pdf';
        
        $pdf = Pdf::loadView($view, compact('letter', 'company'));
        $pdf->setPaper('A4');
        
        return $pdf->download("letter-{$letter->reference_number}.pdf");
    }

    /**
     * توليد وحفظ PDF
     */
    private function generatePdf(Letter $letter)
    {
        $letter->load(['author', 'company']);
        $company = $letter->company;
        
        // اختيار القالب المناسب بناءً على إعدادات الشركة
        $view = $company->letterhead_file ? 'letters.pdf-letterhead' : 'letters.pdf';
        
        $pdf = Pdf::loadView($view, compact('letter', 'company'));
        $pdfPath = "letters/pdf/{$letter->reference_number}.pdf";
        
        Storage::disk('public')->put($pdfPath, $pdf->output());
        
        $letter->update(['pdf_path' => $pdfPath]);
    }

    /**
     * عرض خطاب عبر رابط المشاركة
     */
    public function share($token)
    {
        $letter = Letter::where('share_token', $token)
            ->with(['author', 'company'])
            ->firstOrFail();

        return view('letters.share', compact('letter'));
    }

    /**
     * إرسال الخطاب بالبريد الإلكتروني
     */
    public function sendEmail(Request $request, $id)
    {
        $request->validate([
            'email' => 'required|email',
            'message' => 'nullable|string',
        ]);

        $letter = Letter::with(['author', 'company'])->findOrFail($id);
        
        // توليد PDF إذا لم يكن موجوداً
        if (!$letter->pdf_path) {
            $this->generatePdf($letter);
            $letter->refresh();
        }

        // إرسال البريد
        Mail::send('emails.letter', [
            'letter' => $letter,
            'customMessage' => $request->message,
        ], function ($mail) use ($request, $letter) {
            $mail->to($request->email)
                ->subject('خطاب رسمي: ' . $letter->subject)
                ->attach(Storage::disk('public')->path($letter->pdf_path));
        });

        $letter->update(['status' => 'sent']);

        return redirect()->route('letters.show', $letter->id)
            ->with('success', 'تم إرسال الخطاب بنجاح إلى ' . $request->email);
    }

    /**
     * نسخ رابط المشاركة
     */
    public function getShareLink($id)
    {
        $letter = Letter::findOrFail($id);
        
        return response()->json([
            'link' => $letter->share_url,
        ]);
    }

    /**
     * البحث في الخطابات
     */
    public function search(Request $request)
    {
        $query = Letter::where('company_id', Auth::user()->company_id)
            ->with(['author']);

        // البحث النصي
        if ($request->filled('q')) {
            $query->search($request->q);
        }

        // فلترة بالتاريخ
        if ($request->filled('from') || $request->filled('to')) {
            $query->dateRange($request->from, $request->to);
        }

        // فلترة بالحالة
        if ($request->filled('status')) {
            $query->where('status', $request->status);
        }

        $letters = $query->orderBy('created_at', 'desc')->paginate(20);

        return view('letters.search', compact('letters'));
    }
}
