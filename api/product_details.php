<?php
require_once 'connection.php';

@$id = $_GET['id'];


//$sql = "SELECT product.id, product.small_des,product.thumb,product.image1,product.image2, product.price,users.email FROM product OUTER JOIN users AS U ON product.user_id=users.user_id  WHERE product.id='$id'";
$sql = "SELECT id, small_des, thumb, image1, image2, price, long_des, user_id, image3, type,address,category_id FROM product WHERE product.id='$id'";
$arr = null;
$fetch = $db->query($sql);
while($row = mysqli_fetch_array($fetch)){

    $sqlUser = "SELECT * FROM profile_user INNER JOIN users ON users.email = profile_user.user_id WHERE users.user_id='$row[7]'";
    $rowUser = mysqli_fetch_assoc($db->query($sqlUser));

    $arr["products"][] = array(
        'id'            =>      $row[0],
        'title'         =>      $row[1],
        'image0'        =>      $row[2],
        'image1'        =>      $row[3],
        'image2'        =>      $row[4],
        'image3'        =>      $row[8],
        'price'         =>      $row[5],
        'desc'          =>      $row[6],
        'type'          =>      $row[9],
        'address'          =>      $row[10],
        'category'          =>      $row[11],
        'name'          =>      $rowUser['name'],
        'user_image'    =>      $rowUser['profile_img'],
        'user_email'    =>      $rowUser['user_id']
    );

}


header('content-type: application/json');
echo json_encode($arr);
@mysqli_close();
?>