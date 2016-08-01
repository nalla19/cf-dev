var __xx_set_visible = {};
function xx_set_visible(imgId, tipId, e, show){
    // get the table we're going to show
    var $tip = $("#" + tipId);
    if( !__xx_set_visible[tipId] ){
        // move to the body and make visible
        $tip.appendTo("body").css("visibility", "visible");
        __xx_set_visible[tipId] = true;
    }
    $tip[show ? "show" : "hide"]();
    
    
    //Script for removing the second TR of this table, adding padding to the right and adding nowrap
    $("#" + tipId + " tr:nth-child(1) td:nth-child(2)").attr("nowrap","nowrap");
    $("#" + tipId + " tr:nth-child(1) td:nth-child(2)").css("padding-right","8px");
    $("#" + tipId + " tr:nth-child(2)").remove();
    
    
    // make sure we place the tip in the correct location
    xx_move_tag(imgId, tipId, e);
}
function xx_move_tag(imgId, tipId, e){
    // get the table we're going to show
    var $tip = $("#" + tipId);
    // get the scroll offsets
    var scroll = {top: $(window).scrollTop(), left: $(window).scrollLeft()};
    // if we're IE we need to create the e.pageX/pageY events    
    if( !e.pageY ){
        e.pageY = e.clientY + scroll.top;
        e.pageX = e.clientX + scroll.left;
    }
    var pos = {top: e.pageY + 20, left: e.pageX + 10}; // add padding for cursor
    var tip = {width: $tip.outerWidth() + 10, height: $tip.outerHeight() + 10}; // add padding for edge
    var screen = {right: scroll.left + $("body").width(), bottom: scroll.top + $(window).height()};
    // if we're going to be off the screen, adjust the position
    if( pos.left + tip.width > screen.right ){
        // don't move past most right of screen
        pos.left = screen.right - tip.width; // pos.left - tip.width || screen.right - tip.width - 10;
    }
    if( pos.top + tip.height > screen.bottom ){
        // don't move past most right of screen
        pos.top = pos.top - tip.height - 15; // since we're moving tip above we need adjust for the original padding we add
    }
    // position the
    $tip.css(pos);
}

function xx_getAbsX(obj) {
    var leftOffset = 0;
    if (obj.offsetParent) while (obj.offsetParent) {
        leftOffset += obj.offsetLeft;
        obj = obj.offsetParent;
        if(obj.style && obj.style.position) break;
      }
    else if (obj.x) leftOffset = obj.x;
    return leftOffset;
}

function xx_getAbsY(obj) {
    var topOffset = 0;
    if (obj.offsetParent) while (obj.offsetParent) {
            topOffset += obj.offsetTop;
            obj = obj.offsetParent;
            if(obj.style && obj.style.position) break;
     }
     else if (obj.y)
            topOffset = obj.y;
    return topOffset;
}

function xx_supported_client() {
    return (document.all) || (document.getElementById);
}

function xx_get_by_id(id) {
    return document.all? document.all[id]: document.getElementById? document.getElementById(id) : "";
}