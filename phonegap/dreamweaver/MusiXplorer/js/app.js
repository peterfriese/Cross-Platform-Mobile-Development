$(document).ready(function(){
    getTweets = function(){
 
    var user = $("#searchField").val();
    if(user != ""){
        $("#searchField").html('');
        // show loading image
        //$.mobile.showPageLoadingMsg();
		// 
		// 'http://twitter.com/status/user_timeline/'+user+'.json?count=10&callback=?
        $.getJSON('http://itunes.apple.com/search?term=' + user + '%@&limit=200&country=DE&entity=album&attribute=artistTerm', function(data){
        $('#items li').remove();
        $.each(data.results, function(index, item) {
			collectionName = item.collectionName;
			artistName = item.artistName;
			artworkUrl = item.artworkUrl60;
			
            // create list item template
            $("#items").append('<li><a href="#"><img src="' + artworkUrl + '"/><h4>' + collectionName + '</h4><p>' + artistName + '</p></a></li>');
			
			$('#items').append('<li><a href="#">' +
					'<img src="' + artworkUrl + '"></img>' +
					'<h4>' + collectionName + '</h4>' +
					'<p>' + artistName + '</p>' + 
					'</a></li>');
			
            // Refresh list so jquery mobile can apply iphone look to the list
            $("#items").listview();
            $("#items").listview("refresh");       
 
        });
        // hide loading image
        //$.mobile.hidePageLoadingMsg();
        });
      }
    }
 });