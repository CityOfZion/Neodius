<h1>#Market @ Neo Discord - Ontology Airdrop calculation</h1>
<?php
	$bestNode = "http://seed5.cityofzion.io:8080/";
	
	$dropBlock = "1974823";
	
	$compareBlock = 21;

	$currentBlockFetch = json_decode(file_get_contents("{$bestNode}myservice?jsonrpc=2.0&method=getblockcount&params=%5B%5D&id=5"),true);
	$currentBlock = $currentBlockFetch['result'];	
		
	$foreLastBlockFetch = json_decode(file_get_contents("{$bestNode}myservice?jsonrpc=2.0&method=getblock&params=[".($currentBlock-1).",1]&id=4"),true);
	$foreLastBlock = $currentBlock-1;
	$foreLastBlockTime = $foreLastBlockFetch['result']['time'];


	$compareBlockFetch = json_decode(file_get_contents("{$bestNode}myservice?jsonrpc=2.0&method=getblock&params=[".($foreLastBlock - ($compareBlock+1)).",1]&id=4"),true);
	$compareBlockTime = $compareBlockFetch['result']['time'];
	
	//echo "Avarage time: ".($foreLastBlockTime - $compareBlockTime) / $compareBlock;
	echo sprintf("Airdrop will commence when block <b>%s</b> is generated<br/><br/>",$dropBlock);
	echo sprintf("Current block is: %s<br/>",$currentBlock);
	echo sprintf("Last block (%s) was generated at: %s<br/>",$foreLastBlock, date("d-m-Y H:i:s",$foreLastBlockTime));
	echo sprintf("We compare that to %s blocks ago which is block %s which is generated at %s",$compareBlock+1, $foreLastBlock - ($compareBlock+1), date("d-m-Y H:i:s",$compareBlockTime));
	
	echo "<br/><br/>";
	echo sprintf("If we substract both times and divide by: ".($compareBlock+1)." we get the avarage block generation time of <b>%s seconds</b>",($gentime = round(($foreLastBlockTime - $compareBlockTime) / ($compareBlock+1),2)));
	
	echo "<br/><br/>";
	echo "We still need ".($blocksLeft = ($dropBlock - $currentBlock))." (current: {$currentBlock} - Drop Block: {$dropBlock}) more blocks before the drop.<br/>";
	echo "If we multiply that by an avarage time of {$gentime} seconds per block, we still need about: ".($secondsLeft = ($gentime*$blocksLeft))." seconds before drop.<br/><br/>";
	
	echo "Meaning, if my calculation is right, drop will commence in: "	.gmdate("H", $secondsLeft). " hours and ".gmdate("i", $secondsLeft)." minutes <br/>To be more specific AROUND <b>".date("d-m-Y H:i",(strtotime(date("d-m-Y H:i")) + $secondsLeft)). " CET (Amsterdam)</b><br/><br/>";
	
	echo "For conversion: <a href=\"http://www.thetimezoneconverter.com/\">Convert timezone</a><br/><br/>";
	
	echo "I do not take liability, etc, just a quick calculation for personal use. Like it? Send me some neo :) at: AXCLjFvfi47R1sKLrebbRJnqWgbcsncfro<br/><br/>";
	
	echo "Cheers, Woodehh<br/>(Neo Discord: @Woodehh, CoZ)<br/>woodeh [at] cityofzion [dot] io";

	
?>