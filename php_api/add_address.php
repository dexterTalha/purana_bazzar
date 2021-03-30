<?php

require_once 'connection.php';

@$user_id = $_POST['user_id'];
@$street = $_POST['street'];
@$city = $_POST['city'];
@$state = $_POST['state'];
@$land = $_POST['land'];
@$pin = $_POST['pin'];
@$name = $_POST['name'];
@$mobile = $_POST['mobile'];
@$altermobile = $_POST['altermobile'];
$arr = null;


$sql = "INSERT INTO address(`user_id`,`street`,`city`,`state`,`pin`,`land`,`name`,`mobile`,`altermobile`) 
        VALUES('$user_id','$street','$city','$state','$pin','$land','$name','$mobile','$altermobile')";
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