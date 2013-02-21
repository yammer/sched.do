google.load("visualization", "1", { packages:["corechart"] });
google.setOnLoadCallback(
  Scheddo.Reports.drawColumnChart({
    element: $('#monthly-report'),
    colors: ['#1ABC9C', '#16A085','#E74C3C'],
    hAxis: 'Months'
  })
);

google.setOnLoadCallback(
  Scheddo.Reports.drawColumnChart({
    element: $('#weekly-report'),
    colors: ['#1ABC9C', '#16A085','#E74C3C'],
    hAxis: 'Weeks'
  })
);

$(document).ready(function(){
  $('.tab').on('click', function(event){
    $('#data-url').attr('href', $(this).data('url'));
  });
});
