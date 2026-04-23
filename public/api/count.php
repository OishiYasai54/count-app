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

if (empty($_SESSION['logged_in'])) {
    http_response_code(401);
    header('Content-Type: application/json');
    echo json_encode(['error' => 'Unauthorized']);
    exit;
}

header('Content-Type: application/json');

$dataFile = (getenv('DATA_DIR') ?: __DIR__) . '/data.json';

if ($_SERVER['REQUEST_METHOD'] === 'GET') {
    if (file_exists($dataFile)) {
        echo file_get_contents($dataFile);
    } else {
        echo json_encode(['value' => 0]);
    }
    exit;
}

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $input = json_decode(file_get_contents('php://input'), true);
    $delta = $input['delta'] ?? 0;
    $reset = $input['reset'] ?? false;

    $fp = fopen($dataFile, 'c+');
    if (flock($fp, LOCK_EX)) {
        $json = stream_get_contents($fp);
        $data = json_decode($json, true) ?? ['value' => 0];

        if ($reset) {
            $data['value'] = 0;
        } else {
            $data['value'] += $delta;
        }

        ftruncate($fp, 0);
        rewind($fp);
        fwrite($fp, json_encode($data));
        fflush($fp);
        flock($fp, LOCK_UN);
    }
    fclose($fp);

    echo json_encode(['value' => $data['value']]);
    exit;
}
