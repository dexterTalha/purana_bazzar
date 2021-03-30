<?php
require_once 'connection.php';
$aid= $_GET['aid'];
$query = "SELECT * FROM `address` WHERE id='$aid'";

$result = $db->query($query);

$response = null;
while($row = mysqli_fetch_array($result))
{
    $response["server_response"][] = array(
        "id"    => $row['id'],
        "land"    => $row['land'],
        "pin"    => $row['pin'],
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