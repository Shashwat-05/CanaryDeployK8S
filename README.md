## DOCUMENTATION

**Raw steps as follows**
1. Start minikube single node cluster without checking virtualization technology.   
    `minikube start --driver=virtualbox --no-vtx-check`

2. Install ingress controller, so that later ingress resource can function.   
    `minikube addons enable ingress`

3. Deploy both blue-app & green-app with their services.    
    `kubectl apply -f blue-app-deployment.yaml -f green-app-deploy.yaml`

4. Provision 2 nginx-ingress, Ist one forwards traffic to the blue-app normally but 2nd one follows canary 
strategy and will forword only 25%  traffic to green-app and rest will be forward to blue-app via Ist ingress i.e, remaining 75%.  
 `kubectl apply -f nginx-ingress-controller.yaml`

5. get minikube ip - `minikube ip`

6. curl down the deployed apps 10 times (linix command).  
    `for i in {1..10}; do curl http://<minikube_ip> ; done`

7. registering hostname.   
    `echo 'minikube_ip facets.app'` and now `for i in {1..10}; do curl http://facets.app ; done`