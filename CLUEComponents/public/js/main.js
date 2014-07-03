window.addEventListener('polymer-ready', function(e) {
    $("paper-ripple").click(function(){
        // $("#bottom").collapse().toggle();
        $("#bottom").toggleClass("tall");
    });

    $("#start").click(function(){
        var label = $(this).attr("label");
        var self = this;
        console.log(label);
        switch (label){
        case "start":
            $(self).attr("label","initializing");
            setTimeout(function(){
                $(self).attr("label","stop");
            },3000)
            break;
        case "stop":
            $(self).attr("label","destroying");
            setTimeout(function(){
                $(self).attr("label","start");
            },3000)
            break;
        }
    })
});
