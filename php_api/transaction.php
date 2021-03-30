<?php
require_once 'connection.php';

$userid = $_POST['userid'];
$offerid = $_POST['offerid'];
$transactionid = $_POST['transactionid'];
$transactionstatus = $_POST['transactionstatus'];
$amount = $_POST['amount'];
$mode = $_POST['mode'];
$signature = $_POST['signature'];
$response = null;
$sql = "INSERT INTO `transaction`(`transactionid`,`status`,`amount`,`userid`,`offerid`, `mode`, `signature`) VALUES('$transactionid','$transactionstatus', '$amount','$userid', '$offerid', '$mode', '$signature')";

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



header('content-type:application/json');
echo json_encode($response);
@mysqli_close($db);
?>