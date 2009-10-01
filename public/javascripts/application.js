$(document).ready(function() {
    h = Math.max($("#content").height(), $("#sidebar").height());

    $("#sidebar, #content").height(h);
    
    $(".movie_img").click(function() {
        movie_name = $(this).attr('id').substring(6);
        window.location = "/movie/"+movie_name;
    })
});