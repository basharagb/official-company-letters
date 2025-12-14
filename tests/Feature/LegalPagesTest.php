<?php

namespace Tests\Feature;

use Tests\TestCase;

class LegalPagesTest extends TestCase
{
    public function test_privacy_policy_page_loads_in_english(): void
    {
        $response = $this->get('/privacy-policy');

        $response->assertStatus(200);
        $response->assertSee('Privacy Policy');
    }

    public function test_terms_conditions_page_loads_in_english(): void
    {
        $response = $this->get('/terms-conditions');

        $response->assertStatus(200);
        $response->assertSee('Terms & Conditions');
    }
}
