var AWS = require('aws-sdk');
var fs = require('fs');

AWS.config.loadFromPath('/path/to/config.json');

var sqs = new AWS.SQS();

var params = {
  QueueUrl: 'https://sqs.us-west-2.amazonaws.com/xxxxx/your_queue',
  MessageBody: 'Send Message!'
}
sqs.sendMessage(params, function(err, data) {
  if (err)
    console.log(err);
  else
    console.log("Successfully sent.");
})


var params = {
  QueueUrl: 'https://sqs.us-west-2.amazonaws.com/xxxxx/your_queue',
}
sqs.receiveMessage(params, function(err, data) {
  console.log(data);
})
