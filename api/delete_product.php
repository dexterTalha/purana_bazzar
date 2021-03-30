<?php

require_once 'connection.php';
@$aid = $_GET['id'];

$sql = "DELETE FROM `product` WHERE id='$aid'";
$sql2 = "DELETE FROM `prime` WHERE product_id='$id'";
$data = $db->query($sql);
$data2 = $db->query($sql2);
if($data && $data2){
    $arr["response"][] = array('response' => "1");
}else{
    $arr["response"][] = array('response' => "0");
}

header('content-type: application/json');
echo json_encode($arr);
echo mysqli_error($db);
@mysqli_close();
?>