<html>
<?php
	if ($c=OCILogon("ora_andyli99", "a92239219", "dbhost.students.cs.ubc.ca:1522/stu")) {
		echo "Successfully connected to Oracle.\n";
		OCILogoff($c);
	} else {
		$err = OCIError();
		echo "Oracle Connect Error " . $err['message'];
	}
?>
</html>
