<?php
require_once 'connection.php';
$userid= $_GET['userid'];
$query = "SELECT `address`.name as n, `address`.mobile as m,street, city, state,altermobile FROM `address` INNER JOIN users INNER JOIN profile_user ON users.user_id=`address`.`user_id` WHERE users.user_id='$userid' AND profile_user.address=address.id AND users.email=profile_user.user_id";

$result = mysqli_query($db,$query);

$response = null;
 
while($row = mysqli_fetch_array($result))
{
    $response["server_response"][] = array(
        "street" => $row['street'],
        "city" => $row['city'],
        "state" => $row['state'],
        "name" => $row['n'],
        "mobile" => $row['m'],
        "altermobile" => $row['altermobile'],
    );
}

header('content-type:application/json');
echo json_encode($response);
echo mysqli_error($db);
@mysqli_close($db);
?>