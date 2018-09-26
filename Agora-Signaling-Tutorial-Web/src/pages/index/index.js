import $ from 'jquery';
import 'bootstrap-material-design/dist/css/bootstrap-material-design.min.css';
import 'bootstrap-material-design';

import '../../assets/stylesheets/main.css';

const checkAccount = account => {
  if (!account) return false; // Empty
  if (!/^[^\s]*$/.test(account)) {
    // Has space character
    return false;
  }
  return true;
};

$('#join-meeting').click(function(e) {
  // Join btn clicked
  e.preventDefault();
  var account = $('#account-name').val() || '';
  if (checkAccount(account)) {
    // Account has to be a non empty numeric value
    window.location.href = `meeting.html?account=${account}`;
  } else {
    $('#account-name')
      .removeClass('is-invalid')
      .addClass('is-invalid');
  }
});

// eslint-disable-next-line
$('#sdk-version').html(new Signal().getSDKVersion());
