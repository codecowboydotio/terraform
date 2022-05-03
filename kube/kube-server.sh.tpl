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
useradd student
echo "student:password" > userlist
chpasswd < userlist
sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config
systemctl restart sshd
echo "student ALL=(ALL) NOPASSWD:ALL" | sudo tee -a /etc/sudoers
snap install microk8s --classic
microk8s start
microk8s status
microk8s enable dashboard dns registry ingress
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
chmod 755 kubectl
mv kubectl /usr/bin
microk8s config > /root/kubeconfig
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
echo "done"
