(function(){
  var path = window.location.pathname

  var path_segments = path.split("/")
  
  console.log(path_segments)


  if(path_segments.length > 3){
    var repo = path_segments[1];
    var ref = path_segments[2];

    
    var base_path = "/"+repo+"/"+ref;

    var tags = ["a", "img", "script", "link"];

    for(t in tags){
      var tag = tags[t];
      insertBasePath(document.getElementsByTagName(tag), base_path);
    }
  }


  function insertBasePath(elements, base_path){

    for(e in elements){

      el = elements[e];

      if(el.src){
        var url = el.src.replace(window.location.origin, "")

        if(url[0] === "/")
          el.src = base_path + url;

      }

      if(el.href){

        var url = el.href.replace(window.location.origin, "")

        if(url[0] === "/")
          el.href = base_path + url;
      }

    }

  }

})();
