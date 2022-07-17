<?php 
$link = mysqli_connect('localhost', 'root', 'root', 'simpsons');
if (!$link){
    echo"<script>alert('Connection failed！')</script>";
} else {
    session_start();
    // prevent sql injection
    $name = mysqli_real_escape_string($link, $_POST['name']);
    $password = mysqli_real_escape_string($link, $_POST['password']);
    // $name = $_POST["name"];
    // $password = $_POST["password"];
    if (isset($_POST['submit'])){
        $query = "select * from teachers where name = '$name' and password = '$password'";
        $result = mysqli_query($link, $query);
        if (mysqli_num_rows($result) >= 1){
            $_SESSION["loggedIn_teacher"] = TRUE;
            header('Location: /controller/teacher.php');
        } else {
            $_SESSION["loggedIn_teacher"] = FALSE;
        	header('Location: /view/login_teacher.html');
        }
    }
}
?>
