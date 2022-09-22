# SaaSGlue Kubernetes Job Runner
SaaSGlue is a powerful and versatile Scheduling and Automation service that can be used among other things to schedule and run jobs in Kubernetes. This repo includes code and artifacts to schedule and run two containerized python applications as Kubernetes jobs using SaaSGlue.
<br />

## Prerequisites
- Docker
- Kubernetes
- Helm

## Install
1. Clone this git repo.
  ```
  git clone https://github.com/saascipes/kubernetes-job-runner.git
  ```
2. Change directories to the kubernetes-job-runner folder.
3. Build the Kubernetes Job Runner Docker image. This image hosts the SaaSGlue Agent which will start the Kubernetes jobs for the two applications.
  ```
  ./bin/build_agent_docker_image.sh
  ```
4. Build the python application Docker images.
  ```
  ./bin/build_sample_app_1_docker_image.sh
  ```
  ```
  ./bin/build_sample_app_2_docker_image.sh
  ```
5. [Install the SaaSGlue Agent](#install-the-saasglue-agent) in Kubernetes.
6. Import the "Kubernetes Job Runner" job to SaaSGlue and enable the schedules to run the python applications.
- Log in to the SaaSGlue web [console](https://console.saasglue.com).
- Click "Designer" in the menu bar.
- Click "Import Jobs".
- Click "Choose File".
- Select the "kubernetes_job_runner.sgj" file in the kubernetes-job-runner root folder and click "Open".
- Click "Import Jobs".
- You should see the message "Successfully imported the jobs file to your team!" followed by detailed results. Click "Close".
- Click the job name "Kubernetes Job Runner" to view the job details.

## Usage
There are two schedules defined in the "Kubernetes Job Runner" job - one for each python application. The schedules are deactivated by default. To activate the schedules and monitor the running jobs:
- Log in to the SaaSGlue web console.
- Click "Designer" in the menu bar.
- Click "Kubernetes Job Runner".
- Click the "Schedules" tab.
- Click the "Is Active" checkbox to activate/inactivate the two schedules.
- The two schedules are configured to run the python applications once per minute. See the [Documentation](https://saasglue.com/docs#job-schedule) for other scheduling options. Each schedule has a Runtime Variables property which is a yaml formatted map of parameters used to create the Kubernetes Job. The following parameters are available:

  - image_name: the name of the docker image (required)
  - command: array of command line arguments (optional)
  - service_account_name: the service account to use (optional)
  - image_pull_policy: the image pull policy (defaults to IfNotPresent)
  - env_vars: array of environment variables to mount in the pod (optional)<br/>
  ```
    - env_name: MY_ENV_NAME
      env_value: value
  ```
  - secrets: array of secrets to mount as environment variables in the pod (optional)<br/>
  ```
    - env_name: MY_SECRET_VAL
      secret_name: secret-name
      secret_key: secret-key
  ```
  - volume_claims: array of volumes/claims (optional)<br/>
  ```
  - name: my-volume
    mountpath: /usr/myapp/data
    claim: myapp-data
  - name: my-host-volume
    mountpath: /usr/myapp/localdata
    hostPath:
    - path: /Users/bullwinkle/dev/myapp
  ```
  - affinities: array of affinities (optional)<br/>
  ```
  - key: node-group-name
    operator: In
    values: [apps]
  ```
  - tolerations: array of tolerations (optional)<br/>
  ```
  - effect: NoSchedule
    key: node-group-name
    operator: Equal
    value: apps
  ```
  - labels: map of labels (optional)<br/>
  ```
  jobgroup: my-apps
  appType: myapp
  ```
  - config_maps: array of config maps to mount in pod (optional)

- Click the "Monitor" tab in the SaaSGlue console. When jobs start you will see them in the Monitor. To view job results click the "Monitor [job instance number]" link next to the job name. This will show log messages related to starting the Kubernetes job.
- The python applications write messages to stdout and sleep for 60 seconds before shutting down.
  - To view running jobs:
    ```
    kubectl get job | grep "sample-app"
    ```
  - To view stdout while the jobs are running: 
    ```
    ./bin/view_sample_app_1_logs.sh
    ```
    for sample app 1 or:
    ```
    ./bin/view_sample_app_2_logs.sh
    ```
    for sample app 2.

## Install the SaaSGlue Agent
1. If you don't already have a SaaSGlue account, sign up for a free account at https://console.saasglue.com.

2. Get SaaSGlue Agent credentials (access key id and secret).
- Log in to the SaasGlue web [console](https://console.saasglue.com).
- Click your login name in the upper right hand corner and click "Access Keys".
- Click the "Agent Access Keys" tab.
- Click "Create Agent Access Key".
- Enter a description, e.g. "default".
- Click "Create Access Key".
- Copy the access key secret.
- Click the "I have copied the secret" button.
- Copy the access key id from the grid.
3. Add the SaaSGlue Helm repo.
  ```
  helm repo add saasglue https://saasglue.github.io/helm-charts/
  ```
4. Install the SaaSGlue Agent chart substituting the agent access key id and secret obtained in step 2 for the placeholders in the following command.
  ```
  helm install sg-kubernetes-job-runner --set accessKeyId=[access key id] --set accessKeySecret=[access key secret] --set tags=role=kubernetes_job_runner ./deploy/kubernetes/helm/agent
  ```
5. You should now see an Agent named "sg-kubernetes-job-runner-agent" in the SaaSGlue console Dashboard and Agents tab.
