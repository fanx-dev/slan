if(typeof XMLHttpRequest == "undefined"){
  XMLHttpRequset == function(){
    return new ActiveXObject(
      navigator.userAgent.indexOf("MSIE 5") >= 0 ?
        "Microsoft.XMLHTTP" : "Msxml2.XMLHTTP"
    );
  };
}

function ajax(options) {
  options = {
    type: options.type || "POST",
    url: options.url || "",
    timeout : options.timeout || 5000,
    onComplete: options.onComplete || function(){},
    onError: options.onError || function(){},
    onSuccess: options.onSuccess || function(){},
    data: options.data || ""
  };

  var xml = new XMLHttpRequest();
  xml.open(options.type, options.url, true);
  var timeoutLength = options.timeout;
  var requestDone = false;
  setTimeout(function(){
    requestDone = true;
  }, timeoutLength);

  xml.onreadystatechange = function(){
    if (xml.readyState == 4 && !requestDone){
      if (httpSuccess(xml)){
        options.onSuccess(httpData(xml, options.data));
      }else{
        options.onError();
      }
      options.onComplete();

      xml = null;
    }
  };

  xml.send();

  function httpSuccess(r){
    try{
      return !r.status && location.protocol == "file:" ||
        (r.status >= 200 && r.status < 300) ||
        r.status == 304 ||
        navigator.userAgent.indexOf("Safari") >= 0
          && typeof r.status == "undefined";
    }catch(e){}

    return false
  }

  function httpData(r, type){
    var ct = r.getResponseHeader("content-type");
    var data = !type && ct && ct.indexOf("xml") >= 0;
    data = type == "xml" || data ? r.responseXML : r.responseText;
    if (type == "script")
      eval.call(window, data);
    return data;
  }

}