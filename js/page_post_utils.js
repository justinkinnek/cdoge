
var DATA;
$.getJSON(
  // 'https://s3.amazonaws.com/cdoge/saved_fb_krawl.json',
    'http://localhost:8000/js/data_as_object.js',
  { },
  function(jsonData) {
      console.log('got data!!!');
      DATA = jsonData;
      set_embedded_posts(["42231354758"], 5);
  }).error(function (a,b) {
    console.log("ERROR!!!")
    console.log(a);
    console.log(b);
});

var DENDRO_JSON;
$.getJSON("http://localhost:8000/dendro.json", {}, function (jsonData) {
    DENDRO_JSON = jsonData
}).error(function (a,b) {
    console.log(a)
    console.log(b)
});

function posts_for_page_ids(page_ids) {
    var results = [];
    for (var page_id in DATA){
        if ($.inArray(page_id, page_ids) > -1 && DATA[page_id]["feed"] && "data" in DATA[page_id]["feed"]){
            var page_name = DATA[page_id][""]["name"];
            var website = DATA[page_id][""]["website"];
            for (var i=0; i < DATA[page_id]["feed"]["data"].length;i++){
                var curr = DATA[page_id]["feed"]["data"][i];
                results.push({
                    "id": curr["id"],
                    "created_time": Date(curr["created_time"]),
                    "page_name": page_name,
                    "website": website
                })
            }
        }
    }
    return results;
};


function page_data_filter(page_ids){
    var results = [];
    for (var page_id in DATA) {
        if ($.inArray(page_id, page_ids) > -1){
            results.push({
                "name": DATA[page_id][""]["name"],
                "id": page_id,
                "fan_count": DATA[page_id][""]["fan_count"],
                "website": DATA[page_id][""]["website"],
                "description": DATA[page_id][""]["description"],
                "engagement_count": DATA[page_id][""]["engagement"] && DATA[page_id][""]["engagement"]["count"],
                "social_sentence": DATA[page_id][""]["engagement"] && DATA[page_id][""]["engagement"]["social_sentence"],
                "city": DATA[page_id][""]["location"] && DATA[page_id][""]["location"]["city"],
                "country": DATA[page_id][""]["location"] && DATA[page_id][""]["location"]["country"]
            })

        }
    }
    return results;
};


function reload_embedded_posts() {
    $.getScript("https://connect.facebook.net/en_US/sdk.js", function () {
        console.log(FB);
        console.log("is FB")
        FB.init({
            version: "v2.5"
        });
        FB.XFBML.parse();
    });

}

function shuffle(a) {
    var j, x, i;
    for (i = a.length; i; i--) {
        j = Math.floor(Math.random() * i);
        x = a[i - 1];
        a[i - 1] = a[j];
        a[j] = x;
    }
}


function set_embedded_posts(page_ids, n_posts){
    var posts_root = $("#posts_view");
    posts_root.empty();
    var post_ids = posts_for_page_ids(page_ids);
    // post_ids.sort(function(a,b){
    //    return b['created_time'] - a['created_time'];
    // });
    shuffle(post_ids);
    for (var i=0;i<post_ids.length;i++){
        if (i<n_posts){
            var new_post = document.createElement("div");
            console.log("here");
            new_post.setAttribute("class" ,"fb-post");
            var splits = post_ids[i]["id"].split("_");
            new_post.setAttribute("data-href", "https://www.facebook.com/"+splits[0]+"/posts/"+splits[1]+"/");
            new_post.setAttribute("data-width", "500");
            posts_root.append(new_post);
            console.log("AHH Happened");
        }

    }
    reload_embedded_posts();
}

function get_dendrogram_pages(parent, sub) {
    var parent_doc = DENDRO_JSON["children"].filter(function (c) {
        return c["name"] == parent
    })[0];
    var sub_doc = parent_doc["children"].filter(function (c) {
        return c["name"] == sub
    })[0];
    var results = []
    for (hit in sub_doc["data"]){
        results.push(sub_doc["data"][hit][1][0])
    }
    return results;
}

function update_side_panel(page_data){
    var panel_root = $("#side-panel");
    panel_root.empty();
    for (var i=0;i<page_data.length;i++){
        var hit = page_data[i];
        var new_item = document.createElement("div");
        new_item.setAttribute("class", "panel-item");
        var name = document.createTextNode(hit["name"] || "");
        new_item.append(name);
        var a = document.createElement("br");
        new_item.append(a);
        var b = document.createElement("br");
        var location = document.createTextNode(hit["city"] +", "+ hit["country"]);
        new_item.append(location)
        new_item.append(b);
        var _id = document.createTextNode(hit["id"]);
        new_item.append(_id)
        panel_root.append(new_item);
    }
}

function enforce_sidepanel_opened() {
    var sidePanel = $("#side-panel");
    if (!sidePanel.hasClass("opened")) {
        sidePanel.addClass("opened");
    }
}