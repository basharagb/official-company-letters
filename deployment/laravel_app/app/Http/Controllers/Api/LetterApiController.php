<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
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

class LetterApiController extends Controller
{
    /**
     * قائمة جميع الخطابات
     */
    public function index(Request $request)
    {
        $companyId = Auth::user()->company_id;

        $query = Letter::where('company_id', $companyId)
            ->with(['author', 'template']);

        // البحث
        if ($request->filled('search')) {
            $query->search($request->search);
        }

        // فلترة بالحالة
        if ($request->filled('status')) {
            $query->where('status', $request->status);
        }

        // فلترة بالتاريخ
        if ($request->filled('from') || $request->filled('to')) {
            $query->dateRange($request->from, $request->to);
        }

        $letters = $query->orderBy('created_at', 'desc')
            ->paginate($request->per_page ?? 20);

        return response()->json([
            'success' => true,
            'data' => $letters,
        ]);
    }

    /**
     * البيانات المطلوبة لإنشاء خطاب
     */
    public function createData()
    {
        $companyId = Auth::user()->company_id;

        return response()->json([
            'success' => true,
            'data' => [
                'templates' => LetterTemplate::where('company_id', $companyId)
                    ->where('is_active', true)
                    ->get(),
                'recipients' => Recipient::where('company_id', $companyId)
                    ->active()
                    ->orderBy('name')
                    ->get(),
                'organizations' => Organization::where('company_id', $companyId)
                    ->active()
                    ->orderBy('name')
                    ->get(),
                'recipient_titles' => RecipientTitle::where('company_id', $companyId)
                    ->active()
                    ->orderBy('title')
                    ->get(),
                'letter_subjects' => LetterSubject::where('company_id', $companyId)
                    ->active()
                    ->orderBy('subject')
                    ->get(),
            ],
        ]);
    }

    /**
     * إنشاء خطاب جديد
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
        
        $referenceNumber = $company->getNextReferenceNumber();
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

        LetterVersion::create([
            'letter_id' => $letter->id,
            'editor_id' => Auth::id(),
            'edited_date' => now(),
            'version_number' => 1,
            'content' => $letter->content,
        ]);

        return response()->json([
            'success' => true,
            'message' => 'تم إنشاء الخطاب بنجاح',
            'data' => $letter->load(['author', 'company', 'template']),
        ], 201);
    }

    /**
     * عرض خطاب محدد
     */
    public function show($id)
    {
        $letter = Letter::with(['author', 'company', 'versions', 'template'])
            ->findOrFail($id);
        
        if ($letter->company_id != Auth::user()->company_id) {
            return response()->json([
                'success' => false,
                'message' => 'غير مصرح لك بعرض هذا الخطاب',
            ], 403);
        }

        return response()->json([
            'success' => true,
            'data' => $letter,
        ]);
    }

    /**
     * تحديث خطاب
     */
    public function update(Request $request, $id)
    {
        $letter = Letter::findOrFail($id);

        if ($letter->company_id != Auth::user()->company_id) {
            return response()->json([
                'success' => false,
                'message' => 'غير مصرح لك بتعديل هذا الخطاب',
            ], 403);
        }

        $request->validate([
            'subject' => 'required|string|max:255',
            'content' => 'required|string',
        ]);

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

        return response()->json([
            'success' => true,
            'message' => 'تم تحديث الخطاب بنجاح',
            'data' => $letter->fresh(['author', 'company', 'versions']),
        ]);
    }

    /**
     * حذف خطاب
     */
    public function destroy($id)
    {
        $letter = Letter::findOrFail($id);

        if ($letter->company_id != Auth::user()->company_id) {
            return response()->json([
                'success' => false,
                'message' => 'غير مصرح لك بحذف هذا الخطاب',
            ], 403);
        }

        $letter->delete();

        return response()->json([
            'success' => true,
            'message' => 'تم حذف الخطاب بنجاح',
        ]);
    }

    /**
     * إصدار الخطاب
     */
    public function issue($id)
    {
        $letter = Letter::findOrFail($id);

        if ($letter->company_id != Auth::user()->company_id) {
            return response()->json([
                'success' => false,
                'message' => 'غير مصرح لك',
            ], 403);
        }

        $letter->update(['status' => 'issued']);
        $this->generatePdf($letter);

        return response()->json([
            'success' => true,
            'message' => 'تم إصدار الخطاب بنجاح',
            'data' => $letter->fresh(),
        ]);
    }

