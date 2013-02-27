//=require votes

describe ('vote callback', function(){

  beforeEach(function(){
    loadFixtures('vote.html');
    vote_element = $('.vote').get(0)
    vote_data = {vote: {id: 1}}
    Scheddo.voteCallback.call(vote_element, vote_data)
  })

  it ('sets the data-role to delete', function(){
    expect($('.vote').data("role")).toEqual("delete")
  });

  it ('sets the action to /votes/:vote_id', function(){
    expect($('.vote').attr("action")).toEqual("/votes/1")
  });

  it ('appends the delete element', function(){
    expect($('.vote input[value=delete]').length).toEqual(1)
  });

  it ('changes the input class to unvote when you mouse out', function(){
    $('.vote input').mouseout()
    expect($('.vote input').hasClass("unvote")).toEqual(true)
  });

  it ('increments the vote count by 1', function(){
    expect(parseInt($('.vote-count[data-id=1]').text())).toEqual(1)
  });
});

describe ('unvote callback', function(){

  beforeEach(function(){
    loadFixtures('unvote.html');
    vote_element = $('.vote').get(0)
    vote_data = {vote: {id: 1}}
    Scheddo.unvoteCallback.call(vote_element, vote_data)
  })

  it ('sets the data-role to create', function(){
    expect($('.vote').data("role")).toEqual("create")
  });

  it ('sets the action to /votes', function(){
    expect($('.vote').attr("action")).toEqual("/votes")
  });

  it ('removes the delete element', function(){
    expect($('#edit_vote_1 input[value=delete]').length).toEqual(0)
  });

  it ('changes the input class to vote when you mouse out', function(){
    $('#test .vote input').mouseout()
    expect($('.vote input').hasClass("vote")).toEqual(true)
  });

  it ('decrements the vote count by 1', function(){
    expect(parseInt($('.vote-count[data-id=1]').text())).toEqual(0)
  });
});

describe ('error callback', function(){

  beforeEach(function(){
    loadFixtures('vote_error.html');
    vote_element = $('.vote').get(0)
    vote_data = {statusText: "Internal Server Error"}
    Scheddo.voteErrorCallback.call(vote_element, vote_data)
  })

  it ('displays an flash error', function(){
    expect($('.flash #flash-error').text()).toEqual("Internal Server Error")
  });
});
