<?php
	echo '<h1>Check ontology balance on this address</h1>';
			
	if (isset($_GET['address']) && @$_GET['address'] != "") {
		$node = "https://seed1.redpulse.com:10331";
		
		include("vendor/autoload.php");
		$rpcObject = new NeoPHP\NeoRPC(true);
		$rpcObject->setNode("https://seed1.redpulse.com:10331");
		echo "ONT Balance for {$_GET['address']}: ".\NeoPHP\NeoNEP5::getTokenBalance($rpcObject,NeoPHP\NeoAssets::ASSET_ONT,$_GET['address']);
		
		echo "<br/>We're using: {$node} as the connection node";
	} else {
		echo '<form>';
		echo '<h2>(NO PRIVATE KEYS!!!!1111)</h2>';
		echo '<input type="text" name="address" style="width: 300px;"><br/>';
		echo '<input type="submit" value="Check address">';
		echo '</form>';
	}
?>