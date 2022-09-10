# SaaSGlue Kubernetes Job Runner
SaaSGlue is a powerful and versatile Scheduling and Automation service that can be used among other things to schedule jobs in Kubernetes. This repo includes code and artifacts required to run two sample applications as scheduled jobs in Kubernetes with SaaSGlue.
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
2. Change directories to the kubernetes-job-runner repo folder.
3. Build the Docker images.
  - The Kubernetes Job Runner image. This image runs the SaaSGlue Agent which will start the sample application jobs.
  ```
  ./bin/build_agent_docker_image.sh
  ```
  - The Sample Application images.
  ```
  ./bin/build_sample_app_1_docker_image.sh
  ```
  ```
  ./bin/build_sample_app_2_docker_image.sh
  ```
4. [Install the SaaSGlue Agent](#install-the-saasglue-agent) in Kubernetes.
5. Import the "Kubernetes Job Runner" job to SaaSGlue.
- Log in to the SaaSGlue web [console](https://console.saasglue.com).
- Click "Designer" in the menu bar.
- Click "Import Jobs".
- Click "Choose File".
- Select the "kubernetes_job_runner.sgj" file in the kubernetes-job-runner root folder and click "Open".
- Click "Import Jobs".
- You should see the message "Successfully imported the jobs file to your team!" .followed by detailed results. Click "Close".
- Click the job name "Kubernetes Job Runner" to view the job details.
- Click the "Schedules" tab.
- Click the "Is Active" checkbox to activate/inactivate the two schedules.
- The two schedules are configured to run the sample applications once per minute. See the [Documentation](#https://saasglue.com/docs#job-schedule) for other scheduling options.

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
