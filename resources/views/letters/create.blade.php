@extends('layouts.template')
@section('title', 'إنشاء خطاب جديد')

@section('content')
    <div class="container">
        <div class="row justify-content-center">
            <div class="col-lg-10">
                <div class="card shadow-sm">
                    <div class="card-header bg-primary text-white">
                        <h5 class="mb-0">
                            <i class="bi bi-plus-circle"></i> إنشاء خطاب جديد
                        </h5>
                    </div>
                    <div class="card-body">
                        <form method="POST" action="{{ route('letters.store') }}">
                            @csrf

                            <!-- معلومات المستلم -->
                            <div class="row mb-4">
                                <div class="col-12">
                                    <h6 class="text-muted border-bottom pb-2">
                                        <i class="bi bi-person"></i> معلومات المستلم
                                    </h6>
                                </div>
                                <div class="col-md-4 mb-3">
                                    <label class="form-label">اسم المستلم</label>
                                    <div class="input-group">
                                        <select class="form-select" id="recipientSelect" onchange="fillRecipientName()">
                                            <option value="">-- اختر أو اكتب --</option>
                                            @foreach($recipients as $recipient)
                                                <option value="{{ $recipient->name }}" data-title="{{ $recipient->title }}">
                                                    {{ $recipient->name }}
                                                </option>
                                            @endforeach
                                        </select>
                                    </div>
                                    <input type="text" class="form-control mt-2" name="recipient_name"
                                        id="recipientNameInput" placeholder="أو اكتب اسماً جديداً...">
                                </div>
                                <div class="col-md-4 mb-3">
                                    <label class="form-label">صفة المستلم</label>
                                    <div class="input-group">
                                        <select class="form-select" id="titleSelect" onchange="fillRecipientTitle()">
                                            <option value="">-- اختر أو اكتب --</option>
                                            @foreach($recipientTitles as $title)
                                                <option value="{{ $title->title }}">{{ $title->title }}</option>
                                            @endforeach
                                        </select>
                                    </div>
                                    <input type="text" class="form-control mt-2" name="recipient_title"
                                        id="recipientTitleInput" placeholder="أو اكتب صفة جديدة...">
                                </div>
                                <div class="col-md-4 mb-3">
                                    <label class="form-label">الجهة</label>
                                    <div class="input-group">
                                        <select class="form-select" id="organizationSelect" onchange="fillOrganization()">
                                            <option value="">-- اختر أو اكتب --</option>
                                            @foreach($organizations as $org)
                                                <option value="{{ $org->name }}">{{ $org->name }}</option>
                                            @endforeach
                                        </select>
                                    </div>
                                    <input type="text" class="form-control mt-2" name="recipient_organization"
                                        id="organizationInput" placeholder="أو اكتب جهة جديدة...">
                                </div>
                            </div>

                            <!-- موضوع الخطاب -->
                            <div class="mb-4">
                                <h6 class="text-muted border-bottom pb-2">
                                    <i class="bi bi-card-heading"></i> موضوع الخطاب
                                </h6>
                                <div class="input-group mb-2">
                                    <select class="form-select" id="subjectSelect" onchange="fillSubject()">
                                        <option value="">-- اختر من المواضيع المحفوظة أو اكتب موضوعاً جديداً --</option>
                                        @foreach($letterSubjects as $subj)
                                            <option value="{{ $subj->subject }}">{{ $subj->subject }}</option>
                                        @endforeach
                                    </select>
                                </div>
                                <input type="text" class="form-control form-control-lg" name="subject" id="subjectInput"
                                    placeholder="أو اكتب موضوعاً جديداً..." required>
                            </div>

                            <!-- القالب -->
                            @if($templates->count() > 0)
                                <div class="mb-4">
                                    <h6 class="text-muted border-bottom pb-2">
                                        <i class="bi bi-file-earmark-text"></i> اختر قالب (اختياري)
                                    </h6>
                                    <select class="form-select" name="template_id" id="templateSelect">
                                        <option value="">-- بدون قالب --</option>
                                        @foreach($templates as $template)
                                            <option value="{{ $template->id }}" data-content="{{ $template->content }}">
                                                {{ $template->name }}
                                            </option>
                                        @endforeach
                                    </select>
                                </div>
                            @endif

                            <!-- خيارات التنسيق -->
                            <div class="mb-4">
                                <h6 class="text-muted border-bottom pb-2">
                                    <i class="bi bi-palette"></i> خيارات التنسيق
                                </h6>
                                <div class="row">
                                    <div class="col-md-3 mb-3">
                                        <label class="form-label">نوع الخط</label>
                                        <select class="form-select" name="styles[font_family]" id="fontFamily">
                                            <option value="Cairo">Cairo (كايرو)</option>
                                            <option value="Tajawal">Tajawal (تجوال)</option>
                                            <option value="Amiri">Amiri (أميري)</option>
                                            <option value="Noto Naskh Arabic">Noto Naskh Arabic</option>
                                        </select>
                                    </div>
                                    <div class="col-md-3 mb-3">
                                        <label class="form-label">حجم الخط</label>
                                        <select class="form-select" name="styles[font_size]" id="fontSize">
                                            <option value="14">14px</option>
                                            <option value="16" selected>16px</option>
                                            <option value="18">18px</option>
                                            <option value="20">20px</option>
                                        </select>
                                    </div>
                                    <div class="col-md-3 mb-3">
                                        <label class="form-label">لون النص</label>
                                        <input type="color" class="form-control form-control-color w-100"
                                            name="styles[text_color]" value="#333333" id="textColor">
                                    </div>
                                    <div class="col-md-3 mb-3">
                                        <label class="form-label">محاذاة النص</label>
                                        <select class="form-select" name="styles[text_align]" id="textAlign">
                                            <option value="right">يمين</option>
                                            <option value="center">وسط</option>
                                            <option value="justify" selected>ضبط</option>
                                        </select>
                                    </div>
                                </div>
                            </div>

                            <!-- محتوى الخطاب -->
                            <div class="mb-4">
                                <h6 class="text-muted border-bottom pb-2">
                                    <i class="bi bi-body-text"></i> محتوى الخطاب
                                </h6>
                                <textarea class="form-control" name="content" id="content" rows="12"
                                    placeholder="اكتب محتوى الخطاب هنا..." required
                                    style="font-size: 16px; line-height: 1.8;"></textarea>
                                <small class="text-muted">
                                    يمكنك استخدام المتغيرات: {recipient_name}, {recipient_title}, {date}
                                </small>
                            </div>

                            <!-- أزرار الإجراءات -->
                            <div class="d-flex gap-2">
                                <button type="submit" class="btn btn-primary btn-lg">
                                    <i class="bi bi-check-circle"></i> حفظ الخطاب
                                </button>
                                <a href="{{ route('dashboard') }}" class="btn btn-secondary btn-lg">
                                    <i class="bi bi-x-circle"></i> إلغاء
                                </a>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>

    @push('scripts')
        <script>
            // تحميل محتوى القالب عند الاختيار
            document.getElementById('templateSelect')?.addEventListener('change', function () {
                const selectedOption = this.options[this.selectedIndex];
                const content = selectedOption.dataset.content;
                if (content) {
                    document.getElementById('content').value = content;
                }
            });

            // تعبئة اسم المستلم من القائمة
            function fillRecipientName() {
                const select = document.getElementById('recipientSelect');
                const input = document.getElementById('recipientNameInput');
                const titleInput = document.getElementById('recipientTitleInput');

                if (select.value) {
                    input.value = select.value;
                    // تعبئة الصفة تلقائياً إذا كانت موجودة
                    const selectedOption = select.options[select.selectedIndex];
                    const title = selectedOption.dataset.title;
                    if (title && titleInput) {
                        titleInput.value = title;
                    }
                }
            }

            // تعبئة صفة المستلم من القائمة
            function fillRecipientTitle() {
                const select = document.getElementById('titleSelect');
                const input = document.getElementById('recipientTitleInput');
                if (select.value) {
                    input.value = select.value;
                }
            }

            // تعبئة الجهة من القائمة
            function fillOrganization() {
                const select = document.getElementById('organizationSelect');
                const input = document.getElementById('organizationInput');
                if (select.value) {
                    input.value = select.value;
                }
            }

            // تعبئة موضوع الخطاب من القائمة
            function fillSubject() {
                const select = document.getElementById('subjectSelect');
                const input = document.getElementById('subjectInput');
                if (select.value) {
                    input.value = select.value;
                }
            }
        </script>
    @endpush
@endsection