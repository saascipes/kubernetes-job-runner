# SaaSGlue Kubernetes Job Runner
SaaSGlue is a powerful and versatile Scheduling and Automation service that can be used among other things to schedule and run jobs in Kubernetes. This repo includes code and artifacts to schedule and run two sample applications as Kubernetes jobs using SaaSGlue.
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
3. Build the Kubernetes Job Runner Docker image. This image hosts the SaaSGlue Agent which will start the Kubernetes jobs for the two sample applications.
  ```
  ./bin/build_agent_docker_image.sh
  ```
4. Build the Sample Application Docker images.
  ```
  ./bin/build_sample_app_1_docker_image.sh
  ```
  ```
  ./bin/build_sample_app_2_docker_image.sh
  ```
5. [Install the SaaSGlue Agent](#install-the-saasglue-agent) in Kubernetes.
6. Import the "Kubernetes Job Runner" job to SaaSGlue and enable the schedules to run the Sample Applications.
- Log in to the SaaSGlue web [console](https://console.saasglue.com).
- Click "Designer" in the menu bar.
- Click "Import Jobs".
- Click "Choose File".
- Select the "kubernetes_job_runner.sgj" file in the kubernetes-job-runner root folder and click "Open".
- Click "Import Jobs".
- You should see the message "Successfully imported the jobs file to your team!" followed by detailed results. Click "Close".
- Click the job name "Kubernetes Job Runner" to view the job details.
- Click the "Schedules" tab.
- Click the "Is Active" checkbox to activate/inactivate the two schedules.
- The two schedules are configured to run the sample applications once per minute. See the [Documentation](https://saasglue.com/docs#job-schedule) for other scheduling options.
7. Monitor the running jobs.
- Click the "Monitor" tab in the SaaSGlue console. To view job results click the "Monitor [job instance number]" link next to the job name.
- View stdout for running Kubernetes job. The sample applications write messages to stdout and sleep for 60 seconds.
  - To view the running jobs:
    ```
    kubectl get job | grep "sample-app"
    ```
  - To view the stdout while the jobs are running: 
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
