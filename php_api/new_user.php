<?php
require_once 'connection.php';
@$email = $_GET['email'];
@$password = $_GET['password'];
@$sid=$_GET['sid'];
@$mobile = $_GET['mobile'];
$arr = null;

$sql1 = "INSERT INTO users(`email`,`password`,`sid`) VALUES('$email','$password','$sid')";
$sql2 = "INSERT INTO profile_user(`user_id`,`mobile`,`name`,`profile_img`,`bio`) VALUES('$email','$mobile','','','')";

    $fetch1 = $db->query($sql1);
    $fetch2 = $db->query($sql2);
    if($fetch1 && $fetch2){
        $arr["response"][] = array(
            "response"      =>      "1"
        );
    }else{
        $arr["response"][] = array(
            "response"      =>      "0"
        );
    }


//echo mysqli_error($db);
header('content-type: application/json');
echo json_encode($arr);
@mysqli_close();
?>