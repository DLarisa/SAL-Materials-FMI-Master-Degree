<?php
  session_start();
  if (!$_SESSION["loggedIn_teacher"]) {
  	header("Location: /start.html");
  }
?>
<html>
    <head>
    	<title>Update a students grade</title>
    	<link href="/view/layout.css" type="text/css" rel="stylesheet" />
	</head>
	<body>
		<h1>Vulnerable Grades Management System</h1>
		<h2>Input student's name to search grades:</h2>
		<form action="" method="get"> 
			<input type="text" name="name"> 
			<input type="submit"> 
		</form>
		<?php
		    $name = $_GET['name'];
		?>
        <h2><?= $name ?></h2>
		<table>
			<tr><th>Course Name</th><th>Grade</th></tr>
			<?php
			  $query = "SELECT c.name, g.grade
			          FROM students s
			          JOIN grades g ON g.student_id = s.id
			          JOIN courses c ON g.course_id = c.id
			          WHERE s.name = '$name'";
			  $db = new PDO("mysql:dbname=simpsons", "root", "root");
			  $db->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
			  $rows = $db->query($query);
			  foreach ($rows as $row) {
			    	?>
				    <tr>
					  <td>
					    	<?= $row["name"] ?>
					  </td>
					  <td>
					    	<?= $row["grade"] ?>
					  </td>
				    </tr>
   		    <?php		
			   }
			?>
		</table>
		<a href="/view/editor.html">Add Grade</a>
		<a href="/controller/logout.php">Logout</a>
	</body>
</html>