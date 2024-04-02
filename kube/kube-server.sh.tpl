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
useradd -m student -s /bin/bash
echo "student:password" > userlist
chpasswd < userlist
echo "sudo su - " >> /home/student/.profile
sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config
systemctl restart sshd
echo "student ALL=(ALL) NOPASSWD:ALL" | sudo tee -a /etc/sudoers
##snap install microk8s --classic
#snap install microk8s --classic --channel=1.19/stable
#microk8s start
#microk8s status
#microk8s enable dashboard dns registry ingress
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
chmod 755 kubectl
mv kubectl /usr/bin
#microk8s config > /root/kubeconfig
cd /root/
mkdir /root/.kube
cp /root/kubeconfig /root/.kube/config
cat << EOF > /root/swapi.yaml
---
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: swapi-ingress
spec:
  rules:
  - http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: swapi-svc
            port:
              number: 80
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: svk-swapi-api
  labels:
    app: svk-swapi
spec:
  replicas: 2
  selector:
    matchLabels:
      app: svk-swapi
  template:
    metadata:
      labels:
        app: svk-swapi
    spec:
      containers:
      - image: public.ecr.aws/y6q2t0j9/demos:swapi-api
        imagePullPolicy: IfNotPresent
        name: svk-swapi
        ports:
          - containerPort: 3000
---
apiVersion: v1
kind: Service
metadata:
  name: swapi-svc
  labels:
    app: svk-swapi
spec:
  selector:
    app: svk-swapi
  ports:
  - name: port
    port: 80
    targetPort: 3000
EOF

cat << EOF > /root/app2.yaml
---
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: app2-ingress
spec:
  rules:
  - http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: app2-svc
            port:
              number: 80
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: svk-app2
  labels:
    app: svk-app2
spec:
  replicas: 2
  selector:
    matchLabels:
      app: svk-app2
  template:
    metadata:
      labels:
        app: svk-app2
    spec:
      containers:
      - image: public.ecr.aws/j7y3o1g8/demo
        imagePullPolicy: IfNotPresent
        name: svk-app2
        ports:
          - containerPort: 80
---
apiVersion: v1
kind: Service
metadata:
  name: app2-svc
  labels:
    app: svk-app2
spec:
  selector:
    app: svk-app2
  ports:
  - name: port
    port: 80
    targetPort: 80
EOF
cat << EOF > /root/commands.txt
This file represents a list of commands to be used in conjunction with the slides 


kubectl get nodes

kubectl describe nodes | more

kubectl apply -f swapi.yaml

kubectl get pods

kubectl get all

cat swapi.yaml

kubectl get pods

kubectl delete pod <insert pod name>

kubectl get pods

curl http://httpbin.org/ip

kubectl delete -f swapi.yaml

kubectl get all

kubectl apply -f app2.yaml

kubectl get all


curl http://httpbin.org/ip

EOF

curl -LO https://storage.googleapis.com/minikube/releases/v1.23.2/minikube-linux-amd64
sudo install minikube-linux-amd64 /usr/local/bin/minikube
sudo apt install apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable"
sudo apt install -y docker-ce
usermod -aG docker student
usermod -aG docker ubuntu
sudo systemctl start docker
sudo su - ubuntu -c "minikube start"

curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
chmod 700 get_helm.sh
./get_helm.sh

#kubectl apply -f /root/swapi.yaml
echo "done"
