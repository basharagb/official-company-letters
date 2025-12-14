@extends('layouts.template')

@section('title', 'Privacy Policy')

@section('content')
    <div class="container-fluid py-4">
        <div class="row justify-content-center">
            <div class="col-lg-10">
                <div class="card shadow-sm">
                    <div class="card-header bg-primary text-white">
                        <h4 class="mb-0">
                            <i class="fas fa-shield-alt me-2"></i>
                            Privacy Policy
                        </h4>
                    </div>
                    <div class="card-body p-4">
                        <div class="text-muted mb-4">
                            <small>Last updated: {{ date('Y-m-d') }}</small>
                        </div>

                        <section class="mb-5">
                            <h5 class="text-primary border-bottom pb-2 mb-3">
                                <i class="fas fa-info-circle me-2"></i>
                                Introduction
                            </h5>
                            <p class="text-justify">
                                Welcome to the "Official Letters" application. We value your trust and are committed to
                                protecting your privacy and personal data. This Privacy Policy explains how we collect,
                                use, and protect information when you use our services.
                            </p>
                        </section>

                        <section class="mb-5">
                            <h5 class="text-primary border-bottom pb-2 mb-3">
                                <i class="fas fa-database me-2"></i>
                                Information We Collect
                            </h5>
                            <p>We may collect the following types of information:</p>
                            <ul class="list-group list-group-flush mb-3">
                                <li class="list-group-item">
                                    <strong>Account Information:</strong> name, email address, phone number, and company
                                    name during registration.
                                </li>
                                <li class="list-group-item">
                                    <strong>Company Data:</strong> company logo, signature, stamp, and address used in
                                    official letters.
                                </li>
                                <li class="list-group-item">
                                    <strong>Letter Content:</strong> text and documents you create within the app.
                                </li>
                                <li class="list-group-item">
                                    <strong>Photos & Files:</strong> images/files you upload for logos, templates, and
                                    signatures.
                                </li>
                                <li class="list-group-item">
                                    <strong>Usage Data:</strong> information about how you use the app to help us improve
                                    our services.
                                </li>
                            </ul>
                        </section>

                        <section class="mb-5">
                            <h5 class="text-primary border-bottom pb-2 mb-3">
                                <i class="fas fa-mobile-alt me-2"></i>
                                Permissions We Request
                            </h5>
                            <p>The app requests the following permissions to provide its features:</p>
                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <div class="card h-100 border-info">
                                        <div class="card-body">
                                            <h6 class="card-title text-info">
                                                <i class="fas fa-camera me-2"></i>Camera
                                            </h6>
                                            <p class="card-text small">
                                                Used to scan documents and letterheads, and to create templates.
                                                We access the camera only when you explicitly choose to use it.
                                            </p>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <div class="card h-100 border-success">
                                        <div class="card-body">
                                            <h6 class="card-title text-success">
                                                <i class="fas fa-images me-2"></i>Photo Library
                                            </h6>
                                            <p class="card-text small">
                                                Used to select logos, stamps, and signatures from your gallery.
                                                We only access items you select.
                                            </p>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <div class="card h-100 border-warning">
                                        <div class="card-body">
                                            <h6 class="card-title text-warning">
                                                <i class="fas fa-bell me-2"></i>Notifications
                                            </h6>
                                            <p class="card-text small">
                                                Used to notify you about important updates and letter status.
                                                You can disable notifications at any time in your device settings.
                                            </p>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <div class="card h-100 border-secondary">
                                        <div class="card-body">
                                            <h6 class="card-title text-secondary">
                                                <i class="fas fa-folder me-2"></i>Files
                                            </h6>
                                            <p class="card-text small">
                                                Used to export and save letters as PDF files.
                                                We only access files you select or create through the app.
                                            </p>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </section>

                        <section class="mb-5">
                            <h5 class="text-primary border-bottom pb-2 mb-3">
                                <i class="fas fa-cogs me-2"></i>
                                How We Use Your Information
                            </h5>
                            <ul class="list-unstyled">
                                <li class="mb-2"><i class="fas fa-check text-success me-2"></i>Create and manage your
                                    account</li>
                                <li class="mb-2"><i class="fas fa-check text-success me-2"></i>Provide letter creation
                                    services</li>
                                <li class="mb-2"><i class="fas fa-check text-success me-2"></i>Store templates and company
                                    settings</li>
                                <li class="mb-2"><i class="fas fa-check text-success me-2"></i>Send important notifications
                                </li>
                                <li class="mb-2"><i class="fas fa-check text-success me-2"></i>Improve and develop our
                                    services</li>
                                <li class="mb-2"><i class="fas fa-check text-success me-2"></i>Comply with legal
                                    requirements</li>
                            </ul>
                        </section>

                        <section class="mb-5">
                            <h5 class="text-primary border-bottom pb-2 mb-3">
                                <i class="fas fa-lock me-2"></i>
                                Data Security
                            </h5>
                            <p>We take reasonable security measures to protect your data, including:</p>
                            <ul class="list-unstyled">
                                <li class="mb-2"><i class="fas fa-shield-alt text-primary me-2"></i>Encryption in transit
                                    and at rest</li>
                                <li class="mb-2"><i class="fas fa-shield-alt text-primary me-2"></i>Secure infrastructure
                                </li>
                                <li class="mb-2"><i class="fas fa-shield-alt text-primary me-2"></i>Restricted access for
                                    authorized staff only</li>
                                <li class="mb-2"><i class="fas fa-shield-alt text-primary me-2"></i>Periodic security
                                    reviews</li>
                            </ul>
                        </section>

                        <section class="mb-5">
                            <h5 class="text-primary border-bottom pb-2 mb-3">
                                <i class="fas fa-share-alt me-2"></i>
                                Data Sharing
                            </h5>
                            <p>
                                <strong>We do not sell or rent your personal data to third parties.</strong>
                            </p>
                            <p>We may share your data only in the following cases:</p>
                            <ul>
                                <li>With your explicit consent</li>
                                <li>To comply with legal obligations</li>
                                <li>To protect our rights or user safety</li>
                            </ul>
                        </section>

                        <section class="mb-5">
                            <h5 class="text-primary border-bottom pb-2 mb-3">
                                <i class="fas fa-user-shield me-2"></i>
                                Your Rights
                            </h5>
                            <p>You may have the following rights regarding your data:</p>
                            <ul>
                                <li>Access your personal data</li>
                                <li>Correct inaccurate data</li>
                                <li>Delete your account and data</li>
                                <li>Export your data</li>
                                <li>Object to certain processing</li>
                            </ul>
                        </section>

                        <section class="mb-5">
                            <h5 class="text-primary border-bottom pb-2 mb-3">
                                <i class="fas fa-clock me-2"></i>
                                Data Retention
                            </h5>
                            <p>
                                We retain your data as long as your account is active or as needed to provide our
                                services. You can request account deletion at any time, and we will delete your data
                                within 30 days.
                            </p>
                        </section>

                        <section class="mb-5">
                            <h5 class="text-primary border-bottom pb-2 mb-3">
                                <i class="fas fa-child me-2"></i>
                                Children's Privacy
                            </h5>
                            <p>
                                Our services are not directed to children under the age of 13. We do not knowingly
                                collect personal information from children.
                            </p>
                        </section>

                        <section class="mb-5">
                            <h5 class="text-primary border-bottom pb-2 mb-3">
                                <i class="fas fa-sync-alt me-2"></i>
                                Policy Updates
                            </h5>
                            <p>
                                We may update this Privacy Policy from time to time. We will notify you of material
                                changes via email or an in-app notice.
                            </p>
                        </section>

                        <section class="mb-4">
                            <h5 class="text-primary border-bottom pb-2 mb-3">
                                <i class="fas fa-envelope me-2"></i>
                                Contact Us
                            </h5>
                            <p>If you have any questions about this Privacy Policy, please contact us:</p>
                            <div class="card bg-light">
                                <div class="card-body">
                                    <p class="mb-1"><i class="fas fa-envelope me-2"></i>Email: support@elite-center-ld.com
                                    </p>
                                    <p class="mb-0"><i class="fas fa-globe me-2"></i>Website:
                                        https://emsg.elite-center-ld.com</p>
                                </div>
                            </div>
                        </section>

                    </div>
                </div>
            </div>
        </div>
    </div>
@endsection