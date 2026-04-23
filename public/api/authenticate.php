<?php
declare(strict_types=1);

session_set_cookie_params([
    'lifetime' => 0,
    'path'     => '/',
    'secure'   => true,
    'httponly' => true,
    'samesite' => 'Strict',
]);
session_start();

$accessToken = getenv('ACCESS_TOKEN');
if ($accessToken === false || $accessToken === '') {
    http_response_code(500);
    exit;
}

$token = $_GET['token'] ?? '';

if ($token === '' || !hash_equals($accessToken, $token)) {
    header('Location: /?error=unauthorized');
    exit;
}

$_SESSION['logged_in'] = true;
header('Location: /');
exit;
