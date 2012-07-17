function removePreviousErrors()
{
      // remove validation errors from previous request
    $('div.control-group').removeClass('error');
    $('span.help-inline').remove();
}