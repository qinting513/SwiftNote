//获取页面中的导航信息

var menuDiv = document.querySelector('div.nv_i')
var menus = menuDiv.querySelectorAll('li')
function parseMenus() {
	result = [];
	for(var i=0; i<menus.length; i++){
		var menu = menus[i];
		var url = menu.querySelector('a').getAttribute('href');
		var title = menu.querySelector('a').textContent;
		result.push({'url':url, 'title':title});
	}
	return result;
}
var items = parseMenus();
//将items中的数据传输到swift中
webkit.messageHandlers.didFetchMenus.postMessage(items)

 






