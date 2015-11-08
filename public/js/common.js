  $( document ).ready(function() {  
    var $gallery = $( "#gallery" ), $selection = $( "#selection" );
    var recycle_icon = "<a href='link/to/recycle/script/when/we/have/js/off' title='Recycle this image' class='ui-icon ui-icon-trash'>Recycle image</a>";
    var $list = $("ul", $selection).length ?
      $( "ul", $selection ) :
      $( "<ul class='gallery ui-helper-reset'/>" ).appendTo( $selection );  
    $( ".ui-beamer-user" ).append( recycle_icon ).appendTo( $list ).fadeIn(function() {
      $(this).animate({ width: "48px" }).find( "img" ).animate({ height: "36px" });
    });  
  });

  $(function() {
      $(".submit-button").button();
  });

  $(function() {
    // there's the gallery and the trash
    var $gallery = $( "#gallery" ),
      $selection = $( "#selection" );
 
    // let the gallery items be draggable
    $( "li", $gallery ).draggable({
      cancel: "a.ui-icon", // clicking an icon won't initiate dragging
      revert: "invalid", // when not dropped, the item will revert back to its initial position
      containment: "document",
      helper: "clone",
      cursor: "move"
    });

    // let the selection items be draggable
    $( "li", $selection ).draggable({
      cancel: "a.ui-icon", // clicking an icon won't initiate dragging
      revert: "invalid", // when not dropped, the item will revert back to its initial position
      containment: "document",
      helper: "clone",
      cursor: "move",
      create: function() {       
      }
    });
 
    // let the selection be droppable, accepting the gallery items
    $selection.droppable({
      accept: "#gallery > li",
      activeClass: "ui-state-highlight",
      drop: function( event, ui ) {
        deleteImage( ui.draggable );
      }
    });

    // $( "li", $selection ).appendTo( $( "ul", $selection ) ).fadeIn(function() {
    //   $( "this" ).animate({ width: "48px" }).find( "img" ).animate({ height: "36px" });
    // });
 
    // let the gallery be droppable as well, accepting items from the selection
    $gallery.droppable({
      accept: "#selection > li",
      activeClass: "custom-state-active",
      drop: function( event, ui ) {
        recycleImage( ui.draggable );
      }
    });
 
    // image deletion function
    var recycle_icon = "<a href='link/to/recycle/script/when/we/have/js/off' title='Recycle this image' class='ui-icon ui-icon-trash'>Recycle image</a>";
    function deleteImage( $item ) {
      $item.fadeOut(function() {
        var $list = $( "ul", $selection ).length ?
          $( "ul", $selection ) :
          $( "<ul class='gallery ui-helper-reset'/>" ).appendTo( $selection );
 
        $item.find( "a.ui-icon-refresh" ).remove();
        $item.append( recycle_icon ).appendTo( $list ).fadeIn(function() {
          $item
            .animate({ width: "48px" })
            .find( "img" )
              .animate({ height: "36px" });
        });
      
        $.ajax({
          type: "POST",
          timeout: 50000,
          cache: false,
          processData: false,
          url: '/beamer/update/add/' + $item.attr('value'),
          dataType: 'json',
          success: function(data) {
          },
          error: function(xhr, ajaxOptions, thrownError) {
              alert(xhr.status);
              alert(thrownError);
          }
        });
      });
    }
 
    // image recycle function
    function recycleImage( $item ) {
      $item.fadeOut(function() {
        $item
          .find( "a.ui-icon-trash" )
            .remove()
          .end()
          .css( "width", "96px")
          .find( "img" )
            .css( "height", "72px" )
          .end()
          .appendTo( $gallery )
          .fadeIn();

        $.ajax({
          type: "POST",
          timeout: 50000,
          cache: false,
          processData: false,
          url: '/beamer/update/delete/' + $item.attr('value'),
          dataType: 'json',
          success: function(data) {
          },
          error: function(xhr, ajaxOptions, thrownError) {
              alert(xhr.status);
              alert(thrownError);
          }
        });
      });
    }
 
    // image preview function, demonstrating the ui.dialog used as a modal window
    function viewLargerImage( $link ) {
      var src = $link.attr( "href" ),
        title = $link.siblings( "img" ).attr( "alt" ),
        $modal = $( "img[src$='" + src + "']" );
 
      if ( $modal.length ) {
        $modal.dialog( "open" );
      } else {
        var img = $( "<img alt='" + title + "' width='384' height='288' style='display: none; padding: 8px;' />" )
          .attr( "src", src ).appendTo( "body" );
        setTimeout(function() {
          img.dialog({
            title: title,
            width: 400,
            modal: true
          });
        }, 1 );
      }
    }
 
    // resolve the icons behavior with event delegation
    $( "ul.gallery > li" ).click(function( event ) {
      var $item = $( this ),
        $target = $( event.target );
 
      if ( $target.is( "a.ui-icon-refresh" ) ) {
        deleteImage( $item );
      } else if ( $target.is( "a.ui-icon-zoomin" ) ) {
        viewLargerImage( $target );
      } else if ( $target.is( "a.ui-icon-trash" ) ) {
        recycleImage( $item );
      }
 
      return false;
    });
  });


$(function() {
    $('#button-user-input').click(function(e) {
        e.preventDefault(); //Prevent the normal submission action

        var comment = document.getElementById("user-input").value.toString();

        $.ajax({
          type: "POST",
          timeout: 50000,
          cache: false,
          url: '/beamer/update/user/defined/comment',
          dataType: 'json',
          data: {'comment': comment},
          success: function(data) {
            location.reload(true);
          },
          error: function(xhr, ajaxOptions, thrownError) {
              alert(xhr.status);
              alert(thrownError);
          }
        });

    });
});