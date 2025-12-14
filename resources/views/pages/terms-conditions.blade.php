@extends('layouts.public')

@section('title', 'Terms & Conditions')

@section('content')
    <p class="last-updated">Last updated: {{ date('Y-m-d') }}</p>

    <div class="info-box">
        <p><i class="fas fa-info-circle me-2"></i> By using the "Official Letters" application, you agree to be bound by
            these Terms & Conditions.</p>
    </div>

    <div class="section">
        <h3 class="section-title">
            <i class="fas fa-handshake"></i>
            1. Acceptance of Terms
        </h3>
        <p>
            By accessing or using the "Official Letters" application (the "App"), you agree to
            comply with and be bound by these Terms & Conditions. If you do not agree with any part
            of these Terms, please do not use the App.
        </p>
    </div>

    <div class="section">
        <h3 class="section-title">
            <i class="fas fa-concierge-bell"></i>
            2. Service Description
        </h3>
        <p>The App provides the following services:</p>
        <div class="feature-grid">
            <div class="feature-item">
                <i class="fas fa-check-circle"></i>
                <span>Create and manage official letters for companies</span>
            </div>
            <div class="feature-item">
                <i class="fas fa-check-circle"></i>
                <span>Manage letterhead templates and logos</span>
            </div>
            <div class="feature-item">
                <i class="fas fa-check-circle"></i>
                <span>Archive letters and search within them</span>
            </div>
            <div class="feature-item">
                <i class="fas fa-check-circle"></i>
                <span>Export letters as PDF</span>
            </div>
            <div class="feature-item">
                <i class="fas fa-check-circle"></i>
                <span>Share letters via email and messaging apps</span>
            </div>
        </div>
    </div>

    <div class="section">
        <h3 class="section-title">
            <i class="fas fa-user-plus"></i>
            3. Registration & Account
        </h3>
        <ul>
            <li>You must be 18 years or older to use the App.</li>
            <li>You are responsible for maintaining the confidentiality of your account credentials.</li>
            <li>You must provide accurate and complete information when creating an account.</li>
            <li>You are responsible for all activities performed under your account.</li>
            <li>You must notify us immediately if you suspect unauthorized use of your account.</li>
        </ul>
    </div>

    <div class="section">
        <h3 class="section-title">
            <i class="fas fa-gavel"></i>
            4. Acceptable Use
        </h3>
        <p>When using the App, you agree that you will:</p>
        <div class="allowed-prohibited">
            <div class="allowed-box">
                <div class="box-header">
                    <i class="fas fa-check me-2"></i>Allowed
                </div>
                <div class="box-content">
                    <ul>
                        <li>Use the App for lawful business purposes</li>
                        <li>Create official letters for your company</li>
                        <li>Share letters with intended recipients</li>
                        <li>Store your company data securely</li>
                    </ul>
                </div>
            </div>
            <div class="prohibited-box">
                <div class="box-header">
                    <i class="fas fa-times me-2"></i>Prohibited
                </div>
                <div class="box-content">
                    <ul>
                        <li>Use the App for illegal activities</li>
                        <li>Impersonate another person or organization</li>
                        <li>Attempt to hack or disrupt the service</li>
                        <li>Upload harmful, abusive, or infringing content</li>
                    </ul>
                </div>
            </div>
        </div>
    </div>

    <div class="section">
        <h3 class="section-title">
            <i class="fas fa-copyright"></i>
            5. Intellectual Property
        </h3>
        <ul>
            <li>All intellectual property rights in the App are owned by us or our licensors.</li>
            <li>You retain ownership of the content you create (letters, logos, etc.).</li>
            <li>By creating content in the App, you grant us a license to store and process it to provide the service.</li>
            <li>You may not copy, distribute, or modify the App without written permission.</li>
        </ul>
    </div>

    <div class="section">
        <h3 class="section-title">
            <i class="fas fa-credit-card"></i>
            6. Subscriptions & Payments
        </h3>
        <ul>
            <li>Some features may require a paid subscription.</li>
            <li>Prices may change with prior notice.</li>
            <li>Subscriptions may renew automatically unless canceled.</li>
            <li>Refunds are provided only in limited cases where required by law or policy.</li>
        </ul>
    </div>

    <div class="section">
        <h3 class="section-title">
            <i class="fas fa-exclamation-triangle"></i>
            7. Disclaimer
        </h3>
        <div class="warning-box">
            <ul>
                <li>The App is provided "as is" without warranties of any kind.</li>
                <li>We do not guarantee uninterrupted or error-free service.</li>
                <li>You are responsible for reviewing and verifying letters before sending them.</li>
                <li>We are not liable for damages arising from your use of the App.</li>
            </ul>
        </div>
    </div>

    <div class="section">
        <h3 class="section-title">
            <i class="fas fa-balance-scale"></i>
            8. Limitation of Liability
        </h3>
        <p>
            To the maximum extent permitted by law, we will not be liable for any indirect,
            incidental, special, or consequential damages arising out of or related to your use of
            (or inability to use) the App.
        </p>
    </div>

    <div class="section">
        <h3 class="section-title">
            <i class="fas fa-ban"></i>
            9. Termination
        </h3>
        <ul>
            <li>You may delete your account at any time.</li>
            <li>We may suspend or terminate your account if you violate these Terms.</li>
            <li>Upon termination, your data may be deleted in accordance with the Privacy Policy.</li>
        </ul>
    </div>

    <div class="section">
        <h3 class="section-title">
            <i class="fas fa-sync-alt"></i>
            10. Changes to These Terms
        </h3>
        <p>
            We reserve the right to modify these Terms at any time. We may notify you of material
            changes via email or an in-app notice. Continued use of the App after changes become
            effective constitutes acceptance of the updated Terms.
        </p>
    </div>

    <div class="section">
        <h3 class="section-title">
            <i class="fas fa-globe"></i>
            11. Governing Law
        </h3>
        <p>
            These Terms are governed by applicable laws. Any disputes arising from these Terms
            will be subject to the exclusive jurisdiction of the competent courts.
        </p>
    </div>

    <div class="section">
        <h3 class="section-title">
            <i class="fas fa-envelope"></i>
            12. Contact Us
        </h3>
        <p>If you have any questions about these Terms & Conditions, please contact us:</p>
        <div class="contact-card">
            <p><i class="fas fa-envelope me-2"></i>Email: support@elite-center-ld.com</p>
            <p><i class="fas fa-globe me-2"></i>Website: https://emsg.elite-center-ld.com</p>
        </div>
    </div>

    <div class="info-box" style="margin-top: 30px; text-align: center;">
        <p><i class="fas fa-check-circle text-success me-2"></i> By using the App, you acknowledge that you have read,
            understood, and agreed to these Terms & Conditions.</p>
    </div>
@endsection