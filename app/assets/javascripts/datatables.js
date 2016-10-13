
$(document).ready(function() {

  $('tbody tr').each( function () {
    var url = $(this).attr("data-view-link");
    var cells = $(this).find('td:not(:first-child, :last-child)');
    
    if (typeof url != 'undefined') { 
      cells.each(function(){
          $(this).click(function(){  window.location = url; });
        }); 
    }
  });

});
