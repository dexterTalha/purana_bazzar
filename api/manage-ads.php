<?php
require_once 'connection.php';

$userid = $_POST['userid'];
$gold = $_POST['gold'];
$silver = $_POST['silver'];
$normal = $_POST['normal'];
$initials = $_POST['initials'];
$response = null;

$sqlCheck = "SELECT * FROM ads WHERE `user_id` = '$userid'";
$checkResult = mysqli_query($db, $sqlCheck);

if (mysqli_num_rows($checkResult) > 0) {
    //exists
    $sqlUpdate = "UPDATE ads SET gold='$gold', silver='$silver', normal='$normal', initials='$initials' WHERE `user_id`='$userid'";
    $result = mysqli_query($db, $sqlUpdate);
    if ($result) {
        $response["server_response"][] = array(
            'response' => "1"
        );
    } else {
        $response["server_response"][] = array(
            'response' => "0"
        );
    }
} else {
    //not exists
    $sqlInsert = "INSERT INTO ads(`user_id`, gold, silver, normal, initials) VALUES('$userid', '$gold', '$silver', '$normal', '$initials')";
    $result = mysqli_query($db, $sqlInsert);
    if ($result) {
        $response["server_response"][] = array(
            'response' => "1"
        );
    } else {
        $response["server_response"][] = array(
            'response' => "0"
        );
    }
}






header('content-type:application/json');
echo json_encode($response);
@mysqli_close($db);
