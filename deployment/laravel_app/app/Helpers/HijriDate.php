<?php

namespace App\Helpers;

class HijriDate
{
    /**
     * تحويل التاريخ الميلادي إلى هجري
     */
    public static function toHijri($gregorianDate): string
    {
        $date = is_string($gregorianDate) ? strtotime($gregorianDate) : $gregorianDate->timestamp;
        
        $day = date('j', $date);
        $month = date('n', $date);
        $year = date('Y', $date);

        // خوارزمية التحويل
        $jd = self::gregorianToJD($year, $month, $day);
        list($hYear, $hMonth, $hDay) = self::jdToHijri($jd);

        $hijriMonths = [
            1 => 'محرم',
            2 => 'صفر',
            3 => 'ربيع الأول',
            4 => 'ربيع الثاني',
            5 => 'جمادى الأولى',
            6 => 'جمادى الآخرة',
            7 => 'رجب',
            8 => 'شعبان',
            9 => 'رمضان',
            10 => 'شوال',
            11 => 'ذو القعدة',
            12 => 'ذو الحجة',
        ];

        return "{$hDay} {$hijriMonths[$hMonth]} {$hYear}هـ";
    }

    /**
     * تحويل التاريخ الميلادي إلى Julian Day
     */
    private static function gregorianToJD($year, $month, $day): int
    {
        if ($month <= 2) {
            $year -= 1;
            $month += 12;
        }

        $a = floor($year / 100);
        $b = 2 - $a + floor($a / 4);

        return floor(365.25 * ($year + 4716)) + floor(30.6001 * ($month + 1)) + $day + $b - 1524;
    }

    /**
     * تحويل Julian Day إلى التاريخ الهجري
     */
    private static function jdToHijri($jd): array
    {
        $jd = $jd - 1948440 + 10632;
        $n = floor(($jd - 1) / 10631);
        $jd = $jd - 10631 * $n + 354;
        $j = floor((10985 - $jd) / 5316) * floor(50 * $jd / 17719) + floor($jd / 5670) * floor(43 * $jd / 15238);
        $jd = $jd - floor((30 - $j) / 15) * floor(17719 * $j / 50) - floor($j / 16) * floor(15238 * $j / 43) + 29;
        $month = floor(24 * $jd / 709);
        $day = $jd - floor(709 * $month / 24);
        $year = 30 * $n + $j - 30;

        return [$year, $month, $day];
    }

    /**
     * الحصول على التاريخ الهجري الحالي
     */
    public static function now(): string
    {
        return self::toHijri(now());
    }
}
