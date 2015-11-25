$(function() {
    $('.icon-change').on("change", function() {
        // e.preventDefault(); //Prevent the normal submission action
        var form = document.getElementById("edit-beamer-form");
        var input = this;
        var id = form.elements.namedItem("beamer-id").value.toString(); 
        var icon = this.files[0];
        var fd = new FormData();
        fd.append('data', icon);

        $.ajax({
            type: "POST",
            contentType: false,
            timeout: 50000,
            cache: false,
            processData: false,
            url: '/dashboard/beamer/upload/' + id + '/icon',
            data: fd,
            success: function(data) {
                d = new Date();
                $("#icon-image").attr("src", "/upload/icon/" + id + ".jpg?" + new Date().getTime());
                window.alert("Icon Uploaded");
                return false;
            },
            error: function(xhr, ajaxOptions, thrownError) {
                alert(xhr.status);
                alert(thrownError);
            }
        });

    });
});

$(function() {
    $('#edit-beamer-form').submit(function(e) {
        e.preventDefault(); //Prevent the normal submission action

        var form = this;
        var id = form.elements.namedItem("beamer-id").value.toString(); 

        $.post('/dashboard/beamer/' + id + '/update', {
            'name': form.elements.namedItem("beamer-name").value.toString(),
            'tag': form.elements.namedItem("beamer-tag").value.toString(),
            'id': id 
        }, function(response) {
            $("#edit-beamer-dialog").dialog("close");
            location.reload(true);
        });
    });
});

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
        var form = $(this)[0].form; 
        var id = form.elements.namedItem("beamer-id").value.toString(); 
        var editform = document.getElementById("edit-beamer-form");

        $.ajax({
            type: "GET",
            contentType: false,
            timeout: 50000,
            cache: false,
            processData: false,
            url: '/dashboard/beamer/' + id,
            dataType: 'json',
            success: function(data) {
                editform.elements.namedItem("beamer-id").value = id; 
                editform.elements.namedItem("beamer-name").value = data["name"]; 
                editform.elements.namedItem("beamer-tag").value = data["tag"]; 
                $("#icon-image").attr("src", "/upload/icon/" + id + ".jpg?" + new Date().getTime());
                $("#edit-beamer-dialog").dialog("open");
            },
            error: function(xhr, ajaxOptions, thrownError) {
                alert(xhr.status);
                alert(thrownError);
            }
        });
    });
});

$(function() {
    $('.button-delete-beamer').click(function() {
        var form = $(this)[0].form; 
        var id = form.elements.namedItem("beamer-id").value.toString(); 

        $.ajax({
            type: "DELETE",
            contentType: false,
            timeout: 50000,
            cache: false,
            processData: false,
            url: '/dashboard/beamer/' + id + '/delete',
            success: function(data) {
                window.alert("Beamer deleted");
                location.reload(true);
            },
            error: function(xhr, ajaxOptions, thrownError) {
                alert(xhr.status);
                alert(thrownError);
            }
        });
    });
});


// function for add button 
$(function() {
    $("#add-beamer-dialog").dialog({
        width: 500,
        height: 300,
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

    $("#add-beamer-button").click(function() {
        var Id = this.value.toString()
        $("#add-beamer-dialog").dialog("open");
    });

    $('#add-beamer-form').submit(function(e) {
        e.preventDefault(); //Prevent the normal submission action

        var form = this;
        var id = form.elements.namedItem("beamer-id").value.toString(); 

        $.post('/dashboard/beamer/' + id + '/add', {
            'name': form.elements.namedItem("beamer-name").value.toString(),
            'tag': form.elements.namedItem("beamer-tag").value.toString(),
            'id': id 
        }, function(response) {
            $("#edit-beamer-dialog").dialog("close");
            location.reload(true);
        });
    });
});