<?php
require_once 'connection.php';

$userid = '8';
$response = null;
$sqlCheck = "SELECT * FROM ads WHERE `user_id` = '$userid'";
$checkResult = $db->query($sqlCheck);

if (mysqli_num_rows($checkResult) > 0) {
    //exists
    $sqlUpdate = "SELECT * FROM ads WHERE `user_id`='$userid'";
    $result = mysqli_query($db, $sqlUpdate);
    while ($row = mysqli_fetch_assoc($result)) {
        $response['server_response'][] = array(
            'gold' => $row['gold'],
            'silver' => $row['silver'],
            'normal' => $row['normal'],
            'initials' => $row['initial'],
        );
    }
} else {
    //not exists
    $sqlInsert = "SELECT * FROM product WHERE `user_id` = '$userid'";
    //echo "hi";
    $result = mysqli_query($db, $sqlInsert);
    $ini = 20-mysqli_num_rows($result);
    $response['server_response'][] = array(
        'gold' => "0",
        'silver' => "0",
        'normal' => "0",
        'initials' => $ini,
    );
}


//echo mysqli_error($db);
header('content-type:application/json');
echo json_encode($response);
@mysqli_close($db);
?>