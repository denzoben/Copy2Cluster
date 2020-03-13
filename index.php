<?php
	$info = pathinfo($_FILES['sourcefile']['name']);
	$filename= $_FILES['sourcefile']['name'];
	$path = $_FILES['dir_to_search']['name'];
	$ext = $info['extension']; // get the extension of the file

	$newname = "newname.".$ext; 
	$target = 'images/'.$newname;
	move_uploaded_file( $_FILES['sourcefile']['tmp_name'], $target);
	$store=`./copytocluster.sh -s iplist -d /var/www/html/Copy2Cluster/test/ -p 22 -h iplist`;
	echo "$store";
?>
