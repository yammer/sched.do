google.load("visualization", "1", { packages:["corechart"] });
google.setOnLoadCallback(Scheddo.Reports.drawLineChart({
  element: $('#weekly_invite_conversion'),
  hAxis: 'Weeks'
}));
