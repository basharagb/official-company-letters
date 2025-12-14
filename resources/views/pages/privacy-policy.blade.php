@extends('layouts.public')

@section('title', 'Privacy Policy')

@section('content')
    <p class="last-updated">Last updated: {{ date('Y-m-d') }}</p>

    <div class="section">
        <h3 class="section-title">
            <i class="fas fa-info-circle"></i>
            Introduction
        </h3>
        <p>
            Welcome to the "Official Letters" application. We value your trust and are committed to
            protecting your privacy and personal data. This Privacy Policy explains how we collect,
            use, and protect information when you use our services.
        </p>
    </div>

    <div class="section">
        <h3 class="section-title">
            <i class="fas fa-database"></i>
            Information We Collect
        </h3>
        <p>We may collect the following types of information:</p>
        <ul>
            <li><strong>Account Information:</strong> name, email address, phone number, and company name during
                registration.</li>
            <li><strong>Company Data:</strong> company logo, signature, stamp, and address used in official letters.</li>
            <li><strong>Letter Content:</strong> text and documents you create within the app.</li>
            <li><strong>Photos & Files:</strong> images/files you upload for logos, templates, and signatures.</li>
            <li><strong>Usage Data:</strong> information about how you use the app to help us improve our services.</li>
        </ul>
    </div>

    <div class="section">
        <h3 class="section-title">
            <i class="fas fa-mobile-alt"></i>
            Permissions We Request
        </h3>
        <p>The app requests the following permissions to provide its features:</p>
        <div class="permission-grid">
            <div class="permission-card camera">
                <i class="fas fa-camera"></i>
                <h6>Camera</h6>
                <p>Used to scan documents and letterheads. We access the camera only when you explicitly choose to use it.
                </p>
            </div>
            <div class="permission-card photos">
                <i class="fas fa-images"></i>
                <h6>Photo Library</h6>
                <p>Used to select logos, stamps, and signatures from your gallery. We only access items you select.</p>
            </div>
            <div class="permission-card notifications">
                <i class="fas fa-bell"></i>
                <h6>Notifications</h6>
                <p>Used to notify you about important updates. You can disable notifications in your device settings.</p>
            </div>
            <div class="permission-card files">
                <i class="fas fa-folder"></i>
                <h6>Files</h6>
                <p>Used to export and save letters as PDF files. We only access files you select or create.</p>
            </div>
        </div>
    </div>

    <div class="section">
        <h3 class="section-title">
            <i class="fas fa-cogs"></i>
            How We Use Your Information
        </h3>
        <div class="feature-grid">
            <div class="feature-item">
                <i class="fas fa-check-circle"></i>
                <span>Create and manage your account</span>
            </div>
            <div class="feature-item">
                <i class="fas fa-check-circle"></i>
                <span>Provide letter creation services</span>
            </div>
            <div class="feature-item">
                <i class="fas fa-check-circle"></i>
                <span>Store templates and company settings</span>
            </div>
            <div class="feature-item">
                <i class="fas fa-check-circle"></i>
                <span>Send important notifications</span>
            </div>
            <div class="feature-item">
                <i class="fas fa-check-circle"></i>
                <span>Improve and develop our services</span>
            </div>
            <div class="feature-item">
                <i class="fas fa-check-circle"></i>
                <span>Comply with legal requirements</span>
            </div>
        </div>
    </div>

    <div class="section">
        <h3 class="section-title">
            <i class="fas fa-lock"></i>
            Data Security
        </h3>
        <p>We take reasonable security measures to protect your data, including:</p>
        <ul>
            <li>Encryption in transit and at rest</li>
            <li>Secure infrastructure</li>
            <li>Restricted access for authorized staff only</li>
            <li>Periodic security reviews</li>
        </ul>
    </div>

    <div class="section">
        <h3 class="section-title">
            <i class="fas fa-share-alt"></i>
            Data Sharing
        </h3>
        <div class="info-box">
            <p><strong>We do not sell or rent your personal data to third parties.</strong></p>
        </div>
        <p>We may share your data only in the following cases:</p>
        <ul>
            <li>With your explicit consent</li>
            <li>To comply with legal obligations</li>
            <li>To protect our rights or user safety</li>
        </ul>
    </div>

    <div class="section">
        <h3 class="section-title">
            <i class="fas fa-user-shield"></i>
            Your Rights
        </h3>
        <p>You may have the following rights regarding your data:</p>
        <ul>
            <li>Access your personal data</li>
            <li>Correct inaccurate data</li>
            <li>Delete your account and data</li>
            <li>Export your data</li>
            <li>Object to certain processing</li>
        </ul>
    </div>

    <div class="section">
        <h3 class="section-title">
            <i class="fas fa-clock"></i>
            Data Retention
        </h3>
        <p>
            We retain your data as long as your account is active or as needed to provide our
            services. You can request account deletion at any time, and we will delete your data
            within 30 days.
        </p>
    </div>

    <div class="section">
        <h3 class="section-title">
            <i class="fas fa-child"></i>
            Children's Privacy
        </h3>
        <p>
            Our services are not directed to children under the age of 13. We do not knowingly
            collect personal information from children.
        </p>
    </div>

    <div class="section">
        <h3 class="section-title">
            <i class="fas fa-sync-alt"></i>
            Policy Updates
        </h3>
        <p>
            We may update this Privacy Policy from time to time. We will notify you of material
            changes via email or an in-app notice.
        </p>
    </div>

    <div class="section">
        <h3 class="section-title">
            <i class="fas fa-envelope"></i>
            Contact Us
        </h3>
        <p>If you have any questions about this Privacy Policy, please contact us:</p>
        <div class="contact-card">
            <p><i class="fas fa-envelope me-2"></i>Email: support@elite-center-ld.com</p>
            <p><i class="fas fa-globe me-2"></i>Website: https://emsg.elite-center-ld.com</p>
        </div>
    </div>
@endsection