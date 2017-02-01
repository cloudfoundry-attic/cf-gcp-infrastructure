# DEPRECATION WARNING: This repo is deprecated in favor of [`bbl`](https://github.com/cloudfoundry/bosh-bootloader).


Original README below

---

# How Does One Use This?
This document discusses the creation of a GCP environment suitable for deploying Cloud Foundry, starting from the beginning. To use it, you will be creating an environment-specific working directory, copying and creating some necessary files there, running `terraform`, and saving the resulting files. It's worth noting up-front that there are two private, stateful files that _must be saved_ in order to retain the ability to manage the resulting GCP environment with terraform: `terraform.tfvars` and `terraform.state`. You can save these files however you like - something as simple as making the working directory a private git repository and pushing it somewhere safe will work. If you prefer, you can skip the steps under **Create a Working Directory** and use the workspace of this repository, but you'll want to persist your two stateful/private files somewhere else, as they are `.gitignore`d here.

## Prerequisites
1. You'll need the `gcloud` cli installed.
1. You'll also need `terraform` v0.7.7 or higher. You can install them on a machine managed with homebrew thusly:

   ```bash
   brew install Caskroom/cask/google-cloud-sdk
   brew install terraform
   ```
   
1. You'll need to make sure your GCP quotas are large enough. You can request a quota increase and ask for the following increases:
  - 100 CPUs
  - 50 In-use IP addresses
1. Clone the cf-deployment repository
  
   ```
   git clone git@github.com:cloudfoundry/cf-deployment.git
   ```
   
