Namespaced.declare('Scheddo');

Scheddo.Reports = {
  drawColumnChart: function(configuration) {
    var setupConfig = configuration;
    return function() {
      var data = new google.visualization.DataTable();
      _.each(setupConfig.element.data('chart').fields,
          function(columnData) {
            data.addColumn(columnData[0], columnData[1]);
      });
      data.addRows(setupConfig.element.data('chart').values);

      var options = {

        hAxis: {
          title: setupConfig.hAxis, 
          titleTextStyle: {
            fontName: 'Open Sans', 
            color: '#999999'
          }
        },
        isStacked: true,
        colors: setupConfig.colors,
        legendTextStyle: {
          fontName: 'Open Sans'
        }
      };

      var chart = new google.
        visualization.
        ColumnChart(setupConfig.element.get(0));

      chart.draw(data, options);
    }
  },

  drawLineChart: function(configuration) {
    var setupConfig = configuration;
    return function() {
      var data = new google.visualization.DataTable();
      _.each(setupConfig.element.data('chart').fields,
          function(columnData) {
            data.addColumn(columnData[0], columnData[1]);
      });
      data.addRows(setupConfig.element.data('chart').values);

      var options = {
        hAxis: { title: setupConfig.hAxis },
        vAxis: { format:'#%' },
        colors: ['#1ABC9C']
      };

      var chart = new google.
        visualization.
        LineChart(setupConfig.element.get(0));

      chart.draw(data, options);
    }
  }
};
