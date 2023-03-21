# Starship Action

[![](https://github.com/Anmol1696/starship-action/workflows/Test/badge.svg?branch=main)](https://github.com/Anmol1696/starship-action/actions)

GitHub Action for creating and running [starship devnets](https://github.com/Anmol1696/starship) in CI.

## Usage

### Pre-requisites

Create a workflow YAML file in your `.github/workflows` directory. An [example workflow](#example-workflow) is available below.
For more information, reference the GitHub Help Documentation for [Creating a workflow file](https://help.github.com/en/articles/configuring-a-workflow#creating-a-workflow-file).

### Inputs

For more information on inputs, see the [API Documentation](https://developer.github.com/v3/repos/releases/#input)

- `values`: Required, config for helm chart for starship devnet inputs
- `port-forward`: Optional, toggle to perform local port-forwarding, based on the `values.yaml` (default: `false`)
- `kubeconfig`: Optional, Kubeconfig for remote cluster, if set, will be used instead of creating local kind cluster
- `version`: Optional, version of devnet chart from starship (default: `0.1.4`)
- `repo`: Optional, Helm repo to fetch the chart from (default: https://anmol1696.github.io/starship)
- `name`: Optional, Release name for the helm chart deployment (default: `starship-devnet`)

### Example workflow

Chreate a workflow (eg: `.github/workflows/create-osmosis-wasmd.yml`)
```yaml
name: Create Starship devnet

on: pull_request

jobs:
  create-devnet:
    runs-on: ubuntu-latest
    steps:
      - name: Create starship devnet for osmos and wasm
        uses: Anmol1696/starship-action@v1
        with:
          values: |
            chains:
            - name: osmosis-1
              type: osmosis
              numValidators: 1
              ports:
                rest: 1313
                rpc: 26653
              resources:
                limits:
                  cpu: "0.2"
                  memory: "200M"
                requests:
                  cpu: "0.1"
                  memory: "100M"
            - name: wasmd
              type: wasmd
              numValidators: 1
              ports:
                rpc: 26659
                rest: 1319
              resources:
                limits:
                  cpu: "0.2"
                  memory: "200M"
                requests:
                  cpu: "0.1"
                  memory: "100M"
```
