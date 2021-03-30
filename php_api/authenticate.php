<?php
require_once 'connection.php';
$email = $_GET['email'];
$password = $_GET['password'];
$sql = "SELECT * FROM users WHERE `email`='$email' AND `password`='$password'";
$fetch = $db->query($sql);

$arr = null;

$data = mysqli_fetch_assoc($fetch);
if($data > 0){
    $arr["response"][] = array(
        "response"      =>      "1"
    );
}else{
    $arr["response"][] = array(
        "response"      =>      "0"
    );
}

header('content-type: application/json');
echo json_encode($arr);
@mysqli_close();
?>