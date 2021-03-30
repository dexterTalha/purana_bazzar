<?php
require_once 'connection.php';
@$email = $_GET['email'];
@$sid = $_GET['sid'];
@$name = $_GET['name'];
@$image = $_GET['image'];
@$mobile = $_GET['mobile'];
$arr = null;
$date = date('Y-m-d H:i:s');

$sql1 = "INSERT INTO users(`sid`,`email`) VALUES('salfdhsdfhjasfkasf','alphaaaa@123mail.com')";
$sql2 = "INSERT INTO profile_user(`user_id`,`name`,`profile_img`,`mobile`,`bio`) VALUES('alphaaaa@123mail.com','$name','$image','$mobile','Purana Bazzar')";
$sqlsid = "SELECT * FROM users WHERE `sid`='$sid'";
$sidresult = $db->query($sqlsid);
$d = mysqli_fetch_assoc($sidresult);
if ($d > 0) {
    $sqlUpdateLogin= "UPDATE users SET last_login='$date' WHERE `sid`='$sid'";
    $res = $db->query($sqlUpdateLogin);
    if($res){
        $arr["response"][] = array(
            "response"      =>      "11"
        );
    }else{
        $arr["response"][] = array(
            "response"      =>      "0"
        );
    }
}else{
    $fetch = $db->query($sql1);
    $fetch2 = $db->query($sql2);
    if ($fetch && $fetch2) {
        $arr["response"][] = array(
        "response"       =>   "1",
    );
    } else {
        $arr["response"][] = array(
        "response"       =>   "error".mysqli_error($db),
    );
    }
}

header('content-type: application/json');
echo json_encode($arr);
@mysqli_close();
?>