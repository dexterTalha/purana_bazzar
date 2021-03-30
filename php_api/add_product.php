<?php
require_once 'connection.php';

@$name = $_POST['name'];
@$user = $_POST['user'];
@$price = $_POST['price'];
@$category = $_POST['category'];
@$address = $_POST['address'];
@$description = $_POST['description'];
@$type = $_POST['type'];

@$imageCount = $_POST['imgcount'];
$path0 = "";
$path1 = "";
$path2 = "";
$path3 = "";

$appPath = "http://192.168.43.166/pb/dashboard/";
switch($imageCount){
    case 1:
    $image0 = $_POST['image0'];
    $path0 = "product_images/".md5(microtime())."0.jpg";
    break;
    case 2:
    $image0 = $_POST['image0'];
    $path0 = "product_images/".md5(microtime())."0.jpg";
    $image1 = $_POST['image1'];
    $path1 = "product_images/".md5(microtime())."1.jpg";
    break;
    case 3:
    $image0 = $_POST['image0'];
    $path0 = "product_images/".md5(microtime())."0.jpg";
    $image1 = $_POST['image1'];
    $path1 = "product_images/".md5(microtime())."1.jpg";
    $image2 = $_POST['image2'];
    $path2 = "product_images/".md5(microtime())."2.jpg";
    break;
    case 4:
    $image0 = $_POST['image0'];
    $path0 = "product_images/".md5(microtime())."0.jpg";
    $image1 = $_POST['image1'];
    $path1 = "product_images/".md5(microtime())."1.jpg";
    $image2 = $_POST['image2'];
    $path2 = "product_images/".md5(microtime())."2.jpg";
    $image3 = $_POST['image3'];
    $path3 = "product_images/".md5(microtime())."3.jpg";
    break;
}



$sql = "INSERT INTO `product`(`user_id`, `category_id`, `small_des`, `long_des`, `price`, `thumb`, `image1`, `image2`, `image3`, `type`, `address`) VALUES('$user','$category','$name','$description','$price','$path0','$path1','$path2','$path3','$type','$address')";

$arr = null;
$fetch = $db->query($sql);
 if($fetch){
    switch($imageCount){
    case 1:
    file_put_contents($appPath.$path0,base64_decode($image0));
    break;
    case 2:
    file_put_contents($appPath.$path0,base64_decode($image0));
    file_put_contents($appPath.$path1,base64_decode($image1));
    break;
    case 3:
    file_put_contents($appPath.$path0,base64_decode($image0));
    file_put_contents($appPath.$path1,base64_decode($image1));
    file_put_contents($appPath.$path2,base64_decode($image2));
    break;
    case 4:
    file_put_contents($appPath.$path0,base64_decode($image0));
    file_put_contents($appPath.$path1,base64_decode($image1));
    file_put_contents($appPath.$path2,base64_decode($image2));
    file_put_contents($appPath.$path3,base64_decode($image3));
    break;
}
    $arr["response"][] = array(
        'resppnse' =>  "1");
}else{
    $arr["response"][] = array(
        'resppnse' =>  "0");
}

header('content-type: application/json');
echo json_encode($arr);
@mysqli_close();
?>