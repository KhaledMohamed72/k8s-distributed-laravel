# Kubernetes Distributed Laravel Application

This repository provides a complete Kubernetes setup for deploying a distributed Laravel application using Kustomize. The application includes a Laravel web application served via Nginx, a MySQL database, Redis for caching and sessions, and background workers for processing queues. It supports multiple environments (development and production) through overlays.

## Architecture

The application is structured using Kustomize for configuration management:

- **Laravel App**: Web application containerized with Nginx as a reverse proxy, including health checks and resource limits.
- **Laravel Worker**: Background job processor for handling queued tasks.
- **MySQL**: Persistent database storage using StatefulSet and Persistent Volumes.
- **Redis**: In-memory data store for caching and sessions.
- **RBAC**: Role-based access control for Kubernetes resources.
- **Storage**: Custom storage class for persistent data retention.

### Components

- `base/`: Base Kubernetes manifests for all environments.
- `overlays/dev/`: Development environment configuration.
- `overlays/prod/`: Production environment with patches for higher replicas and storage.

## Prerequisites

- Kubernetes cluster (v1.19+)
- `kubectl` configured to access your cluster
- `kustomize` (or `kubectl` with Kustomize support)
- Docker registry access for Laravel images
- Sealed Secrets or similar for managing secrets (referenced in `.gitignore`)

## Deployment

### Development Environment

1. Ensure you have access to your Kubernetes cluster.
2. Apply the development overlay:

   ```bash
   kubectl apply -k overlays/dev/
   ```

3. Verify the deployment:

   ```bash
   kubectl get pods -l app=laravel
   kubectl get pvc
   ```

### Production Environment

1. Apply the production overlay with patches:

   ```bash
   kubectl apply -k overlays/prod/
   ```

2. The production overlay includes:
   - Increased replicas for the Laravel app
   - Larger persistent volume claims

### Customizing Deployments

- Edit the base manifests in `base/` for common changes.
- Use patches in `overlays/prod/` for environment-specific modifications.
- Update image tags in `base/laravel/laravel-deployment.yaml` for new releases.

## Configuration

### Secrets

Sensitive data (database credentials, app keys) are managed via Kubernetes secrets. The `.gitignore` file excludes secret files to prevent accidental commits.

- `laravel-secret-env.yaml`: Environment variables for Laravel
- `mysql-secrets.yaml`: MySQL credentials
- Use `kubeseal` for encrypting secrets if using Sealed Secrets.

### Environment Variables

Configure the following in your secrets:

- Database connection details
- Redis host and port
- Laravel APP_KEY
- Queue connection settings

### Scaling

Horizontal Pod Autoscalers (HPA) are configured for both the app and worker:

- App HPA: Scales based on CPU utilization (target 50%)
- Worker HPA: Scales based on CPU utilization (target 70%)

## Health Checks

The application includes comprehensive health probes:

- **Startup Probe**: Ensures the app starts correctly (up to 5 minutes)
- **Liveness Probe**: Restarts unhealthy pods
- **Readiness Probe**: Routes traffic only to ready pods

Health endpoints are defined in the Laravel application (e.g., `/health/startup`, `/health/live`, `/health/ready`).

## Monitoring and Logging

- Resource requests and limits are set for all containers.
- Logs can be accessed via `kubectl logs`.
- Consider integrating with monitoring tools like Prometheus for metrics.

## Contributing

1. Fork the repository.
2. Create a feature branch.
3. Make your changes.
4. Test deployments in a development environment.
5. Submit a pull request.

## Support

For issues or questions, please open an issue in this repository.