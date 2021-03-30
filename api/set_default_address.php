<?php

require_once 'connection.php';

@$user_id = $_GET['userid'];
@$aid = $_GET['aid'];

$sql = "UPDATE profile_user SET `address`='$aid' WHERE user_id='$user_id'";
$data = $db->query($sql);
if($data){
    $arr["response"][] = array('response' => "1");
}else{
    $arr["response"][] = array('response' => "0");
}

header('content-type: application/json');
echo json_encode($arr);
echo mysqli_error($db);
@mysqli_close();
?>