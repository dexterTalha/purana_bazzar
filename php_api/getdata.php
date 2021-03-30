<?php
require_once 'connection.php';
$email = $_GET['email'];
//$password = $_GET['password'];
$sql = "SELECT users.user_id,users.email,profile_user.name,profile_user.bio FROM `users` JOIN `profile_user` ON users.email = profile_user.user_id WHERE users.email='$email'";

$fetch = $db->query($sql);

$arr = null;

while($row = mysqli_fetch_array($fetch)){
    $arr["user"][] = array(
        "id"        =>      $row[0],
        "email"     =>      $row[1],
        "name"      =>      $row[2],
        "bio"       =>      $row[3]
    );
}


header('content-type: application/json');
echo json_encode($arr);
@mysqli_close();
?>