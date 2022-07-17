<?php
session_start();
if (!$_SESSION["loggedIn_teacher"]) {
  	header("Location: /start.html");
}
else {
	$link = mysqli_connect('localhost', 'root', 'root', 'catalog_virtual');
	if (!$link) {
	    die('Could not connect: ' . mysql_error());
	} else {
	    	$query = "update grades set grade='{$_GET['grade']}' where student_id='{$_GET['id']}' and course_id='{$_GET['courseid']}'";
	        $result = mysqli_query($link, $query);
	        header("Location: /controller/teacher.php");
	}
}
?>
