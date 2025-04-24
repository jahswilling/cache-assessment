# ELK Stack Module

This module sets up an ELK (Elasticsearch, Logstash, Kibana) stack using Docker Compose on a GCP VM.

## Prerequisites

- Google Cloud Platform account with appropriate permissions
- SSH key pair for VM access
- Terraform installed locally

## VM Specifications

The module creates a VM with the following specifications:
- Machine Type: e2-standard-2 (2 vCPUs, 8 GB Memory)
- OS: Ubuntu 22.04 LTS
- Boot Disk: 50 GB
- Public IP address for access

## Usage

1. Initialize the module:
```hcl
module "elk_stack" {
  source = "./modules/elk-stack"
  
  # VM Configuration
  vm_name         = "elk-stack-vm"
  zone            = "us-central1-a"  # Change to your preferred zone
  network         = "default"        # Change to your network name
  ssh_user        = "ubuntu"
  ssh_pub_key_path = "~/.ssh/id_rsa.pub"  # Path to your SSH public key
  
  # ELK Configuration
  elasticsearch_username = "elastic"
  elasticsearch_password = "your-secure-password"
}
```

2. Apply the configuration:
```bash
terraform init
terraform apply
```

## Accessing the Services

After applying the configuration, you'll get the following outputs:
- VM IP address
- Kibana URL
- Elasticsearch URL

Access the services using:
- Kibana UI: http://vm-ip:5601
- Elasticsearch API: http://vm-ip:9200
- Logstash: http://vm-ip:5044 (Beats input)

## VM Setup Details

The VM is automatically configured with:
- Docker and Docker Compose
- Terraform
- Required ports opened in firewall
- User added to docker group
- SSH access configured

## Configuring Kubernetes to Forward Logs

To forward logs from your Kubernetes cluster to this ELK stack, follow these steps:

1. Install Filebeat as a DaemonSet in your Kubernetes cluster:

```yaml
apiVersion: apps/v1
kind: DaemonSet
metadata:
  name: filebeat
  namespace: kube-system
spec:
  selector:
    matchLabels:
      app: filebeat
  template:
    metadata:
      labels:
        app: filebeat
    spec:
      containers:
      - name: filebeat
        image: docker.elastic.co/beats/filebeat:8.12.1
        args: [
          "-c", "/etc/filebeat.yml",
          "-e"
        ]
        env:
        - name: ELASTICSEARCH_HOST
          value: "your-vm-ip"  # Use the VM IP from terraform output
        - name: ELASTICSEARCH_PORT
          value: "9200"
        - name: ELASTICSEARCH_USERNAME
          value: "elastic"
        - name: ELASTICSEARCH_PASSWORD
          valueFrom:
            secretKeyRef:
              name: elasticsearch-password
              key: password
        volumeMounts:
        - name: filebeat-config
          mountPath: /etc/filebeat.yml
          subPath: filebeat.yml
        - name: varlibdockercontainers
          mountPath: /var/lib/docker/containers
          readOnly: true
        - name: varlog
          mountPath: /var/log
          readOnly: true
      volumes:
      - name: filebeat-config
        configMap:
          name: filebeat-config
      - name: varlibdockercontainers
        hostPath:
          path: /var/lib/docker/containers
      - name: varlog
        hostPath:
          path: /var/log
```

2. Create the Filebeat configuration ConfigMap:

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: filebeat-config
  namespace: kube-system
data:
  filebeat.yml: |
    filebeat.inputs:
    - type: container
      paths:
        - /var/lib/docker/containers/*/*.log
      processors:
        - add_kubernetes_metadata:
            host: ${NODE_NAME}
            matchers:
            - logs_path:
                logs_path: "/var/lib/docker/containers/"

    output.logstash:
      hosts: ["your-vm-ip:5044"]  # Use the VM IP from terraform output
```

3. Create a secret for Elasticsearch credentials:

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: elasticsearch-password
  namespace: kube-system
type: Opaque
data:
  password: base64-encoded-password
```

4. Apply these configurations to your cluster:

```bash
kubectl apply -f filebeat-daemonset.yaml
kubectl apply -f filebeat-configmap.yaml
kubectl apply -f elasticsearch-secret.yaml
```

## Viewing Logs in Kibana

1. Access Kibana using the URL from terraform output
2. Log in with your Elasticsearch credentials
3. Go to "Discover" section
4. Create an index pattern for "kubernetes-*"
5. You can now view and analyze your Kubernetes logs

## Security Considerations

1. Change the default Elasticsearch password
2. Consider setting up SSL/TLS for secure communication
3. Restrict access to the VM's ports using firewall rules
4. Use network policies in Kubernetes to restrict Filebeat access
5. Consider using a more restrictive source range for firewall rules
6. Regularly update the VM's OS and Docker components

## Troubleshooting

1. Check VM status:
```bash
gcloud compute instances describe elk-stack-vm --zone=us-central1-a
```

2. Check container logs:
```bash
gcloud compute ssh elk-stack-vm --zone=us-central1-a --command="docker logs elasticsearch"
gcloud compute ssh elk-stack-vm --zone=us-central1-a --command="docker logs logstash"
gcloud compute ssh elk-stack-vm --zone=us-central1-a --command="docker logs kibana"
```

3. Verify Elasticsearch is running:
```bash
gcloud compute ssh elk-stack-vm --zone=us-central1-a --command="curl -u elastic:your-password http://localhost:9200"
```

4. Check Filebeat logs in Kubernetes:
```bash
kubectl logs -n kube-system -l app=filebeat
``` 