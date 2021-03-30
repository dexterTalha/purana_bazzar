<?php
require_once 'connection.php';
//$location=$_GET['location'];
//$sql = "SELECT * FROM product WHERE address LIKE '%$location%' ORDER BY id DESC";
$sql = "SELECT * FROM product ORDER BY id DESC";
$arr = null;
$fetch = $db->query($sql);
while($row = mysqli_fetch_assoc($fetch)){

    $arr["products"][] = array(
        'id'    =>  $row['id'],
        'title' =>  $row['small_des'],
        'image' =>  $row['thumb'],
        'price' =>  $row['price'],
        'type'  =>  $row['type'],
        'desp'  =>  $row['long_des'],
        'user_id'=> $row['user_id']
    );

}


header('content-type: application/json');
echo json_encode($arr);
@mysqli_close();
?>