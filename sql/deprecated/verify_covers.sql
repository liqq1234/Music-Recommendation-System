SELECT id, title, LEFT(cover_url, 60) as cover_url FROM music WHERE cover_url IS NOT NULL AND cover_url != '' LIMIT 5;
SELECT COUNT(*) as has_cover FROM music WHERE cover_url IS NOT NULL AND cover_url != '';
SELECT COUNT(*) as no_cover FROM music WHERE cover_url IS NULL OR cover_url = '';