1. Acquire the alpha [BOSH CLI](https://github.com/cloudfoundry/bosh-cli).  The old (Ruby-gem) `BOSH CLI` lacks several features required to use `cf-deployment`.

## Setup Account and Keys
If you don't already have a GCP [service account](https://cloud.google.com/iam/docs/service-accounts), create one:

```bash
gcloud iam service-accounts create some-account-name
```

You'll need a service account key to allow terraform to deploy resources. To create a new one:

```
gcloud iam service-accounts keys create "terraform.key.json" --iam-account "some-account-name@yourproject.iam.gserviceaccount.com"
gcloud projects add-iam-policy-binding PROJECT_ID --member 'serviceAccount:some-account-name@PROJECT_ID.iam.gserviceaccount.com' --role 'roles/editor'
```

Optionally, you may setup a "project-wide" SSH key to allow SSH access to the VMs in your deployment. You can follow [these directions](https://cloud.google.com/compute/docs/instances/adding-removing-ssh-keys#sshkeys) to set up a key.

## Enable Google Cloud APIs
- Enable the [Google Cloud Resource Manager API] (https://console.developers.google.com/apis/api/cloudresourcemanager.googleapis.com/) on your GCP account.  The Google Cloud Resource Manager API provides methods for creating, reading, and updating project metadata.
- Enable the [Google Cloud DNS API] (https://console.developers.google.com/apis/api/dns/overview) on your GCP account. The Google Cloud DNS API provides methods for creating, reading, and updating project DNS entries.

## Copy Terraform Files
Put a copy of the terraform templates in your environment-specific working directory:

```
mv *.tf ../env-dir
```

## Write Var File
Copy the stub content below into a file called `terraform.tfvars` and put it in the root of your environment-specific working directory. These vars will be used when you run `terraform  apply`. You should fill in the stub values with the correct content. The values you should use are described further below.

```hcl
env_name = "some-envrionment-name"
region = "us-central1"
zones = ["us-central1-a", "us-central1-b", "us-central1-c"] //The count must be 3
project = "your-gcp-project"
dns_suffix = "gcp.some-project.cf-app.com"
ssl_cert = "-----BEGIN CERTIFICATE-----some cert-----END CERTIFICATE-----\n"
ssl_cert_private_key = "-----BEGIN RSA PRIVATE KEY-----some cert private key-----END RSA PRIVATE KEY-----\n"
service_account_key = <<SERVICE_ACCOUNT_KEY
{
  "type": "service_account",
  "project_id": "your-gcp-project",
  "private_key_id": "another-gcp-private-key",
  "private_key": "-----BEGIN PRIVATE KEY-----another gcp private key-----END PRIVATE KEY-----\n",
  "client_email": "something@example.com",
  "client_id": "11111111111111",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://accounts.google.com/o/oauth2/token",
  "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/"
} SERVICE_ACCOUNT_KEY
```

### Var Details
- project: ID for your GCP project
- env_name: An arbitrary unique name for namespacing resources
- region: Region in which to create resources (e.g. us-central1)
- zones: Zones in which to create resources. Must be within the given region. (e.g. [us-central1-a, us-central1-b, us-central1-c])
- project: ID for your GCP project
- dns_suffix: Base domain name for DNS record creation. This domain will be extended with the name of your GCP project. So, if your GCP project is called "my-cf", then terraform will add DNS records for my-cf.<dns_suffix>.
- ssl_cert: SSL certificate for HTTP load balancer configuration. Can be either trusted or self-signed. The common name for the cert should match your DNS suffix.
- ssl_cert_private_key:  Private key for above SSL certificate.
- service_account_key: Contents of your service account key file generated using the `gcloud iam service-accounts keys create` command.

All of these vars are **required**. This file **needs to be saved**. It allows terraform to create and manage resources on GCP.

## Stand Up the Environment
From your working directory, run:

```bash
terraform apply
```
This step will generate a `terraform.state` file, **which needs to be saved**. It allows terraform to track and manage the resources it's created on GCP. This can be placed in a private repository, trusted to a credential management service, or privately and safely stored otherwise. After this step, you can deploy something to your new GCP environment! [`cf-deployment`](https://github.com/cloudfoundry/cf-deployment), for example.

## Bosh Setup
1. Update DNS in Route 53 to contain the Name Servers created by terraform
1. Generate ssh key for director manifest and add to GCP

   ```bash
   ssh-keygen -t rsa -f /PATH/TO/DIRECTOR/SSH_KEY -C vcap  -N ""
   paste -d: <(echo vcap) /PATH/TO/DIRECTOR/SSH_KEY.pub > /PATH/TO/DIRECTOR/SSH_KEY.gcp_pub
   gcloud auth activate-service-account --key-file /PATH/TO/GOOGLE_AUTH_JSON
   gcloud config set project PROJECT_ID
   gcloud config set compute/region REGION
   gcloud config set compute/zone ZONE
   gcloud compute project-info add-metadata --metadata-from-file sshKeys=/PATH/TO/DIRECTOR/SSH_KEY.gcp_pub
   ```
   
1. Generate director certificate

   ```bash
   cf-gcp-infrastructure/deployments/generate-certs.sh director DIRECTOR_IP bosh.ENV_NAME.cf-app.com /TARGET_DIRECTORY/FOR/CERTS
   ```

1. Generate `bosh-deployment-vars.yml` file containing the following keys:

   ```bash
   project: PROJECT_ID
   zone: ZONE
   env_name: ENV_NAME
   director_ip: DIRECTOR_IP
   nats_password: SOME_PASSWORD
   postgres_password: SOME_PASSWORD
   blobstore_director_password: SOME_PASSWORD
   blobstore_agent_password: SOME_PASSWORD
   hm_password:  SOME_PASSWORD
   mbus_password: SOME_PASSWORD
   director_cert: contents of /TARGET_DIRECTORY/FOR/CERTS/director.crt
   director_key: contents of /TARGET_DIRECTORY/FOR/CERTS/director.key
   google_cpi_json_key: stringified GOOGLE_AUTH_JSON content
   director_username: BOSH_USERNAME
   director_password: BOSH_PASSWORD
   director_ssh_key_path: /PATH/TO/DIRECTOR/SSH_KEY
   ```
   
1. Deploy bosh.

   ```bash
   bosh interpolate -l bosh-deployment-vars.yml --var-errs cf-gcp-infrastructure/bosh/bosh.yml > /dev/null
   bosh create-env -l bosh-deployment-vars.yml cf-gcp-infrastructure/bosh/bosh.yml
   ```
   
1. Save the `bosh-state.json` file now located at `cf-gcp-infrastructure/bosh/bosh-state.json`
1. Upload cloud config

   ```
   export BOSH_USER=BOSH_USERNAME
   export BOSH_PASSWORD=BOSH_PASSWORD
   export BOSH_ENVIRONMENT=DIRECTOR_IP
   export BOSH_CA_CERT=/TARGET_DIRECTORY/FOR/CERTS/rootCA.pem

   bosh log-in
   bosh -n update-cloud-config \
     -l bosh-deployment-vars.yml \
     deployments/cloud-config.yml
   ```
   
1. Save the `bosh-deployment-vars.yml` file somewhere safe.  You will need to reuse it if you want to update your bosh deployment without rotating credentials.

## Tearing down environment
If you wish to tear down your environment, run:

```bash
terraform destroy
```

Note that this may not work if there are any VMs deployed; you will need to destroy such VMs by alternative means.
