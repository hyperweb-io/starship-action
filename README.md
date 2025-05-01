# Starship Action

<p align="left" width="100%">
   <a href="https://github.com/hyperweb-io/starship-action/actions/workflows/test.yaml"><img height="20" src="https://github.com/hyperweb-io/starship-action/actions/workflows/test.yaml/badge.svg"></a>
   <a href="https://github.com/hyperweb-io/starship-action/releases/latest"><img height="20" src="https://img.shields.io/github/v/release/hyperweb-io/starship-action"></a>
   <a href="https://github.com/hyperweb-io/starship-action/blob/main/LICENSE"><img height="20" src="https://img.shields.io/badge/license-MIT-blue.svg"></a>
</p>

GitHub Action for creating and running [starship devnets](https://github.com/hyperweb-io/starship) in CI.

## Usage

### Pre-requisites

Create a workflow YAML file in your `.github/workflows` directory. An [example workflow](#example-workflow) is available below.
For more information, reference the GitHub Help Documentation for [Creating a workflow file](https://help.github.com/en/articles/configuring-a-workflow#creating-a-workflow-file).

### Inputs

| Input | Required | Default | Description |
|-------|----------|---------|-------------|
| `config` | Yes | - | Path to the config file for helm chart for starship devnet inputs |
| `cli-version` | No | `3.10.0` | Version of @starship-ci/cli to use |
| `kubeconfig` | No | - | Kubeconfig for remote cluster. If set, will be used instead of creating local kind cluster |
| `namespace` | No | `ci-${{ github.repository }}-${{ github.workflow }}-${{ github.ref }}` | Kubernetes namespace for helm chart deployment |
| `repo` | No | `https://hyperweb-io.github.io/starship` | Helm repo URL to fetch the chart from |
| `name` | No | `starship-devnet` | Release name for the helm chart deployment |
| `chart` | No | `starship/devnet` | Name of the helm chart to use |
| `timeout` | No | `10m` | Timeout duration for helm install |

### Outputs
| Output | Description |
|--------|-------------|
| `namespace` | Namespace where the devnet is deployed |
| `name` | Name of the helm chart, same as `name` input |

### Example Configuration

Create a config file (eg: `starship-config.yaml`):
```yaml
name: starship-localnet
version: 1.7.0

chains:
- id: osmosis-1
  name: osmosis
  numValidators: 2
  ports:
    rest: 1313
    rpc: 26653
    faucet: 8003
- id: cosmoshub-4
  name: cosmoshub
  numValidators: 2
  ports:
    rest: 1317
    rpc: 26657
    faucet: 8007

relayers:
- name: osmos-cosmos
  type: hermes
  replicas: 1
  chains:
    - osmosis-1
    - cosmoshub-4

explorer:
  enabled: true
  ports:
    rest: 8080

registry:
  enabled: true
  ports:
    rest: 8081
```

### Example Workflow

Create a workflow (eg: `.github/workflows/starship.yaml`):
```yaml
name: Create Starship devnet

on: pull_request

jobs:
  create-devnet:
    runs-on: ubuntu-latest
    
    steps:
      - uses: actions/checkout@v4
        
      - name: Create starship devnet for osmos and wasm
        uses: hyperweb-io/starship-action@1.0.0
        with:
          config: ./starship-config.yaml
```

### Troubleshooting

#### Common Issues

1. **Kubeconfig Issues**
   - If using a remote cluster, ensure the kubeconfig file is properly formatted
   - Check that the kubeconfig has the correct permissions

2. **Helm Chart Issues**
   - Verify the chart name and repository are correct
   - Check that the specified version is available in the repository

3. **Namespace Issues**
   - Ensure the namespace doesn't contain invalid characters
   - Check that you have permissions to create/use the specified namespace

## Related Projects

- [Starship](https://github.com/hyperweb-io/starship) - Universal interchain development environment in k8s
- [Cosmology](https://github.com/hyperweb-io) - Interchain JavaScript Stack

## Credits

🛠 Built by Hyperweb (formerly Cosmology) — if you like our tools, please checkout and contribute to [our github ⚛️](https://github.com/hyperweb-io)

## License

MIT © [Hyperweb](https://github.com/hyperweb-io)
