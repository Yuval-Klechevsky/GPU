# HOMEWORK PROJECT GPU

Hello every one this is a project about the GPU world and the Openshift, before we start let me explain to you about this.

### WHAT IS GPU?

A graphics processing unit (GPU) is a computer chip that renders graphics and images by performing rapid mathematical calculations.
GPUs are used for both professional and personal computing. Traditionally, GPUs are responsible for the rendering of 2D and 3D images, animations and video -- even though, now, they have a wider use range.

GPUs can perform parallel operations on multiple sets of data, they are also commonly used for non-graphical tasks such as machine learning and scientific computation.

### WHAT IS OPENSHIFT?

OpenShift is a layered system designed to expose underlying Docker-formatted container image and Kubernetes concepts as accurately as possible, with a focus on easy composition of applications by a developer.

### Before YOU START

You need to do some actions:

1. You need to download from the Openshift console the right oc package.

2. Export your oc like this: export PATH="$HOME/oc:$PATH"   

3. Also you need to download from the Openshift console the right helm package.

4. Export your helm like this: export PATH="$HOME/helm:$PATH"  

### TASKS: 

1. Install the NVIDIA GPU Operator (22.9.1). (nvidia-operator)

2. Deploy inference workload using the following image: gcr.io/run-ai-demo/quickstart, create an Helm chart to run the Deployment. (runai)

3. Use OpenShift’s Prom Stack to populate a basic GPU utilization dashboard. (prom-stack)

4. Create a resource allocation automation for OpenShift:    
Accept namespace, cpu & memory and edit the ResourceQuota.      (resource-quota)
Write in Bash/Python/Ansible.                                   

