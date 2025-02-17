# Starship Action

[![](https://github.com/hyperweb-io/starship-action/workflows/Test/badge.svg?branch=main)](https://github.com/hyperweb-io/starship-action/actions)

GitHub Action for creating and running [starship devnets](https://github.com/hyperweb-io/starship) in CI.

## Usage

### Pre-requisites

Create a workflow YAML file in your `.github/workflows` directory. An [example workflow](#example-workflow) is available below.
For more information, reference the GitHub Help Documentation for [Creating a workflow file](https://help.github.com/en/articles/configuring-a-workflow#creating-a-workflow-file).

### Inputs

For more information on inputs, see the [API Documentation](https://developer.github.com/v3/repos/releases/#input)

- `config`: Required, config file for helm chart for starship devnet inputs
- `cli-version`: Optional, version of @starship-ci/cli to use (default: `3.3.0`)
- `kubeconfig`: Optional, Kubeconfig for remote cluster, if set, will be used instead of creating local kind cluster
- `namespace`: Optional, Kubernetes namespace to which helm charts will be deployed. If not found, namespace will be created. (default: `ci-${{ github.repository }}-${{ github.workflow }}-${{ github.ref }}`)
- `repo`: Optional, Helm repo to fetch the chart from (default: https://hyperweb-io.github.io/starship)
- `name`: Optional, Release name for the helm chart deployment (default: `starship-devnet`)
- `chart`: Optional, Name of  the help chart to use. Recommended: use default (default: `starship/devnet`)
- `timeout`: Optional, Timeout for helm install (default: `10m`)

### Outputs
- `namespace`: Namespace where the devnet is deployed
- `name`: Name of the helm chart, same as `name` input

### Example workflow

Chreate a workflow (eg: `.github/workflows/create-osmosis-wasmd.yml`)
```yaml
name: Create Starship devnet

on: pull_request

jobs:
  create-devnet:
    runs-on: ubuntu-latest
    
    steps:
      - uses: actions/checkout@v4
        
      - name: Create starship devnet for osmos and wasm
        uses: hyperweb-io/starship-action@v0.5.9
        with:
          config: ./starship-config.yaml
```
