#!/usr/bin/env bash


test_http() {
  # Check that status is 302 REDIRECT
  status_code=$(curl -k -s -o /dev/null -w %{http_code} https://localhost 2> /dev/null)

  if [[ $status_code == "302" ]]
  then
      echo "Pass: status code is ${status_code}";
  else
      echo "Fail: status code is ${status_code}";
  fi

}

test_local_dev() {
  # find and replace 'easier' with 'harder' in the content line to simulate local development
  sed -i.bak '/content/s/easier/harder/' app/src/server.py
  # wait a sec for reload
  sleep 1
  response=$(curl -k https://localhost/ 2> /dev/null)
  content=$(echo "$response" | grep "It's harder to ask forgiveness than it is to get permission.")
  if [[ "$content" != "" ]]
  then
    echo "Pass: found \"It's harder to ask forgiveness than it is to get permission.\" in response"
  else
    echo "Fail: \"It's harder to ask forgiveness than it is to get permission.\" missing from response"
  fi
  mv app/src/server.py.bak app/src/server.py
}

function usage {
  echo "$ME: validates functionality of the current setup"
  echo "usage: $ME [-s] [DIR]"
  echo "  -s : skip SSL test"
  echo "  DIR : directory to cd into to test"
  echo ""
  echo "REALLY IMPORTANT: This script will remove the containers and images built by compose!"
  exit 0
}

ME=`basename $0`
TEST_SSL="yes"

while getopts ":sh" option
do
  case $option in
    s) TEST_SSL="no";;
    h) usage;;
  esac
done
shift $(($OPTIND - 1))

if [ -d "$1" ]
then
  cd $1
fi

# Start with clean environment
docker-compose rm -f -s 2> /dev/null
docker-compose up --build -d 2> /dev/null
echo "------------------------------------------------------------------------"
echo "| Testing SSL/TLS settings...                                          |"
echo "------------------------------------------------------------------------"
if [ "$TEST_SSL" == "yes" ]
then
  docker run -ti --rm --network="host" drwetter/testssl.sh \
        --parallel --quiet --std --protocols --headers https://localhost
else
  echo "SSL Tests skipped"
fi
echo "------------------------------------------------------------------------"
echo "| Testing HTTP header and body content...                              |"
echo "------------------------------------------------------------------------"
test_http
echo "------------------------------------------------------------------------"
echo "| Docker image sizes:                                                  |"
echo "------------------------------------------------------------------------"
docker images containerize_app --format "{{.Repository}}:{{.Tag}} {{.Size}}"
docker images containerize_nginx --format "{{.Repository}}:{{.Tag}} {{.Size}}"


# Clean up environment when done
docker-compose rm -f -s  2> /dev/null
docker-compose down --rmi all 2> /dev/null

