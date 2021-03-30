<?php
require_once 'connection.php';
$userid= $_GET['userid'];
$query = "SELECT * FROM `address` WHERE user_id='$userid' ORDER BY id DESC";

$result = $db->query($query);

$response = null;
while($row = mysqli_fetch_array($result))
{
    $response["server_response"][] = array(
        "id"    => $row['id'],
        "street" => $row['street'],
        "city" => $row['city'],
        "state" => $row['state'],
        "name" => $row['name'],
        "mobile" => $row['mobile'],
        "altermobile" => $row['altermobile'],
    );
}
echo mysqli_error($db);
header('content-type:application/json');
echo json_encode($response);
@mysqli_close($db);
?>