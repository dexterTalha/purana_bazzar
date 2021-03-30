<?php
require_once 'connection.php';
$query = "SELECT prime_control.id, prime_control.offer, prime_control.price, discount.three_months, discount.six_months, discount.twelve_months,
 FROM `prime_control` INNER JOIN discount ON prime_control.id = discount.offer_id";

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