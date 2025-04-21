# Cache Infrastructure

This repository contains the infrastructure code for the Cache application, built using Terraform. The infrastructure is designed to be modular, secure, and scalable, supporting multiple environments (dev, staging, and production).

## Architecture Overview

The infrastructure consists of several key components:

- **Network**: Core networking infrastructure including VPC, subnets, and firewall rules
- **GKE**: Google Kubernetes Engine cluster for container orchestration
- **Database**: Managed database services
- **PubSub**: Message queue and event streaming
- **Bastion**: Secure access management
- **Artifact Registry**: Container image storage
- **External Secrets**: Secure secret management
- **IAM**: Identity and access management

## Network Architecture

The network infrastructure is designed with security and scalability in mind:

- **VPC Structure**
  - Private subnets for workloads
  - Public subnets for bastion and load balancers
  - Regional subnets for high availability
  - Network peering for cross-project communication

- **Security**
  - Firewall rules with least privilege access
  - Private GKE cluster with authorized networks
  - Cloud NAT for outbound internet access
  - VPC Service Controls for additional security

## Module Details

### Core Modules

1. **Network Module**
   - VPC creation and configuration
   - Subnet creation with secondary IP ranges
   - Cloud NAT setup
   - Firewall rules management
   - VPC peering configuration

2. **GKE Module**
   - Private cluster setup
   - Node pool configuration
   - Network policy enforcement
   - Workload identity setup
   - Cluster autoscaling

3. **Database Module**
   - Cloud SQL instance creation
   - Database configuration
   - Backup and maintenance setup
   - Private IP configuration
   - Read replicas (optional)

4. **PubSub Module**
   - Topic creation
   - Subscription setup
   - IAM permissions
   - Dead letter topics
   - Message retention policies

5. **Bastion Module**
   - Compute instance creation
   - IAP tunnel configuration
   - OS login integration
   - SSH key management
   - Access logging

6. **Artifact Registry Module**
   - Repository creation
   - IAM permissions
   - Cleanup policies
   - Cross-project access

7. **External Secrets Module**
   - Secret Manager integration
   - Kubernetes secret store setup
   - IAM bindings for secret access
   - Secret rotation configuration
   - Access logging and monitoring

8. **IAM Module**
   - Service account creation
   - Custom role definitions
   - IAM bindings and policies
   - Workload identity federation
   - Permission management

## Directory Structure

```
.
├── environments/          # Environment-specific configurations
│   ├── dev/             # Development environment
│   ├── staging/         # Staging environment
│   └── prod/            # Production environment
└── modules/             # Reusable infrastructure modules
    ├── network/         # Networking components
    │   ├── main.tf     # Main networking resources
    │   ├── variables.tf # Network variables
    │   └── outputs.tf  # Network outputs
    ├── gke/            # Kubernetes cluster
    ├── database/       # Database resources
    ├── pubsub/         # PubSub configuration
    ├── bastion/        # Bastion host setup
    ├── artifact-registry/  # Container registry
    ├── external-secrets/   # Secret management
    └── iam/            # Identity and access management
```

## Prerequisites

- Terraform (version >= 1.0.0)
- Google Cloud SDK
- Appropriate Google Cloud permissions
- kubectl (for Kubernetes management)

## Getting Started

1. Clone this repository
2. Configure your Google Cloud credentials
3. Navigate to the desired environment directory
4. Initialize Terraform:
   ```bash
   terraform init
   ```
5. Review the planned changes:
   ```bash
   terraform plan
   ```
6. Apply the changes:
   ```bash
   terraform apply
   ```

## Environment Management

Each environment (dev, staging, prod) has its own configuration and state. This allows for:
- Independent deployment and management
- Environment-specific resource configurations
- Isolated testing and validation

## Security Considerations

- All environments use secure networking configurations
- Bastion host provides controlled access to resources
- IAM roles follow the principle of least privilege
- Sensitive data is managed through secure methods
- Network policies enforce pod-to-pod communication rules
- Private cluster configuration with authorized networks
- External secrets for secure credential management
- Regular IAM permission audits

## Contributing

1. Create a new branch for your changes
2. Make your modifications
3. Test the changes in a development environment
4. Submit a pull request with a clear description of changes


