<?php

require_once 'connection.php';
@$aid = $_GET['aid'];

$sql = "DELETE FROM `address` WHERE id='$aid'";
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