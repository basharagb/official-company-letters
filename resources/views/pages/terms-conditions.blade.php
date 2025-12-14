@extends('layouts.template')

@section('title', 'Terms & Conditions')

@section('content')
    <div class="container-fluid py-4">
        <div class="row justify-content-center">
            <div class="col-lg-10">
                <div class="card shadow-sm">
                    <div class="card-header bg-primary text-white">
                        <h4 class="mb-0">
                            <i class="fas fa-file-contract me-2"></i>
                            Terms & Conditions
                        </h4>
                    </div>
                    <div class="card-body p-4">
                        <div class="text-muted mb-4">
                            <small>Last updated: {{ date('Y-m-d') }}</small>
                        </div>

                        <div class="alert alert-info mb-4">
                            <i class="fas fa-info-circle me-2"></i>
                            By using the "Official Letters" application, you agree to be bound by these Terms & Conditions.
                        </div>

                        <section class="mb-5">
                            <h5 class="text-primary border-bottom pb-2 mb-3">
                                <i class="fas fa-handshake me-2"></i>
                                1. Acceptance of Terms
                            </h5>
                            <p class="text-justify">
                                By accessing or using the "Official Letters" application (the "App"), you agree to
                                comply with and be bound by these Terms & Conditions. If you do not agree with any part
                                of these Terms, please do not use the App.
                            </p>
                        </section>

                        <section class="mb-5">
                            <h5 class="text-primary border-bottom pb-2 mb-3">
                                <i class="fas fa-concierge-bell me-2"></i>
                                2. Service Description
                            </h5>
                            <p>The App provides the following services:</p>
                            <ul class="list-group list-group-flush mb-3">
                                <li class="list-group-item">
                                    <i class="fas fa-check-circle text-success me-2"></i>
                                    Create and manage official letters for companies
                                </li>
                                <li class="list-group-item">
                                    <i class="fas fa-check-circle text-success me-2"></i>
                                    Manage letterhead templates and logos
                                </li>
                                <li class="list-group-item">
                                    <i class="fas fa-check-circle text-success me-2"></i>
                                    Archive letters and search within them
                                </li>
                                <li class="list-group-item">
                                    <i class="fas fa-check-circle text-success me-2"></i>
                                    Export letters as PDF
                                </li>
                                <li class="list-group-item">
                                    <i class="fas fa-check-circle text-success me-2"></i>
                                    Share letters via email and messaging apps
                                </li>
                            </ul>
                        </section>

                        <section class="mb-5">
                            <h5 class="text-primary border-bottom pb-2 mb-3">
                                <i class="fas fa-user-plus me-2"></i>
                                3. Registration & Account
                            </h5>
                            <ul>
                                <li class="mb-2">You must be 18 years or older to use the App.</li>
                                <li class="mb-2">You are responsible for maintaining the confidentiality of your account
                                    credentials.</li>
                                <li class="mb-2">You must provide accurate and complete information when creating an
                                    account.</li>
                                <li class="mb-2">You are responsible for all activities performed under your account.</li>
                                <li class="mb-2">You must notify us immediately if you suspect unauthorized use of your
                                    account.</li>
                            </ul>
                        </section>

                        <section class="mb-5">
                            <h5 class="text-primary border-bottom pb-2 mb-3">
                                <i class="fas fa-gavel me-2"></i>
                                4. Acceptable Use
                            </h5>
                            <p>When using the App, you agree that you will:</p>
                            <div class="row">
                                <div class="col-md-6">
                                    <div class="card border-success mb-3">
                                        <div class="card-header bg-success text-white">
                                            <i class="fas fa-check me-2"></i>Allowed
                                        </div>
                                        <ul class="list-group list-group-flush">
                                            <li class="list-group-item small">Use the App for lawful business purposes</li>
                                            <li class="list-group-item small">Create official letters for your company</li>
                                            <li class="list-group-item small">Share letters with intended recipients</li>
                                            <li class="list-group-item small">Store your company data securely</li>
                                        </ul>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="card border-danger mb-3">
                                        <div class="card-header bg-danger text-white">
                                            <i class="fas fa-times me-2"></i>Prohibited
                                        </div>
                                        <ul class="list-group list-group-flush">
                                            <li class="list-group-item small">Use the App for illegal activities</li>
                                            <li class="list-group-item small">Impersonate another person or organization
                                            </li>
                                            <li class="list-group-item small">Attempt to hack or disrupt the service</li>
                                            <li class="list-group-item small">Upload harmful, abusive, or infringing content
                                            </li>
                                        </ul>
                                    </div>
                                </div>
                            </div>
                        </section>

                        <section class="mb-5">
                            <h5 class="text-primary border-bottom pb-2 mb-3">
                                <i class="fas fa-copyright me-2"></i>
                                5. Intellectual Property
                            </h5>
                            <ul>
                                <li class="mb-2">All intellectual property rights in the App are owned by us or our
                                    licensors.</li>
                                <li class="mb-2">You retain ownership of the content you create (letters, logos, etc.).</li>
                                <li class="mb-2">By creating content in the App, you grant us a license to store and process
                                    it to provide the service.</li>
                                <li class="mb-2">You may not copy, distribute, or modify the App without written permission.
                                </li>
                            </ul>
                        </section>

                        <section class="mb-5">
                            <h5 class="text-primary border-bottom pb-2 mb-3">
                                <i class="fas fa-credit-card me-2"></i>
                                6. Subscriptions & Payments
                            </h5>
                            <ul>
                                <li class="mb-2">Some features may require a paid subscription.</li>
                                <li class="mb-2">Prices may change with prior notice.</li>
                                <li class="mb-2">Subscriptions may renew automatically unless canceled.</li>
                                <li class="mb-2">Refunds are provided only in limited cases where required by law or policy.
                                </li>
                            </ul>
                        </section>

                        <section class="mb-5">
                            <h5 class="text-primary border-bottom pb-2 mb-3">
                                <i class="fas fa-exclamation-triangle me-2"></i>
                                7. Disclaimer
                            </h5>
                            <div class="alert alert-warning">
                                <ul class="mb-0">
                                    <li class="mb-2">The App is provided "as is" without warranties of any kind.</li>
                                    <li class="mb-2">We do not guarantee uninterrupted or error-free service.</li>
                                    <li class="mb-2">You are responsible for reviewing and verifying letters before sending
                                        them.</li>
                                    <li class="mb-2">We are not liable for damages arising from your use of the App.</li>
                                </ul>
                            </div>
                        </section>

                        <section class="mb-5">
                            <h5 class="text-primary border-bottom pb-2 mb-3">
                                <i class="fas fa-balance-scale me-2"></i>
                                8. Limitation of Liability
                            </h5>
                            <p>
                                To the maximum extent permitted by law, we will not be liable for any indirect,
                                incidental, special, or consequential damages arising out of or related to your use of
                                (or inability to use) the App.
                            </p>
                        </section>

                        <section class="mb-5">
                            <h5 class="text-primary border-bottom pb-2 mb-3">
                                <i class="fas fa-ban me-2"></i>
                                9. Termination
                            </h5>
                            <ul>
                                <li class="mb-2">You may delete your account at any time.</li>
                                <li class="mb-2">We may suspend or terminate your account if you violate these Terms.</li>
                                <li class="mb-2">Upon termination, your data may be deleted in accordance with the Privacy
                                    Policy.</li>
                            </ul>
                        </section>

                        <section class="mb-5">
                            <h5 class="text-primary border-bottom pb-2 mb-3">
                                <i class="fas fa-sync-alt me-2"></i>
                                10. Changes to These Terms
                            </h5>
                            <p>
                                We reserve the right to modify these Terms at any time. We may notify you of material
                                changes via email or an in-app notice. Continued use of the App after changes become
                                effective constitutes acceptance of the updated Terms.
                            </p>
                        </section>

                        <section class="mb-5">
                            <h5 class="text-primary border-bottom pb-2 mb-3">
                                <i class="fas fa-globe me-2"></i>
                                11. Governing Law
                            </h5>
                            <p>
                                These Terms are governed by applicable laws. Any disputes arising from these Terms
                                will be subject to the exclusive jurisdiction of the competent courts.
                            </p>
                        </section>

                        <section class="mb-4">
                            <h5 class="text-primary border-bottom pb-2 mb-3">
                                <i class="fas fa-envelope me-2"></i>
                                12. Contact Us
                            </h5>
                            <p>If you have any questions about these Terms & Conditions, please contact us:</p>
                            <div class="card bg-light">
                                <div class="card-body">
                                    <p class="mb-1"><i class="fas fa-envelope me-2"></i>Email: support@elite-center-ld.com
                                    </p>
                                    <p class="mb-0"><i class="fas fa-globe me-2"></i>Website:
                                        https://emsg.elite-center-ld.com</p>
                                </div>
                            </div>
                        </section>

                        <div class="text-center mt-5 pt-4 border-top">
                            <p class="text-muted">
                                <i class="fas fa-check-circle text-success me-2"></i>
                                By using the App, you acknowledge that you have read, understood, and agreed to these Terms
                                & Conditions.
                            </p>
                        </div>

                    </div>
                </div>
            </div>
        </div>
    </div>
@endsection