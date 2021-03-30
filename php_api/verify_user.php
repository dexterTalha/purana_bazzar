<?php
require_once 'connection.php';
@$email = $_GET['email'];
@$mobile = $_GET['mobile'];
$arr = null;



$sql = "UPDATE profile_user SET mobile='$mobile' WHERE user_id='$email'";

$execute = $db->query($sql);

if($execute){
    $arr["response"][] = array(
        "response"      =>      "1",
    );
}else{
    $arr["response"][] = array(
        "response"      =>      "0",
    );
}


header('content-type: application/json');
echo json_encode($arr);
@mysqli_close();
?>