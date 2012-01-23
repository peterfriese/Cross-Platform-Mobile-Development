var tabGroup = Titanium.UI.createTabGroup();  
    
var mainWin = Titanium.UI.createWindow ({  
    title: "Music",  
    backgroundColor: "#fff",  
    url: "musiclist.js"  
});  
  
  
var mainTab = Titanium.UI.createTab ({  
    title: "Music",  
    icon: "KS_nav_views.png",  
    window: mainWin  
});  
    
tabGroup.addTab(mainTab);  
tabGroup.open();  