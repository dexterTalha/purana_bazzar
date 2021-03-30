<?php
require_once 'connection.php';
@$sql = $_GET['sql'];

$arr = null;
$fetch = $db->query($sql);
while($row = mysqli_fetch_assoc($fetch)){

    $arr["products"][] = array(
        'id' =>  $row['id'],
        'title' =>  $row['small_des'],
        'image' =>  $row['thumb'],
        'price' =>  $row['price'],
        'type'  =>  $row['type']
    );

}


header('content-type: application/json');
echo json_encode($arr);
@mysqli_close();
?>