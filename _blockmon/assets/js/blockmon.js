	var x;
	
	function counterPlus() {
		var seconds = $(".count-up").html();
		seconds++;
		$(".count-up").html(seconds);		  	
	}
	
	function startCounterPlus() {
	  	clearInterval(x);
		x = setInterval(function(){
			counterPlus();
		}, 1000)
	}
	
	
	function drawWave() {
		setTimeout(function() {
			requestAnimationFrame(drawWave);
			ctx.lineWidth = "2";
			ctx.strokeStyle = 'white';
			// Drawing code goes here
			n += 1;
			if (n >= data.length * 1) {
				n = 1;
			}
			ctx.beginPath();
			ctx.moveTo(n - 1, data[n - 1] - 55);
			ctx.lineTo(n, data[n] - 55);
			ctx.stroke();
			ctx.clearRect(n + 1, 0, 1, canvas.height);
			ctx.clearRect(n + 2, 0, 1, canvas.height);
		}, 800 / fps);
	}	
	
	
	function min_and_max(json_data) {
	    var min = Number.MAX_VALUE;
	    var max = Number.MIN_VALUE;
	    for (var data_key in json_data) {
	        var entry = json_data[data_key]
	        for(var key in entry) {
	            var x = entry[key];
	            if (!isNaN(x)) { // to avoid using date object
	                if (x < min) {min = x;}
	                else if (x > max) {max = x;}
	            }
	        }
	    }
	    return {'min': min, 'max': max};
	}
	
	function reloadData() {
		$('.waiter').show();
		$.get("/ajax/block-time-gen-json.php",function(data){
			$("#insert-table-body").html("");
			for (var i = 0; i < data.length; i++) {
				 $("#insert-table-body").append(
				 	"<tr>"+
				 		"<td>" + data[i][0] + "</td>"+
				 		"<td>" + data[i][1] + "</td>"+
						"<td>" + data[i][2] + "</td>"+
						"<td class=\"hidden-xs hidden-sm\">" + data[i][3] + "</td>"+
						"<td class=\"hidden-xs hidden-sm\">" + data[i][4] + "</td>"+
				 		"</tr>");				
			}
			
			
			
			document.title = '#' + data[0][0]+' - Neodius BlockMon';
			
			counterPlus();
			startCounterPlus();
			
			setTimeout(function(){
				$('.waiter').hide();
			},200);
			
			setTimeout(function(){
				reloadData()
			}, 3000);
		});				
	}


	
	$(document).ready(function(){
		canvas = document.getElementById("canvas");
		ctx = canvas.getContext("2d");
		ctx.fillStyle = "#dbbd7a";
		ctx.fill();
		fps = 40;
		n = 1;
		data = [
		100, 100, 100, 100, 100, 100, 100, 95, 90, 82, 90, 100, 110, 120, 100, 80, 70, 65, 70, 80, 110, 130, 135, 130, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 95, 90, 82, 90, 100, 110, 120, 100, 80, 70, 65, 70, 80, 110, 130, 135, 130, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 95, 90, 82, 90, 100, 110, 120, 100, 80, 70, 65, 70, 80, 110, 130, 135, 130, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 95, 90, 82, 90, 100, 110, 120, 100, 80, 70, 65, 70, 80, 110, 130, 135, 130, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 95, 90, 82, 90, 100, 110, 120, 100, 80, 70, 65, 70, 80, 110, 130, 135, 130, 100, 100, 100, 100, 100, 100
		];
		drawWave();		
		reloadData()			
	});




	
	