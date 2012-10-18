yam.connect.embedFeed({
  container: '#yammer-feed',
  feedType: 'open-graph',
  network: $('meta[name=network_id]').attr('content'),
  objectProperties: {
    url: $("[property='og:url']").attr('content'),
    type:  $("[property='og:type']").attr('content')
  }
});
