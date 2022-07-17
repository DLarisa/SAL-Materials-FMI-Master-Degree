<?php
  session_start();
?>
<html>
	<head>
		<title>Vulnerable Grades Management System</title>
		<link href="/view/layout.css" type="text/css" rel="stylesheet" />
	</head>
	<body>
		<h1>Vulnerable Grades Management System</h1>
		<h2>Your grades:</h2>
		<table>
			<tr><th>Course Name</th><th>Grade</th></tr>
			<?php
			  $name = $_SESSION["name"];
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
		<form action="/controller/upload.php" method="post" enctype="multipart/form-data">
        Upload your coursework here:
        <input type="file" name="fileToUpload" id="fileToUpload">
    	<input type="submit" value="Upload" name="submit">
		</form>
		<a href="/controller/logout.php">Logout</a>
	</body>
</html>
