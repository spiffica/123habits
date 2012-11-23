// $(function() {

//   $('body').on('touchstart.dropdown.data-api','.dropdown-menu',function (e) {
//     e.stopPropagation();
//     console.log("what??");
//     e.preventDefault();
//   });
// });

  function removePreviousErrors()
  {
        // remove validation errors from previous request
      $('div.control-group').removeClass('error');
      $('span.help-inline').remove();
  }

  function showModalContent(content,header)
  {
    $('.modal-body').html(content);
    $('#myModal').modal({keyboard:true, backdrop:true}).show();
    $('div.modal-backdrop').css({'display':'block'});
    $('#action_name').html(header);
  }

  function fadeModal()
  {
    $('div.modal').fadeOut('slow');
    $('div.modal-backdrop').fadeOut('slow');
  }
