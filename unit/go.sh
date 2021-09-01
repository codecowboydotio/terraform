#!/bin/sh

set -x

curl -X POST http://$1:8080/pull -d '{"repo":"https://github.com/codecowboydotio/helloworld-java", "dest":"/www/jsp/", "branch":"main"}'
curl -X PUT http://$1:8888/config -d @a
