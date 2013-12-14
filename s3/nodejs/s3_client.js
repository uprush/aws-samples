var AWS = require('aws-sdk');
var fs = require('fs');

AWS.config.loadFromPath('/path/of/your/config.json');

var s3 = new AWS.S3();

var bodyStream = fs.createReadStream( '/path/to/file.txt' );
var params = {
  Bucket: 'your-bucket',
  Key: 'key',
  Body: bodyStream
};

s3.putObject(params, function(err, data) {
  if (err)
    console.log(err);
  else
    console.log("Successfully uploaded.");
});


var params = {
  Bucket: 'your-bucket',
  Key: 'key'
};

s3.getObject(params, function(err, data) {
  if (err)
    console.log(err);
  else
    console.log(data.Body.toString());
});

