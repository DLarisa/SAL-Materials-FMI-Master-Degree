<?php
session_start();
if (!$_SESSION["loggedIn_teacher"]) {
	header("Location: /start.html");
} else {
	$link = mysqli_connect('localhost', 'root', 'root', 'catalog_virtual');
	if (!$link) {
	    die('Could not connect: ' . mysql_error());
	} else {
	    if (isset($_POST['submit'])){
	    	$query = "insert into grades (student_id, course_id, grade) values('{$_POST['id']}', '{$_POST['courseid']}', '{$_POST['grade']}')";
	        $result = mysqli_query($link, $query);
	        header("Location: /controller/teacher.php");
	    } else {
	    	die('Error');
	    }
	}
}
?>
