function MyPlugin() 
{
    
}

MyPlugin.prototype.print = function(message) 
{
    PhoneGap.exec("MyPlugin.print", "print", message);
}

MyPlugin.install = function() 
{
    if(!window.plugins) {
        window.plugins = {};
    }
    
    window.plugins.myPlugin = new MyPlugin();
    return window.plugins.myPlugin;
}

PhoneGap.addConstructor(MyPlugin.install);