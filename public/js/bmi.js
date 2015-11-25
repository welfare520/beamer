$(function() {
    $("#edit-beamer-dialog").dialog({
        width: 600,
        height: 400,
        autoOpen: false,
        modal: true,
        show: {
            effect: "blind",
            duration: 200
        },
        hide: {
            effect: "explode",
            duration: 200
        }
    });

    $('.button-edit-beamer').click(function() {
        $("#edit-beamer-dialog").dialog("open");
    });
});
