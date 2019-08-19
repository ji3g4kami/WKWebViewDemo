document.getElementById("countButton").addEventListener('click', function(){ window.webkit.messageHandlers.count.postMessage("You've clicked");
});
