## DOCUMENTATION

**kubectl steps as follows**
1. Start minikube single node cluster without checking virtualization technology.   
    `minikube start --driver=virtualbox --no-vtx-check`

2. Install ingress controller, so that later ingress resource can function.   
    `minikube addons enable ingress` - it's better to user minikube's ingress controller, but 
    nginx ingress controller can be installed from helm or manifests itself with some modifications required.

**Alternative step - install nginx-ig-controller with helm**  
````
    # helm repo add nginx-stable https://helm.nginx.com/stable   
    # helm repo update  
    # helm install nginx-ingress nginx-stable/nginx-ingress
````   
then,   
    `kubectl edit svc/nginx-ingress-svc` - add this below clusterIPs block  
    reason - as this svc is loadbalancer type and there won't be any externalIP  
    in a local minikube, therefore providing one manually.

3. Deploy both blue-app & green-app with their services.    
    `kubectl apply -f blue-app-deployment.yaml -f green-app-deploy.yaml`

4. Provision 2 nginx-ingress, Ist one forwards traffic to the blue-app normally but 2nd one follows canary 
strategy and will forword only 25%  traffic to green-app and rest will be forward to blue-app via Ist ingress i.e, remaining 75%.  
 `kubectl apply -f nginx-ingress-controller.yaml`

Note - *if requirement is to split traffic btw more than 2 apps* - use nginx VirtualServer resource instead
    `kubectl apply -f nginx-vserver-lb.yaml`

5. get minikube ip - `minikube ip`

6. curl down the deployed apps 10 times (linix command).  
    `for i in {1..10}; do curl http://<minikube_ip> ; done`

7. registering hostname.   
    `echo 'minikube_ip facets.app'` and now `for i in {1..10}; do curl http://facets.app ; done`


**terraform steps to follow**
1. `terraform init`

2. `terraform apply` - install helm chart separately first, (either comment out all other resource files adn run apply twice)    
as nginx-ingress-controller chart needs to be deployed first else tf will throw erros as virtualserver CRD wont be existing.  
this will do
- deploy all three apps from app.json
- create services for each
- create traffic split with nginx virtualserver
- create ingress-controller,crds,etc with helm.

(provide the minikube_ip manually as external ip to the ingress-controller service)
