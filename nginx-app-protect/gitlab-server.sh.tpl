#!/bin/bash

FILE=/tmp/firstrun.log
if [ ! -e $FILE ]
then
 touch $FILE
 nohup $0 0<&- &>/dev/null &
 exit
fi

exec 1<&-
exec 2<&-
exec 1<>$FILE
exec 2>&1
echo "firstrun debug: starting-config"
logger -p local0.info 'firstrun debug: starting--config'
sudo apt-get update
sudo apt-get install -y curl openssh-server ca-certificates tzdata jq
echo "Install ansible"
sudo apt-get install -y software-properties-common
sudo apt-add-repository -y ppa:ansible/ansible
sudo apt-get update
sudo apt-get install -y ansible
echo "get gitlab repo"
curl https://packages.gitlab.com/install/repositories/gitlab/gitlab-ee/script.deb.sh | sudo bash
GITLAB_IP=$(cat /tmp/gitlab_internal_ip.txt)
NGINX_IP=$(cat /tmp/nginx_internal_ip.txt)
echo $GITLAB_IP
sudo EXTERNAL_URL="http://$GITLAB_IP" GITLAB_ROOT_PASSWORD="password" apt-get install gitlab-ee
sudo gitlab-rails console <<EOF
Feature.enable(:pat_creation_api_for_admin)
EOF
cat << EOF > /etc/ansible/hosts
[f5cs]
localhost
[nginx]
EOF
echo $NGINX_IP >> /etc/ansible/hosts
echo "create token for root"
sudo gitlab-rails runner "token = User.find_by_username('root').personal_access_tokens.create(scopes: [:read_user, :api, :read_api, :sudo, :read_repository, :write_repository], name: 'Automation token'); token.set_token('token-string-here123'); token.save!"
echo "use API to create demo user (uses root token created above)"
curl -X POST   'http://localhost/api/v4/users?private_token=token-string-here123'   -H 'cache-control: no-cache'   -H 'content-type: application/json'   -d '{ "email": "demo@test.com", "username": "demo", "password": "12345678", "name": "testname", "skip_confirmation" : "true" }'
echo
echo "create token for demo user"
sudo gitlab-rails runner "token = User.find_by_username('demo').personal_access_tokens.create(scopes: [:read_user, :api, :read_api, :sudo, :read_repository, :write_repository], name: 'demo token'); token.set_token('demo-token-string123'); token.save!"
echo "create project for demo user"
curl -X POST 'http://localhost/api/v4/projects?private_token=demo-token-string123' -H 'cach-control: no-cache' -H 'content-type: application/json' -d '{ "name": "demo_project", "default_branch": "master", "visibility": "public", "emails_disabled": "true" }'
echo
git clone http://github.com/codecowboydotio/f5cs
git clone http://localhost/demo/demo_project.git
cd demo_project/
cp -p ../f5cs/eap.sh .
cp -p ../f5cs/eap.template .
cp -p ../f5cs/f5cs-dnslb.yml .
cp -p ../f5cs/update_blocking.sh .
cp -p /tmp/.gitlab-ci.yml .
git add eap.sh eap.template f5cs-dnslb.yml update_blocking.sh .gitlab-ci.yml
git commit -a -m "initial commit"
git push http://demo:12345678@localhost/demo/demo_project
curl -L https://packages.gitlab.com/install/repositories/runner/gitlab-runner/script.deb.sh | sudo bash
export GITLAB_RUNNER_DISABLE_SKEL=true; sudo -E apt-get install gitlab-runner
RUNNER_REG_TOKEN=$(gitlab-rails runner -e production "puts Gitlab::CurrentSettings.current_application_settings.runners_registration_token")
gitlab-runner register --non-interactive --url http://127.0.0.1/ --run-untagged --executor shell  --registration-token $RUNNER_REG_TOKEN
ansible-galaxy collection install f5devcentral.cloudservices
cd /f5cs
export pass="Qwerty123;"
ansible-playbook f5cs-dnslb.yml -e "ansible_user=s.vankalken@f5.com ansible_httpapi_password=$pass zone_name=svkcode.org  run_type=delete debug=true" 
endpoint_ip=$(cat /tmp/nginx_external_ip.txt)
echo $endpoint_ip
ansible-playbook /f5cs/f5cs-dnslb.yml -e "ansible_user=s.vankalken@f5.com ansible_httpapi_password=$pass zone_name=svkcode.org endpoint_name=server1 lbr_name=www endpoint_ip=$endpoint_ip pool_name=pool1  run_type=create debug=true"
#ansible-playbook /f5cs/f5cs-dnslb.yml -e "ansible_user=s.vankalken@f5.com ansible_httpapi_password=$pass zone_name=svkcode.org endpoint_name=server1 lbr_name=www endpoint_ip=$endpoint_ip pool_name=pool1  run_type=create debug=true"

echo "firstrun debug: finished-config"
logger -p local0.info 'firstrun debug: finished-config'
