@extends('layouts.template')
@section('title', 'عرض الخطاب - ' . $letter->reference_number)

@section('content')
  <div class="container">
    <div class="row">
      <!-- معلومات الخطاب -->
      <div class="col-lg-8">
        <div class="card shadow-sm mb-4">
          <div class="card-header bg-primary text-white d-flex justify-content-between align-items-center">
            <h5 class="mb-0">
              <i class="bi bi-envelope-paper"></i> {{ $letter->subject }}
            </h5>
            @php
              $statusColors = [
                'draft' => 'warning',
                'issued' => 'info',
                'sent' => 'success',
                'archived' => 'secondary'
              ];
              $statusLabels = [
                'draft' => 'مسودة',
                'issued' => 'صادر',
                'sent' => 'مُرسل',
                'archived' => 'مؤرشف'
              ];
            @endphp
            <span class="badge bg-{{ $statusColors[$letter->status] ?? 'secondary' }}">
              {{ $statusLabels[$letter->status] ?? $letter->status }}
            </span>
          </div>
          <div class="card-body">
            <!-- معلومات الخطاب -->
            <div class="row mb-4">
              <div class="col-md-6">
                <p class="mb-2">
                  <strong><i class="bi bi-hash"></i> رقم الصادر:</strong>
                  <span class="text-primary fw-bold">{{ $letter->reference_number }}</span>
                </p>
                <p class="mb-2">
                  <strong><i class="bi bi-calendar3"></i> التاريخ الميلادي:</strong>
                  {{ $letter->gregorian_date?->format('Y/m/d') }}
                </p>
                <p class="mb-2">
                  <strong><i class="bi bi-calendar-week"></i> التاريخ الهجري:</strong>
                  {{ $letter->hijri_date }}
                </p>
              </div>
              <div class="col-md-6">
                <p class="mb-2">
                  <strong><i class="bi bi-person"></i> المستلم:</strong>
                  {{ $letter->recipient_name ?? 'غير محدد' }}
                </p>
                <p class="mb-2">
                  <strong><i class="bi bi-building"></i> الجهة:</strong>
                  {{ $letter->recipient_organization ?? 'غير محدد' }}
                </p>
                <p class="mb-2">
                  <strong><i class="bi bi-person-badge"></i> المُصدر:</strong>
                  {{ $letter->author->name }}
                </p>
              </div>
            </div>

            <!-- محتوى الخطاب -->
            <div class="border rounded p-4 bg-light" style="min-height: 300px;">
              <div style="white-space: pre-wrap; line-height: 1.8;">{{ $letter->content }}</div>
            </div>
          </div>
        </div>
      </div>

      <!-- الإجراءات -->
      <div class="col-lg-4">
        <!-- أزرار الإجراءات الرئيسية -->
        <div class="card shadow-sm mb-4">
          <div class="card-header bg-dark text-white">
            <h6 class="mb-0"><i class="bi bi-gear"></i> الإجراءات</h6>
          </div>
          <div class="card-body">
            <div class="d-grid gap-2">
              @if($letter->status === 'draft')
                <form action="{{ route('letters.issue', $letter->id) }}" method="POST">
                  @csrf
                  <button type="submit" class="btn btn-success w-100">
                    <i class="bi bi-check-circle"></i> إصدار الخطاب
                  </button>
                </form>
                <a href="{{ route('letters.edit', $letter->id) }}" class="btn btn-warning">
                  <i class="bi bi-pencil"></i> تعديل
                </a>
              @endif

              <a href="{{ route('letters.pdf', $letter->id) }}" class="btn btn-danger" target="_blank">
                <i class="bi bi-file-pdf"></i> تصدير PDF
              </a>
            </div>
          </div>
        </div>

        <!-- خيارات المشاركة -->
        <div class="card shadow-sm mb-4">
          <div class="card-header bg-info text-white">
            <h6 class="mb-0"><i class="bi bi-share"></i> خيارات الإرسال</h6>
          </div>
          <div class="card-body">
            <div class="d-grid gap-2">
              <!-- إرسال بالإيميل -->
              <button type="button" class="btn btn-outline-primary" data-bs-toggle="modal" data-bs-target="#emailModal">
                <i class="bi bi-envelope"></i> إرسال بالإيميل
              </button>

              <!-- نسخ الرابط -->
              <button type="button" class="btn btn-outline-secondary" onclick="copyShareLink()">
                <i class="bi bi-link-45deg"></i> نسخ رابط المشاركة
              </button>

              <!-- واتساب -->
              <a href="https://wa.me/?text={{ urlencode('خطاب رسمي: ' . $letter->subject . ' - ' . $letter->share_url) }}"
                class="btn btn-outline-success" target="_blank">
                <i class="bi bi-whatsapp"></i> مشاركة عبر واتساب
              </a>

              <!-- تيليجرام -->
              <a href="https://t.me/share/url?url={{ urlencode($letter->share_url) }}&text={{ urlencode($letter->subject) }}"
                class="btn btn-outline-info" target="_blank">
                <i class="bi bi-telegram"></i> مشاركة عبر تيليجرام
              </a>

              <!-- SMS -->
              <a href="sms:?body={{ urlencode('خطاب رسمي: ' . $letter->subject . ' - ' . $letter->share_url) }}"
                class="btn btn-outline-dark">
                <i class="bi bi-chat-dots"></i> إرسال SMS
              </a>

              <!-- تحميل PDF -->
              <a href="{{ route('letters.pdf', $letter->id) }}" class="btn btn-danger" download>
                <i class="bi bi-download"></i> تحميل النسخة الأصلية
              </a>
            </div>

            <hr>
            <p class="text-muted small mb-0">
              <i class="bi bi-info-circle"></i>
              يمكنك أيضاً مشاركة الخطاب عبر AirDrop بتحميل ملف PDF ومشاركته
            </p>
          </div>
        </div>

        <!-- سجل الإصدارات -->
        @if($letter->versions->count() > 1)
          <div class="card shadow-sm">
            <div class="card-header bg-secondary text-white">
              <h6 class="mb-0"><i class="bi bi-clock-history"></i> سجل التعديلات</h6>
            </div>
            <div class="card-body p-0">
              <ul class="list-group list-group-flush">
                @foreach($letter->versions->sortByDesc('version_number') as $version)
                  <li class="list-group-item d-flex justify-content-between align-items-center">
                    <span>الإصدار {{ $version->version_number }}</span>
                    <small class="text-muted">{{ $version->edited_date }}</small>
                  </li>
                @endforeach
              </ul>
            </div>
          </div>
        @endif
      </div>
    </div>
  </div>

  <!-- Modal إرسال بالإيميل -->
  <div class="modal fade" id="emailModal" tabindex="-1">
    <div class="modal-dialog">
      <div class="modal-content">
        <form action="{{ route('letters.email', $letter->id) }}" method="POST">
          @csrf
          <div class="modal-header">
            <h5 class="modal-title">إرسال الخطاب بالبريد الإلكتروني</h5>
            <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
          </div>
          <div class="modal-body">
            <div class="mb-3">
              <label class="form-label">البريد الإلكتروني</label>
              <input type="email" class="form-control" name="email" required placeholder="example@email.com">
            </div>
            <div class="mb-3">
              <label class="form-label">رسالة إضافية (اختياري)</label>
              <textarea class="form-control" name="message" rows="3" placeholder="أضف رسالة مع الخطاب..."></textarea>
            </div>
          </div>
          <div class="modal-footer">
            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">إلغاء</button>
            <button type="submit" class="btn btn-primary">
              <i class="bi bi-send"></i> إرسال
            </button>
          </div>
        </form>
      </div>
    </div>
  </div>

  @push('scripts')
    <script>
      function copyShareLink() {
        fetch('{{ route("letters.share-link", $letter->id) }}')
          .then(response => response.json())
          .then(data => {
            navigator.clipboard.writeText(data.link).then(() => {
              alert('تم نسخ الرابط بنجاح!');
            });
          });
      }
    </script>
  @endpush
@endsection