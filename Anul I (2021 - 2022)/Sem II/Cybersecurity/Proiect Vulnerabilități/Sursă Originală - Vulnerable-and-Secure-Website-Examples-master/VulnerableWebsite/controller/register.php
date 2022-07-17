<?php
$link = mysqli_connect('localhost', 'root', 'root', 'simpsons');
if (!$link) {
    die('Could not connect: ' . mysql_error());
}else {
    if (isset($_POST['submit'])){
        if ($_POST['pw'] == $_POST['repw']){
        	$query = "insert into students (name, email, password) values('{$_POST['name']}', '{$_POST['email']}', '{$_POST['pw']}')";
        	$result = mysqli_query($link, $query);
        	header("Location: /view/login.html");
        } else {
            echo "<script>alert('Unconsistent passwords input！')</script>";
        }
    }
}
?>

