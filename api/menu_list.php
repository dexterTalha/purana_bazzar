<?php
require_once 'connection.php';

$sql = "SELECT * FROM category";
$fetch = $db->query($sql);

$arr = null;

while($row = mysqli_fetch_assoc($fetch)){
    $arr["menu"][] = array(
        "id"       =>   $row['id'],
        "title"    =>   $row['name'],
        "image"    =>   $row['image'],
        "parent"   =>   $row['parent'],
        "type"     =>   $row['type']
    );
}

header('content-type: application/json');
echo json_encode($arr);
@mysqli_close();
?>