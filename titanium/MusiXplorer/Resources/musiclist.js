var win = Titanium.UI.currentWindow;  

var search = Titanium.UI.createSearchBar({
	height: 43,
	hintText: 'Artist',
	top: 0
});

search.addEventListener('change', function(event) {
	searchTerm = search.value;
	if (searchTerm.length > 2) {
		tableView.loadData(searchTerm);
	}
});

var tableView = Titanium.UI.createTableView( {
	search: search,
	filterAttribute: 'artistName',
	scrollable: true,
	top: 0 
});

tableView.loadData = function(searchTerm) {
	var data = [];
	
    var loader = Titanium.Network.createHTTPClient();  
    
	loader.open("GET","http://itunes.apple.com/search?term=" + searchTerm + "&limit=20&country=DE&entity=album&attribute=artistTerm");
	loader.onload = function() {
		var json = JSON.parse(this.responseText);
	    var results = json.results;
  
		for (var i = 0; i < results.length; i++) {  
		    var collectionName  = results[i].collectionName;  
		    var artistName   = results[i].artistName;  
		    var imageUrl = results[i].artworkUrl60;
		    
		    var row = Titanium.UI.createTableViewRow({
		    	artistName: artistName,
		    	collectionName: collectionName,
		    	height: 'auto'
		    });
		    
			var cellView = Titanium.UI.createView({ 
				height: 'auto', 
				layout: 'vertical', 
				top: 5, 
				right: 5, 
				bottom: 5, 
				left: 5 
			});  
			  
			var artworkImage = Titanium.UI.createImageView({  
			    image: imageUrl,  
			    top: 0,  
			    left: 0, 
			    height: 48,
			    width: 48
			});  
			cellView.add(artworkImage);
			
			var collectionLabel = Titanium.UI.createLabel({  
			    text: collectionName,  
			    left: 54,  
			    width: 120,  
			    top: -48,  
			    bottom: 2,  
			    height: 16,  
			    textAlign: 'left',  
			    color :'#444444',  
			    font: {  
			        fontFamily: 'Trebuchet MS',
			        fontSize:14,
			        fontWeight:'bold'  
			    }  
			});  
			cellView.add(collectionLabel);

			var artistLabel = Titanium.UI.createLabel({  
			    text: artistName,  
			    left: 54,  
			    top: 0,  
			    bottom: 2,  
			    height: 'auto',  
			    width: 236,  
			    textAlign: 'left',  
			    font:{ fontSize:14 }  
			});  
			cellView.add(artistLabel);  
			
			// Add the post view to the row  
			row.add(cellView);  
			  
			// Give each row a class name  
			row.className = "item" + i;  
		    
		    data[i] = row;
		}
		tableView.data = data;

	}  
	loader.send();	
}

win.add(tableView);
