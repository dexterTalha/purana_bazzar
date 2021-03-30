<?php
require_once 'connection.php';

$pid = $_POST['pid'];
$type = $_POST['type'];
$payment = $_POST['payment'];

$response = null;

$sqlCheck = "SELECT * FROM prime WHERE product_id='$pid'";
$r = mysqli_query($db, $sqlCheck);

if(mysqli_num_rows($r) > 0){
    $response["server_response"][] = array(
        'response' => "Already prime Ad!"
    );
}else{
    $sql = "INSERT INTO `prime`(`product_id`,`type`,`payment`) VALUES('$pid','$type', '$payment')";

    $result = mysqli_query($db, $sql);
    if($result){
        $response["server_response"][] = array(
            'response' => "1"
        );
    }else{
        $response["server_response"][] = array(
            'response' => "0"
        );
    }
}



header('content-type:application/json');
echo json_encode($response);
@mysqli_close($db);
?>