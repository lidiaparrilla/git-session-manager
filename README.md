# Repo-Template 

<!-- Change the <owner>/<repository_name> pair in the URLs below to use the status badges -->
![CI](https://github.com/idener/Repo-Template/actions/workflows/deployment-semver.yaml/badge.svg)
[![GitHub Super-Linter](https://github.com/idener/Repo-Template/actions/workflows/code-analysis.yaml/badge.svg?branch=main)](https://github.com/idener/Repo-Template/actions/workflows/code-analysis.yaml)

This repository serves as a skeleton for the creation of new repositories where you need to create an image and optionally deploy it to the kubernetes cluster.  

In this repository you will store:
- The application source code
- A `Dockerfile`
- A `docker-compose.yaml` for testing locally the image (optional)
- Application tests (also optional, but recommended)
- The automated workflows described below

# Table of Contents

  * [Workflows](#ci-workflows)
    * [Source Code Analysis](#code-analysis)
      * [Super-Linter](#linter)
      * [Semgrep](#semgrep)
    * [Container Image Scanning](#container-image-scanning)
    * [Issue branch generation](#issue-branch-generation)
    * [Deployment](#deployment)
      * [Image Tagging](#image-tagging)
  * [Template Usage](#usage-of-the-template)
    * [Kubernetes Deployment](#kubernetes-deployment)


# Workflows

A workflow is a configurable automated process that will run one or more jobs. Workflows are defined by a YAML file (stored in the `.github/workflows` directory) and will run when triggered by an event in your repository or some of them can be triggered manually. Currently, there are 3 automated process operating on different stages of the sofware development cycle. These are:

1. Source Code Analysis
2. Container Image Scanning
3. Deployment trough Releases and Semantic Versioning

## Source Code Analysis
Source code analysis is performed by Static Analys Tools (SCA), usually as part of a code review during pull requests. This type of analysis addresses weaknesses in source code that might lead to vulnerabilities and also enforces coding style guidelines.

The analysis of the code is made on pull request to the main branch and will be remade every time a commit is made for the pull requests, helping us to introduce better, error-free code to the main branch. Only the modified files will be scanned. It is advisable to remove all errors before resolving the pull request.
You can also analyze the code on-demand whenever you want by running the Code Analysys action. This will run the analysis on all the codebase.

### Super Linter

The code analysis workflow is running a [Super-Linter](https://github.com/github/super-linter) to help you validate your source code. 

The end goal of this tool is to:
- Help establish coding best practices across multiple languages
- Build guidelines for code layout and format
- Automate the process to help streamline code reviews

If some language being linted is annoying you or giving false errors, you can disable it in the `.github/workflows/linter.yaml` file, passing the `VALIDATE_<LANGUAGE>: false` input to the Super-Linter action.

The files in this [folder](https://github.com/github/super-linter/tree/main/TEMPLATES) are the template rules for the linters that will run against your codebase.

### Semgrep

[Semgrep](https://semgrep.dev/) is a fast, open-source, static analysis tool for finding bugs and enforcing code standards at CI time. Semgrep supports 20+ languages and it comes with [2,000+ community-driven rules](https://semgrep.dev/explore) covering security, correctness, and performance bugs.  

## Container Image Scanning

There is a workflow that can be used to help you add some additional checks to help to secure your Docker Images. This would help you attain some confidence in your docker image before pushing them to your container registry or a deployment.

It internally uses `Trivy` and `Dockle` for running certain kinds of scans on these images. 
- [`Trivy`](https://github.com/aquasecurity/trivy) helps you find the common vulnerabilities within your docker images. 
- [`Dockle`](https://github.com/goodwithtech/dockle) is a container linter, which helps you identify if you haven't followed 
  - Certain best practices while building the image 
  - [CIS Benchmarks](https://www.cisecurity.org/cis-benchmarks/) to secure your docker image
  
This workflow will be run during pull requests, but you can also trigger it manually. It will build and push an image with a `pre-release` tag and then analyze it. It is recommended to run this workflow before making any release of the code.

## Issue branch generation

A branch will be automatically generated whenever a new issue is assigned to somebody. That branch will have the following name:
```text
<label>/<issue_number>-<issue_title>

For example...
feature/25-new-functionality-x
```




# Deployment

```text
┌──────┐   ┌───────┐   ┌────────┐   ┌──────────┐
│ Test │   │ Build │   │Push to │   │Update K8s│
│      ├──►│ Image ├──►│Registry├──►│manifests │
└──────┘   └───────┘   └────────┘   └──────────┘
```
1. Run tests if defined
2. Build the image (this will be done using Kaniko)
3. Push to image registry
4. Update the K8 manifests of the deployment repository with the new image version tag (optional)

## Image Tagging
You can choose between 2 methods for tagging your image, use the commit SHA or use git tags.

**NOTE: Independently of what method you use, images will be pushed with the `latest` tag in addition to the version tag.**

### Using the commit SHA
Every commit has a SHA number associated, we can use the first 6 digits and use it as the tag for the image. This workflow is implemented in the `deployment-sha.yaml` file.

### Using git tags and releases (Recommended)

This is the best practice as it inherits all the benefits of the [Semantic Versioning](https://semver.org/) system and the automatic generation of release notes. The developer workflow would be as follow:

0. An Issue is created for the development of a new feature, the fix of a bug... This issue is labeled accordingly and assigned to someone.
1. A new branch from `main` is automatically generated based on the previous issue (you can always create it manually, without any issue). The name of the branch will be prefixed with one of the following:
  - `feature/...`
  - `enhacement/...`
  - `performance/...`
  - `fix/...`
  - `bug/...`
  - `patch/...`
  - `docs/...`
  - `chore/...`
2. Write code on that branch.
3. When you are done, open a pull request to the `main` branch. This pull request will be labeled automatically according to the type of the branch (see step 1). This label will be important to determine the next version of the release (based on the Semantic Versioning schema), as we will se later. You can always label it manually if you forgot about the branching name requirement.
4. Review the source code analysis and the container image scanning workflows triggered by this pull request (the results will be showed on the pull request page and also in the actions page).
5. Try to eliminate bugs introduced in code following the previous analysis guidelines.
6. When you are ready, resolve the pull request. This will create a draft release (or update it if there is already one), categorizing the changes made according to the branch name as follows:
    - Features (change in minor version number):
      - `feature`
      - `enhacement`
      - `performance`
    - Bug fixes (change in patch version number):
      - `fix`
      - `bug`
      - `patch`
    - Maintenance (no changes in version number):
      - `docs`
      - `chore`
7. The draft release will be populated automatically with the successive pull requests and the version will be increased accordingly. When you are ready, publish the release. This will trigger the deployment workflow.

**Important notes:**
- An increase in the major version number will be done only when a pull request is labeled (manually), as `major` or `stable`. It is up to the developer to choose when to make such a change.
- The name appearing in the Release Notes will be the name of the pull request, so try to make it as concise and descriptive as possible about the changes introduced in that merge.
- You can always make a hotfix commit to the main branch without doing the new branch + pull-request steps. This will increase the patch version number of the next release. The downside is that the change will not be reflected in the release notes, so consider to add the change to the release notes manually if the change is somewhat important.

# Template Usage

1. Click on the 'Use this template' button on the top right corner and create a repository with the name of the image that will be created.
2. In the newly generated repository, go to Settings -> Secrets -> Actions, and create 2 secrets:
    - `REGISTRY_USERNAME`: Username for authentication with the container registry to be used.
    - `REGISTRY_PASSWORD`: Password or token used to authenticate with the container registry.
3. Then, in the CI workflow files, modify the env variables:
    - `IMAGE_NAME`: Name of the image
    - `REGISTRY_URL`: URL of the container registry
4. Code!

### Kubernetes Deployment
If you want to deploy your application in the kubernetes cluster you will need to:
- Set to true the `DEPLOY_ENABLE` environment variable.
- Modify `DEPLOY_REPO` with the name of the repository storing the k8 configuration files (i.e. idener/CD-Project).
- Create a SSH key pair. Put the public one in the deployment repository (Settings -> Deploy keys) and put the private key in this repository as a secret with the name `REPO_SSH`.

Before doing all of this you need make and configure a deployment repository for the project with the kubernetes manifests files (this will be done by Carlos Leyva or Antonio Gomez)
