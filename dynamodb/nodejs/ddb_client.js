var AWS = require('aws-sdk');
var fs = require('fs');

AWS.config.loadFromPath('/path/of/your/config.json');

var ddb = new AWS.DynamoDB();

var params = {
  TableName: 'my_table',
  Item: {
    'id': {N: '200'},
    'timestamp': {N: '130699342'},
    'message': {S: 'Good Morning'}
  }
};

ddb.putItem(params, function(err, data) {
  if (err)
    console.log(err);
  else
    console.log(data);
});

var params = {
  TableName: 'my_table',
  Key: {
    'id': {N: '200'},
    'timestamp': {N: '130699342'}
  }
};

ddb.getItem(params, function(err, data) {
  if (err)
    console.log(err);
  else
    console.log(data);
});

