<?php
	header("Content-type: application/json");
	#include neo php
	include("../config/config.php");

	
	
	//cachefile
	$cacheFile = "../_tmp/block-gen-time.tmp";
	$cacheFileAge = time()-filemtime($cacheFile);
	$cacheFileContents = json_decode(file_get_contents($cacheFile),true);
	
	//blokc count
	$blockCount = (isset($_GET['count']) ? intval($_GET['count']) : 12);

	//set RPC node
	$rpcObject = new NeoPHP\NeoRPC(true);
	$rpcObject->setNode($seed);


	//get latest block and see if 
	if ($cacheFileAge > 2) {
		
		
		//get latest block and see if the cache 
		//file has the same latest block:
		$latestBlock = $rpcObject->getBlockCount();

		//get the latest cache block:
		$latestCachedBlock = $cacheFileContents[0]['index']+1;


		//open cache file and see if [0] is the same as $latestblock - 1
		if ($latestCachedBlock != $latestBlock) {
			
			$status = "Updating new data";
			
			//setup data array
			$cacheFileContents = array();

			//loop through last 10 blocks
			for ($i=$latestBlock;$i >= ($latestBlock- $blockCount);$i--) {
				
				$b = $rpcObject->getBlock($i-1);
				
				$cacheFileContents[] = [
					"index" => $b['index'],
					"time" => $b['time'],
					"tx" => count($b['tx']),
					"hash" => substr($b['hash'],2)
				];
			}
								
			//store stuff in cache
			file_put_contents($cacheFile, json_encode($cacheFileContents,JSON_PRETTY_PRINT));
			
		} else {
			$status = "Same block reading from cache";
			touch($cacheFile);
		}			
	} else {
			$status = "File not older than 2s; reading from cache";		
	}




	$jsonArray = [];
	
	//latest block
	$latest_block = $cacheFileContents[0]['index']+1;	
	
	$jsonArray[] = array(
		number_format($latest_block,0,",","."),
		"Generating...", 
		"<span class='count-up'>".((time()-$cacheFileContents[0]['time'])-8)."</span> seconds",
		"n/a",
		"n/a"
	);
	

	foreach ($cacheFileContents as $id => $block)  {
		
		$prevblock = $cacheFileContents[$id+1]['time'];
		$blocktime = $block['time'];
		
		$gentime = $times[] = $blocktime-$prevblock;
		
		$jsonArray[] =array(
			number_format($block['index'],0,",","."),
			date("d-m-Y H:i:s",$block['time']),
			$gentime." seconds"	,
			$block['tx']." transactions",
			"<a target=\"_blank\" href=\"https://neoscan.io/block/" . $block['hash'] . "\">Lookup block</a>"
		);

		if ($id == ($blockCount-2))
			break;
	}	
	
	die(json_encode($jsonArray,true));
	
?>