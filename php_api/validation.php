<?php
require_once 'connection.php';
@$email = $_GET['email'];
@$mobile = $_GET['mobile'];
$arr = null;

$sqlcheckEmail = "SELECT email FROM users WHERE email = '$email'";
$sqlcheckMobile = "SELECT mobile FROM profile_user WHERE mobile = '$mobile'";
$checkemail = $db->query($sqlcheckEmail);
$checkmobile = $db->query($sqlcheckMobile);

$d = mysqli_fetch_assoc($checkemail);
$d1 = mysqli_fetch_assoc($checkmobile);
if($d > 0){
    $arr["response"][] = array(
        "response"      =>      "0"
    );
}else if($d1 > 0){
    $arr["response"][] = array(
        "response"      =>      "00"
    );
}else{
    $arr["response"][] = array(
        "response"      =>      "1"
    );
}


header('content-type: application/json');
echo json_encode($arr);
@mysqli_close();
?>