    /**
     * تصدير PDF
     */
    public function exportPdf($id)
    {
        $letter = Letter::with(['author', 'company'])->findOrFail($id);

        if ($letter->company_id != Auth::user()->company_id) {
            return response()->json([
                'success' => false,
                'message' => 'غير مصرح لك',
            ], 403);
        }

        $pdf = Pdf::loadView('letters.pdf', compact('letter'));
        $pdf->setPaper('A4');
        
        return $pdf->download("letter-{$letter->reference_number}.pdf");
    }

    /**
     * الحصول على رابط PDF
     */
    public function getPdfUrl($id)
    {
        $letter = Letter::findOrFail($id);

        if ($letter->company_id != Auth::user()->company_id) {
            return response()->json([
                'success' => false,
                'message' => 'غير مصرح لك',
            ], 403);
        }

        if (!$letter->pdf_path) {
            $this->generatePdf($letter);
            $letter->refresh();
        }

        return response()->json([
            'success' => true,
            'data' => [
                'pdf_url' => $letter->pdf_path ? Storage::disk('public')->url($letter->pdf_path) : null,
            ],
        ]);
    }

    /**
     * الحصول على رابط المشاركة
     */
    public function getShareLink($id)
    {
        $letter = Letter::findOrFail($id);

        if ($letter->company_id != Auth::user()->company_id) {
            return response()->json([
                'success' => false,
                'message' => 'غير مصرح لك',
            ], 403);
        }

        return response()->json([
            'success' => true,
            'data' => [
                'share_url' => $letter->share_url,
                'share_token' => $letter->share_token,
            ],
        ]);
    }

    /**
     * إرسال بالبريد الإلكتروني
     */
    public function sendEmail(Request $request, $id)
    {
        $request->validate([
            'email' => 'required|email',
            'message' => 'nullable|string',
        ]);

        $letter = Letter::with(['author', 'company'])->findOrFail($id);

        if ($letter->company_id != Auth::user()->company_id) {
            return response()->json([
                'success' => false,
                'message' => 'غير مصرح لك',
            ], 403);
        }

        if (!$letter->pdf_path) {
            $this->generatePdf($letter);
            $letter->refresh();
        }

        Mail::send('emails.letter', [
            'letter' => $letter,
            'customMessage' => $request->message,
        ], function ($mail) use ($request, $letter) {
            $mail->to($request->email)
                ->subject('خطاب رسمي: ' . $letter->subject)
                ->attach(Storage::disk('public')->path($letter->pdf_path));
        });

        $letter->update(['status' => 'sent']);

        return response()->json([
            'success' => true,
            'message' => 'تم إرسال الخطاب بنجاح',
        ]);
    }

    /**
     * إحصائيات الخطابات
     */
    public function statistics()
    {
        $companyId = Auth::user()->company_id;

        return response()->json([
            'success' => true,
            'data' => [
                'total' => Letter::where('company_id', $companyId)->count(),
                'draft' => Letter::where('company_id', $companyId)->where('status', 'draft')->count(),
                'issued' => Letter::where('company_id', $companyId)->where('status', 'issued')->count(),
                'sent' => Letter::where('company_id', $companyId)->where('status', 'sent')->count(),
                'this_month' => Letter::where('company_id', $companyId)
                    ->whereMonth('created_at', now()->month)
                    ->count(),
                'this_year' => Letter::where('company_id', $companyId)
                    ->whereYear('created_at', now()->year)
                    ->count(),
            ],
        ]);
    }

    /**
     * توليد PDF
     */
    private function generatePdf(Letter $letter)
    {
        $letter->load(['author', 'company']);
        
        $pdf = Pdf::loadView('letters.pdf', compact('letter'));
        $pdfPath = "letters/pdf/{$letter->reference_number}.pdf";
        
        Storage::disk('public')->put($pdfPath, $pdf->output());
        
        $letter->update(['pdf_path' => $pdfPath]);
    }
}
