<?php
    // this tells the system that it's no longer just parsing html; it's now parsing PHP
    $success = True; //keep track of errors so it redirects the page only if there are no errors
    $db_conn = NULL; // edit the login credentials in connectToDB()
    $show_debug_alert_messages = False; // set to True if you want alerts to show you which methods are being triggered (see how it is used in debugAlertMessage())

    if (isset($_POST['delAnimal']) || isset($_POST['addAnimal']) || isset($_POST['reset']) || isset($_POST['updateAnimal']) || isset($_POST['insertSubmit'])) {
        handlePOSTRequest();
    } else if (isset($_GET['getAnimalsRequest'])) {
        handleGETRequest();
    }

    // HANDLE ALL GET ROUTES
	// A better coding practice is to have one method that reroutes your requests accordingly. It will make it easier to add/remove functionality.
    function handleGETRequest() {
        if (connectToDB()) {
            if (array_key_exists('countTuples', $_GET)) {
                echo 'TODO';
            } else if (array_key_exists('getAnimalsRequest', $_GET)) {
                handleGetAnimalsRequest();
            }

            disconnectFromDB();
        }
    }

    // HANDLE ALL POST ROUTES
	// A better coding practice is to have one method that reroutes your requests accordingly. It will make it easier to add/remove functionality.
    function handlePOSTRequest() {
        if (connectToDB()) {
            if (array_key_exists('resetTablesRequest', $_POST)) {
                echo 'TODO';
            } else if (array_key_exists('updateAnimal', $_POST)) {
                handleUpdateAnimalRequest(); 
            } else if (array_key_exists('insertQueryRequest', $_POST)) {
                echo 'TODO';
            } else if (array_key_exists('addAnimal', $_POST)) {
                handlePOSTAnimalRequest();
            } else if (array_key_exists('delAnimal', $_POST)) {
                handleDeleteAnimalPOSTRequest();
            }
            disconnectFromDB();
        }
    }

    function connectToDB() {
        global $db_conn;

        // Your username is ora_(CWL_ID) and the password is a(student number). For example,
		// ora_platypus is the username and a12345678 is the password.
        $db_conn = OCILogon("ora_andyli99", "a92239219", "dbhost.students.cs.ubc.ca:1522/stu");

        if ($db_conn) {
            debugAlertMessage("Database is Connected");
            return true;
        } else {
            debugAlertMessage("Cannot connect to Database");
            $e = OCI_Error(); // For OCILogon errors pass no handle
            echo htmlentities($e['message']);
            return false;
        }
    }

    function disconnectFromDB() {
        global $db_conn;

        debugAlertMessage("Disconnect from Database");
        OCILogoff($db_conn);
    }

    function executePlainSQL($cmdstr) { //takes a plain (no bound variables) SQL command and executes it
        //echo "<br>running ".$cmdstr."<br>";
        global $db_conn, $success;

        $statement = OCIParse($db_conn, $cmdstr);
        //There are a set of comments at the end of the file that describe some of the OCI specific functions and how they work

        if (!$statement) {
            echo "<br>Cannot parse the following command: " . $cmdstr . "<br>";
            $e = OCI_Error($db_conn); // For OCIParse errors pass the connection handle
            echo htmlentities($e['message']);
            $success = False;
        }

        $r = OCIExecute($statement, OCI_DEFAULT);
        if (!$r) {
            echo "<br>Cannot execute the following command: " . $cmdstr . "<br>";
            $e = oci_error($statement); // For OCIExecute errors pass the statementhandle
            echo htmlentities($e['message']);
            $success = False;
        }

		return $statement;
	}
    
    function executeBoundSQL($cmdstr, $list) {
    /* Sometimes the same statement will be executed several times with different values for the variables involved in the query.
    In this case you don't need to create the statement several times. Bound variables cause a statement to only be
    parsed once and you can reuse the statement. This is also very useful in protecting against SQL injection.
    See the sample code below for how this function is used */

        global $db_conn, $success;
        $statement = OCIParse($db_conn, $cmdstr);

        if (!$statement) {
            echo "<br>Cannot parse the following command: " . $cmdstr . "<br>";
            $e = OCI_Error($db_conn);
            echo htmlentities($e['message']);
            $success = False;
        }

        foreach ($list as $tuple) {
            foreach ($tuple as $bind => $val) {
                //echo $val;
                //echo "<br>".$bind."<br>";
                OCIBindByName($statement, $bind, $val);
                unset ($val); //make sure you do not remove this. Otherwise $val will remain in an array object wrapper which will not be recognized by Oracle as a proper datatype
            }

            $r = OCIExecute($statement, OCI_DEFAULT);
            if (!$r) {
                echo "<br>Cannot execute the following command: " . $cmdstr . "<br>";
                $e = OCI_Error($statement); // For OCIExecute errors, pass the statementhandle
                echo htmlentities($e['message']);
                echo "<br>";
                $success = False;
            }
        }
    }

    function debugAlertMessage($message) {
        global $show_debug_alert_messages;

        if ($show_debug_alert_messages) {
            echo "<script type='text/javascript'>alert('" . $message . "');</script>";
        }
    }

    function printResult($result) { //prints results from a select statement
        // echo "<br>Retrieved data from table Animals:<br>";
        // echo "<table>";
        // echo "<thead><tr><th>Name</th><th>Species</th><th>Habitat</th><th>Primary Carer</th></tr></thead><tbody>";

        while ($row = OCI_Fetch_Array($result, OCI_BOTH)) {
            echo $row["ANAME"];
        }

        // echo "</tbody></table>";
    }

    // 
    function handleGetAnimalsRequest() {
        global $db_conn;

        $result = ExecutePlainSQL("SELECT * FROM Animals");

        $response = array();
        while ($row = OCI_Fetch_Array($result, OCI_BOTH)) {
            $name = $row["ANAME"];
            $species = $row["SPECIES"];
            $habitatName = $row["HABITATNAME"];
            $primaryCarer = $row["PRIMARYCARERID"];
            array_push($response, [$name, $species, $habitatName, $primaryCarer]);
        }

        echo json_encode($response);
    }

    function handlePOSTAnimalRequest() {
        global $db_conn;

        //Getting the values from user and insert data into the table
        $tuple = array (
            ":bind1" => $_POST['aname'],
            ":bind2" => $_POST['aspecies'],
            ":bind3" => $_POST['ahabitat'],
            ":bind4" => $_POST['primaryCarer']
        );

        $alltuples = array (
            $tuple
        );

        executeBoundSQL("INSERT into Animals values (:bind1, :bind2, :bind3, :bind4)", $alltuples);
        OCICommit($db_conn);
    }

    function handleDeleteAnimalPOSTRequest() {
        global $db_conn;

        $aname = $_POST['aname'];
        $species = $_POST['species'];
        //Getting the values from user and insert data into the table
        $cmdstring = "DELETE FROM Animals WHERE aname='" . $aname . "' AND species='" . $species . "'";

        $result = executePlainSQL("DELETE FROM Animals WHERE aname='" . $aname . "' AND species='" . $species . "'");
        OCICommit($db_conn);
    }

    #Update an Animal entity through the modal that appears when you click pencil (on animal page)
    function handleUpdateAnimalRequest() {
        global $db_conn;

        $new_aname = $_POST['aname'];
        $new_species = $_POST['species'];
        $new_habitatName = $_POST['habitatName'];
	    $new_primaryCarerID = $_POST['primaryCarerID'];
        //Getting the values from user and insert data into the table
        #$cmdstring = "UPDATE Animals SET Animals.aname ='" . $aname . "' 
        #                                ,Animals.species ='" . $species . "'
        #                                ,Animals.habitatname ='" . $habitatName . "'  
        #                                ,Animals.primaryCarerID = '" . $primaryCarerID . "'
        #                                WHERE Animals.name ='" . $aname . "' AND Animals.species ='" . $species . "'"; 

        #$result = 
        executePlainSQL("UPDATE Animals SET Animals.aname ='" . $new_aname . "', 
                                            Animals.species ='" . $new_species . '", 
                                            Animals.habitatname ='" . $new_habitatName . '",
                                            Animals.primaryCarerID = '" . $new_primaryCarerID . '",
                                            WHERE Animals.name ='" . $aname . "' AND Animals.species ='" . $species . "'");
        OCICommit($db_conn);                             
    }

    #filter on the top right to select all lions, giraffes, etc. (on animal page)
    function handleSelectionRequest() {
        global $db_conn;

        $species = $_POST['species']; 

        $cmdstring = "SELECT from Animals WHERE species ='" . $species . "'";
        $result = executePlainSQL("SELECT from Animals WHERE species ='" . $species . "'");
        OCICommit($db_conn);
    }

    #find all items under a certain price range in the seperate store page
    function handleProjectionRequest() {
        global $db_conn; 

        $price = $_POST['price']; 

        $cmdstring = "SELECT from productName, price from AnimalProduct WHERE price <'" . $price . "'"); 
        $result = executePlainSQL("SELECT from productName, price from AnimalProduct WHERE price <'" . $price . "'");
        OCICommit($db_conn);
    }

    #show all sales history on click (seperate store page)
    function handleGetSalesRequest() {
        global $db_conn;

        $result = ExecutePlainSQL("SELECT a.visitorID, p.price
                                   FROM AnimalProductProcured a, AnimalProduct p
                                   WHERE a.animalName = p.animalName and a.animalSpecies = p.animalSpecies and a.productName = p.productName");
        
        $response = array();
            while ($row = OCI_Fetch_Array($result, OCI_BOTH)) {
            $visitor = $row["a.visitorID"];
            $price = $row["p.price"];
            $product = $row["a.productName"];
            array_push($response, [$visitor, $price, $product]);
        }

        echo json_encode($response);
    }
?> 