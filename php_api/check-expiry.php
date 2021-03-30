<?php
require_once 'connection.php';

$userid = $_GET['userid'];
$response = null;
$sql = "SELECT * FROM ads WHERE `user_id`='$userid'";

$result = mysqli_query($db, $sql);
$row = mysqli_fetch_assoc($result);
$exp1 = $row['expiry'];
if($exp1 != 'NA'){
    $exp = strtotime($exp1);
    $current = date('Y-m-d h:m:s');
    if($exp <= strtotime($current)){
        //expired
        $update = "UPDATE ads SET gold='0', silver='0', normal='0', expiry='NA', update_time=NOW(), comment='Premium Expired' WHERE `user_id`='$userid'";
        $re = mysqli_query($db, $update);
        if($re){
            $response['server_response'][] = array(
                "response" => '1'
            );
        }
    }
}else{
    $response['server_response'][] = array(
        "response" => 'NA'
    );
}


header('content-type:application/json');
echo json_encode($response);
@mysqli_close($db);
?>