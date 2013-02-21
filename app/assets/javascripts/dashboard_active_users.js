google.load("visualization", "1", { packages:["corechart"] });
google.setOnLoadCallback(
  Scheddo.Reports.drawColumnChart({
    element: $('#monthly-report'),
    colors: ['#217D5B'],
    hAxis: 'Months'
  })
);

google.setOnLoadCallback(
  Scheddo.Reports.drawColumnChart({
    element: $('#weekly-report'),
    colors: ['#217D5B'],
    hAxis: 'Weeks'
  })
);

$(document).ready(function(){
  $('.tab').on('click', function(event){
    $('#data-url').attr('href', $(this).data('url'));
  });
});
