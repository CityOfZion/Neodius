<?php
	//include neo php
	include("./config/config.php");

	//set RPC node
	$rpcObject = new NeoPHP\NeoRPC(true);
	$rpcObject->setNode($seed);

	//get the version
	$version = $rpcObject->getVersion();
	
?><!doctype html>
<html lang="en">
  <head>
    <!-- Required meta tags -->
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">

    <!-- Bootstrap CSS -->
	<link href="/assets/css/bootstrap.css" rel="stylesheet" />
	<link href="/assets/css/landing-page.css" rel="stylesheet"/>
	<link href="https://fonts.googleapis.com/css?family=Open+Sans:400,400i" rel="stylesheet">
    <link href="/assets/css/pe-icon-7-stroke.css" rel="stylesheet" />
    <link href="/assets/css/font-awesome.min.css" rel="stylesheet" />
    <title>Neodius BlockMon</title>
  </head>
  <body>
	<nav class="navbar navbar-transparent" role="navigation" style="background-image: url(/assets/images/background/bg-header.jpg); background-position: center top; margin-bottom: 10px; padding-bottom: 10px; background-size: cover">
	    <div class="container">
	        <!-- Brand and toggle get grouped for better mobile display -->
	        <div class="navbar-header">
	            <button id="menu-toggle" type="button" class="navbar-toggle" data-toggle="collapse" data-target="#example">
	            <span class="sr-only">Toggle navigation</span>
	            <span class="icon-bar bar1"></span>
	            <span class="icon-bar bar2"></span>
	            <span class="icon-bar bar3"></span>
	            </button>
	            <div class="logo-container">
                    <a href="http://neodius.io">
                        <img src="/assets/images/logo/logo-web.png" alt="Logo Neodius" style="max-width: 250px;"/>
                    </a>
	            </div>
	        </div>
	        <!-- Collect the nav links, forms, and other content for toggling -->
	        <div class="collapse navbar-collapse" id="example" >
	            <ul class="nav navbar-nav navbar-right">
	                <li>
	                    <a href="http://www.github.com/CityOfZion/Neodius/">
	                    <i class="fa fa-github"></i>
	                    Github
	                    </a>
	                </li>	
	                <li>
	                    <a href="https://neodius.io/">
	                    <i class="fa fa-globe"></i>
	                    Neodius.io
	                    </a>
	                </li>	
	            </ul>
	        </div>
	        <!-- /.navbar-collapse -->
	    </div>
	</nav>	  
	<div class="container">
	  	<div id="row">
		  	<div class="col-lg-12">
		  		<h1>Neo Blocktime Generation Monitor</h1>
		  	</div>
	  		<div class="col-md-8">
		  		<b>Seed: <?=$seed?></b> <i>(version: <?=$version['useragent']?>)</i>
		  		<span class='waiter' style="display: none;">
					<i class="fa fa-cog fa-spin"></i>
				</span>
		  		<table class="table table-striped table-sm">
			  		<thead>
				  		<tr id="head-count">
					  		<th>Block #</th>
					  		<th>Generation date/time</th>
					  		<th>Generation time</th>
					  		<th class="hidden-sm hidden-xs">Transactions</th>
					  		<th class="hidden-sm hidden-xs">Lookup</th>
				  		</tr>
			  		</thead>
			  		<tbody id="insert-table-body">
				  		<tr>
					  		<td align = "center" colspan = 4>Loading...</td>
				  		</tr>
			  		</tbody>
		  		</table>
	  		</div>
			<div class="col-lg-3 col-md-3 col-sm-3 hidden-sm hidden-xs pull-right" id="nurse">
			    <div class="nurse-holder">
			        <img src="/assets/images/misc/nurse-esmee.png" style="max-height: 510px;" class="img-responsive" alt="Dominique">
			     </div>
			    <div class="monitor-holder hidden-sm hidden-xs">
			        <canvas id="canvas" width="127" height="89"></canvas> 
			        <img src="/assets/images/misc/heart-monitor.png"  style="max-height: 391px;" class="img-responsive" alt="Heart Monitor">
			    </div>
			</div>	  		
	  	</div>
	</div>

  	<div class="clearfix"></div>
  	
	<div class="col-lg-12">		
	    <footer class="footer">
	        <div class="container">
	            <nav class="pull-left">
	
	            </nav>
	            <div class="social-area pull-right">
	            </div>
	            <div class="copyright">
	                &copy; <?=date("Y")?> <a href="http://www.github.com/CityOfZion">City of Zion</a>, Made with ❤️ for NEO in Arnhem, Netherlands<br/><br/>
	                						You can always send me some cryptos<br/>
					    NEO: <span>AJYoERJ6VFGVPq</span><span>8nKjUvnfBLpYqkG39j4x</span><br/>
					    BTC: <span>1Es9qssB7275Wf</span><span>9x9A21aPf8xf9wYomfv1</span><br/>

	            </div>
	        </div>
	    </footer>
	</div>

    <script src="/assets/js/jquery-1.10.2.js"></script>
    <script src="/assets/js/bootstrap.js"></script>
    <script src="/assets/js/blockmon.js"></script>
    
    
  </body>
</html>