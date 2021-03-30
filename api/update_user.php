<?php
require_once 'connection.php';
@$email = $_GET['email'];
@$name = $_GET['name'];
@$image = $_GET['image'];
@$mobile = $_GET['mobile'];
@$bio = $_GET['bio'];
$arr = null;
$sql = "UPDATE profile_user SET `name`='$name', `profile_img`='$image', `mobile`='$mobile', `bio`='$bio' WHERE `user_id`='$email'";

    $fetch = $db->query($sql);

    if($fetch){
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