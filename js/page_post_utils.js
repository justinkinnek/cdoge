
var DATA;
$.getJSON(
  // 'https://s3.amazonaws.com/cdoge/saved_fb_krawl.json',
    'https://s3.amazonaws.com/cdoge/data_as_object.js',
  { },
  function(jsonData) {
      console.log('got data!!!');
      DATA = jsonData;
      console.log(DATA);
  }).error(function (a,b) {
    console.log("ERROR!!!")
    console.log(a);
    console.log(b);
});



function posts_for_pages_ids(page_ids) {
    var results = [];
    for (var page_id in DATA){
        if ($.inArray(page_id, page_ids) > -1 && "data" in DATA[page_id]["feed"]){
            for (var i=0; i < DATA[page_id]["feed"]["data"].length;i++){
                var curr = DATA[page_id]["feed"]["data"][i];
                results.push(curr["id"])
            }
        }
    }
    return results;
};