## 소개
이 문서는 github, gitlab의 CICD 기능을 테스팅하고 검토하면서 정리한 자료입니다.

## 선택 : 설치형 vs SaaS (Software as a Service)
Gitlab은 모든 타입에서 설치형 지원
Github는 Enterprise 에서만 설치형 지원

IDC나 사내에서 CICD 를 쓸 일이 있으면 필요한 곳에 runner 를 설치하면 가능

## Gitlab vs Github 가격비교
| Gitlab | Github |
|--------|--------|
| https://about.gitlab.com/pricing/ | https://github.com/pricing |
| Free | Free |
|Premium : 1인당 월$19*12= 년 $228|Team : 1인당 월 $4*12 = 년 $48|
|Ultimate : 1인당 월$99*12=년 $1188|Enterprise : 1인당 월 $21*12 = 년 $252|

## Gitlab vs Github 기능 비교
#### 타입별 기능 비교
Free 버전에서는 git 사용을 위한 기본적인 기능만 지원을 하며 기술지원 없음  
PR(MR) 요청을 했을 때 리뷰어를 두고 승인하는 기능은 Free 버전에는 없으며 Gitlab Premium이나 Github Team을 써야 함  
Gitlab Ultimate, Github Enterprise 는 주로 보안과 관련한 기능 추가

**일반적인 기능은 비슷하게 지원이 됨**
* 버전관리
* 프로젝트관리(wiki, issues)
* 패키지기능(npm, RubyGems, Apache Maven, Gradle, Docker, and NuGet, docker)
* CICD
* API 연동

**Gitlab은 CICD 기능 외에 다양한 부가 기능을 지원**
* https://docs.gitlab.com/ee/operations/
* 메트릭으로 신뢰성 및 안정성 측정
* 경고 및 사고 관리
* 애플리케이션의 오류 추적
* 애플리케이션 상태 및 성능 추적
* 로그 집계 및 저장
* 코드로 인프라 관리 (terraform remote backend)
* k8s 통합기능 https://docs.gitlab.com/ee/user/project/clusters/
* 테스팅과 관련한 각종 툴이 통합 :  단위테스트 보고서, 접근성 테스트, 브라우저 성능 테스트, 코드 품질, 부하 성능 테스트, 메트릭 레포트
(https://docs.gitlab.com/ee/ci/unit_test_reports.html)

**Gitlab에서는 여러 가지 부가기능을 많이 지원하지만 Github 에서는 다른 대체수단을 이용하여 처리할 수 있을 것으로 생각됨**
* terraform remote backend 는 AWS 에서 S3+dynamoDB 와 연동하여 처리 가능
* k8s는 Flux(https://fluxcd.io/) 나 Argo CD (https://argoproj.github.io/argo-cd/) 등을 이용

CICD는 Github 에서 Github actions 를 지원하면서 큰 차이가 없음  
Github marketplace 에서 필요한 것을 찾거나 직접 만들어서 사용 하면 됨

**Gitlab, Github CICD 예제**
* https://docs.gitlab.com/ee/ci/examples/README.html
* https://docs.github.com/en/actions/guides

**Gitlab CICD의 장점은 environments 를 이용하여 각 환경(staging, prod)에 대한 배포를 손쉽게 하고 기록을 확인가능한 점**  
Github 은 environments 기능을 public repo나 enterprise plan 일 경우에만 지원하고 github team 의 private repo에는 지원 안함  
Github 에서 environments 기능은 리뷰어의 승인이 있어야 배포 가능/트리거 발생후 일정 시간이 지나야 배포 가능/특정 브랜치만 배포 가능  
https://docs.github.com/en/actions/reference/environments
https://github.blog/changelog/2020-12-15-github-actions-environments-environment-protection-rules-and-environment-secrets-beta/

## Github 구성
IDC에서 CICD를 하는 경우에는 IDC에 윈도우용 runner, LInux runner 구성  
AWS 를 이용하는 경우에는 소스코드 관리는 Github로 하되 AWS CodePipeline 를 이용할 수도 있음
https://aws.amazon.com/ko/codepipeline/

### github actions
quickstart 에서 간단한 github actions  직접 만들어서 해봄
https://docs.github.com/en/actions/quickstart

guides 에서 주로 사용하는 언어를 골라서 build, test, deploy 하는 예제를 살펴본다.
https://docs.github.com/en/actions/guides

#### GitHub Actions 배우기
Learn GitHub Actions : github actions 를 이용하여 workflow 를 만드는 방법을 상세히 설명
https://docs.github.com/en/actions/learn-github-actions

github actions 과정에 대한 설명, actions 찾기, 조직과 워크플로우 공유하기, 보안 등을 다루고 있음. 

#### actions 만들기
https://docs.github.com/en/actions/creating-actions
actions는 jobs을 만들고  workflow를 구성하는 개별 작업으로 자신이 직접 만들거나 github 커뮤니티에서 다른 사람들이 만든 것을 이용할 수 있다.

actions는 3가지 타입으로 만들 수 있으며 Docker container, JavaScript, Composite run steps 가 있다.  https://docs.github.com/en/actions/creating-actions/about-actions
Docker container 는 리눅스만 지원한다. JavaScript는 runner 에서 실행이 되며 “JavaScript 작업을 사용하면 작업 코드가 단순화되고 Docker 컨테이너 작업보다 빠르게 실행됩니다.” 라고 문서에 나와있다. Composite run steps 는 쉘스크립트를 이용하여 처리하는 경우로 Docker container, JavaScript  보다는 뒤에 기능이 추가가 되었다.

#### Reference
Encrypted secrets : 암호화된 비밀정보.  workflow 파일에서  input 이나 environment 변수로 받아서 사용할 수 있음.
https://docs.github.com/en/actions/reference/encrypted-secrets

environments
environments 를 이용하면 배포시 몇가지 제한을 걸 수 있다. 리뷰어의 승인이 있어야 배포 가능, 트리거 발생후 일정 시간이 지나야 배포 가능, 특정 브랜치만 배포 가능. 그런데 이 기능은 공개 repo이거나 enterprise plan 일 경우에만 지원을 하고 github team 의 private repo에는 아직 지원 안함. 
https://docs.github.com/en/actions/reference/environments

environments 를 이용한 예제임. 
https://dev.to/n3wt0n/everything-you-need-to-know-about-github-actions-environments-9p7
Pull Request 상태 일 때만 Dev에 배포
메인에 커밋하거나 병합 할 때만 스테이징에 배포
스테이징 후 승인을 받아 프로덕션에 배포

#### github actions 제한
https://docs.github.com/en/actions/reference/usage-limits-billing-and-administration
Job execution time : 6시간
Workflow run time : 72 hours

#### github self-hosted runners 
##### github runner 설치 및 등록
repository 또는 organization 차원에서 runner 를 등록할 수 있음.
https://docs.github.com/en/actions/hosting-your-own-runners/adding-self-hosted-runners

runner 를 추가하는 화면에서 runner를 설치하고 설정하는 부분에 대한 설명이 나옴. 

설치시 root로 진행을 하면 sudo 관련한 에러가 나옴. 

보안을 위해서 별도 user를 만들어서 runner를 실행함. runner 를 실행할 user를 만들고 docker 를 사용하기 위해서 docker group에 추가를 해준다. 
```
# useradd -m  -s /bin/bash --comment 'github runner'  github-runner
# usermod -aG docker github-runner
# sudo su - github-runner
```


github-runner user로 runner 설치. 설정을 할 때  나오는 url과 token 정보를 이용
```
$ mkdir actions-runner && cd actions-runner
$ curl -o actions-runner-linux-x64-2.278.0.tar.gz -L https://github.com/actions/runner/releases/download/v2.278.0/actions-runner-linux-x64-2.278.0.tar.gz
$ tar xzf ./actions-runner-linux-x64-2.278.0.tar.gz
.$ /config.sh --url https://github.com/VntgCorp --token ATZHRXXXXXXXX
```

아래는 root 권한으로 실행을 해야 함. systemd 설정을 하며 실행하는 사용자를 지정하는 것임.
```
# ./svc.sh install github-runner
# ./svc.sh start
# ./svc.sh status
```

self-hosted runners 를 github actions에 추가할 때 자동으로 self-hosted, 운영 체제 및 하드웨어 플랫폼 레이블이 설정 된다. 필요하면 추가 레이블을 설정할 수 있다. 예를 들어 x86_64 ubuntu 20.04 의 경우 self-hosted, linux, X64 로 나온다.

보안 문제로 public repo의 경우에는 기본적으로 organization에 있는 runner group 을 사용할 수 없다. (https://docs.github.com/en/actions/hosting-your-own-runners/about-self-hosted-runners#self-hosted-runner-security-with-public-repositories )
workflow 에서 runner 사용
https://docs.github.com/en/actions/hosting-your-own-runners/using-self-hosted-runners-in-a-workflow

runs-on: [self-hosted, linux, X64]

workflow에서 runner에 할당한 레이블을 넣으면 됨. and 조건임. 

##### github actions 기타 참고자료
github actions 사용하는 교육자료
https://docs.microsoft.com/ko-kr/learn/paths/automate-workflow-github-actions/

#### docker registry, container registry
https://docs.github.com/en/packages/working-with-a-github-packages-registry/working-with-the-docker-registry
```
$ docker login https://docker.pkg.github.com -u tjmoon-vntg
$ docker build -t docker.pkg.github.com/tjmoon-vntg/action_test/docker_test:1.0 .
$ docker push docker.pkg.github.com/tjmoon-vntg/action_test/docker_test:1.0
```
현재는 package namespace 를 사용하는 Docker registry 를 지원하고 있는데 향후에는 Container Registry 로 대체를 할 것이라고 함. Container Registry 는 사용자 또는 조직에 대해서 설정을 하며 아직은 베타버전임. 
https://docs.github.com/en/packages/working-with-a-github-packages-registry/enabling-improved-container-support-with-the-container-registry

## gitlab

### gitlab runner 설치 및 등록
runner type : shared runners, group runners, specific runners

OS에 gitlab-runner 설치.
executor 가 여러 가지 있는데 docker 를 추천하고 있음. OS에 docker 설치.
gitlab-runner 설치 후 runner 를 등록함. 

https://docs.gitlab.com/runner/register/index.html#docker
executor docker 로 실행시 gitlab.example.com 을 찾지 못함. 
```
REGISTRATION_TOKEN=gCGg8tkK51TATVpjsBHz
sudo gitlab-runner register \
  --non-interactive \
  --url http://gitlab.example.com/ \
  --registration-token $REGISTRATION_TOKEN \
  --executor "docker" \
  --docker-image alpine:latest \
  --description "docker-runner" \
  --tag-list "docker,aws" \
  --run-untagged="true" \
  --locked="false" \
  --access-level="not_protected"
```

https://docs.gitlab.com/runner/configuration/advanced-configuration.html
extra_hosts 옵션을 추가해서 docker 에서 /etc/hosts를 업데이트할 수 있음.
extra_hosts = ["other-host:127.0.0.1"] 
```
cat > /tmp/test-config.template.toml << EOF
[[runners]]
name = "docker-runner"
[runners.docker]
extra_hosts = ["gitlab.example.com:192.168.33.12"]
EOF


REGISTRATION_TOKEN=gCGg8tkK51TATVpjsBHz
sudo gitlab-runner register \
  --non-interactive \
  --url http://gitlab.example.com/ \
  --registration-token $REGISTRATION_TOKEN \
  --executor "docker" \
  --docker-image alpine:latest \
  --description "docker-runner" \
  --tag-list "docker,aws" \
  --run-untagged="true" \
  --locked="false" \
  --access-level="not_protected" \
  --template-config /tmp/test-config.template.toml   
```
shell로 등록시 아래 에러가 나왔음. gitlab-runner verify 명령으로 처리. 
'New runner. Has not connected yet.' 
https://gitlab.com/gitlab-org/gitlab-runner/-/issues/3750


### CICD pipeline
기초적인 pipeline
* https://docs.gitlab.com/ee/ci/pipelines/
* http://gitlab.example.com/help/ci/quick_start/index.md

stage 는 정의를 하지 않으면 기본으로 5가지가 사용된다.  .pre, build,test, deploy, .post
https://docs.gitlab.com/ee/ci/yaml/#stage

runner 에서 동시작업을 하려고 하면 gitlab-runner에서 concurrent 옵션을 바꾸어준다. 기본은 1로 되어 있다. 이 부분을 바꾸어 주어야 여러개의 job을 동시에 실행할 수 있다.
https://docs.gitlab.com/runner/configuration/advanced-configuration.html#the-global-section

pipeline이 성공했을 때만 머지하는 기능은 유용할 듯.
https://docs.gitlab.com/ee/user/project/merge_requests/merge_when_pipeline_succeeds.html

ssh 이용하는 경우 다음 내용 참고.
https://docs.gitlab.com/ee/ci/examples/deployment/composer-npm-deploy.html

environments 이용하여 배포 기록 남기고 과거 버전으로 롤백 할 수 있음.

#### 기타, 다른 툴과 연동
terraform 의 remote state 를 저장하는 용도로 사용 가능함. terraform을 여러 명이 함께 사용을 하는 경우 필요한 기능임.
https://docs.gitlab.com/ee/user/infrastructure/index.html#gitlab-managed-terraform-state
https://docs.gitlab.com/ee/administration/terraform_state.html


## Github, Gitlab CICD environments 기능 비교
gitlab, github environments 기능

### gitlab environments 예제
environment 를 활용하는 간단한 예제이다. (.gitlab-ci.yml)
* 사전에 environment 에 staging, production 을 구성한다.
* 소스코드가 업데이트되면 ubuntu:20.04 docker 컨테이너에서 실행이 되며 staging 은 ssh를 이용하여 자동 배포가 된다.
* production 에는 수동으로 배포를 하도록 구성을 했다. (manual) 수동으로 배포를 할 수 있는 사람도 지정할 수 있다. https://docs.gitlab.com/ee/ci/yaml/#protecting-manual-jobs  
* 이제 environment 로 가면 staging, production 환경별로 배포한 기록을 볼 수 있고 특정 commit 으로 롤백을 할 수도 있다.

```
image: ubuntu:20.04

before_script:
  - apt-get update
  - 'which ssh-agent || apt-get install openssh-client -y'
  - mkdir -p ~/.ssh
  - eval $(ssh-agent -s)
  - '[[ -f /.dockerenv ]] && echo -e "Host *\n\tStrictHostKeyChecking no\n\n" > ~/.ssh/config'

deploy-staging:
  stage: deploy
  script:
    - echo "staging, This job deploys something from the $CI_COMMIT_BRANCH branch."
    - ssh-add <(echo "$STAGING_PRIVATE_KEY")
    - ssh -p22 test@192.168.33.14 "mkdir -p test"
    - ssh -p22 test@192.168.33.14 "date ; touch a.txt"
    - scp -P22 * test@192.168.33.14:test/
    - scp -P22 index.html test@192.168.33.14:/var/www/html/index.html
  environment:
    name: staging
    url: http://staging.example.com

deploy-production:
  stage: deploy
  script:
    - echo "prd , This job deploys something from the $CI_COMMIT_BRANCH branch."
  environment:
    name: production
    url: http://www.example.com
  when: manual
  only:
    - master
```


### github environments 예제
Github 은 environments 기능을 public repo나 enterprise plan 일 경우에만 지원하고 github team 의 private repo에는 지원 안함  
Github 에서 environments 기능은 리뷰어의 승인이 있어야 배포 가능/트리거 발생후 일정 시간이 지나야 배포 가능/특정 브랜치만 배포 가능  
https://docs.github.com/en/actions/reference/environments  

아래 github workflow 파일은 다음과 같은 내용을 담고 있다.
* 사전에 production environments 에 Required reviewers 설정을 함.
* Pull Request 상태 일 때만 Dev에 배포
* 메인에 커밋하거나 병합 할 때만 스테이징에 배포
* 스테이징 후 승인을 받아 프로덕션에 배포. 해당 environments 의 Required reviewers 가 승인을 해 주어야 배포가 됨.

```
# https://dev.to/n3wt0n/everything-you-need-to-know-about-github-actions-environments-9p7

name: CI + CD

on:
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]

  # Allows you to run this workflow manually from the Actions tab
  workflow_dispatch:

jobs:
  Build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - name: Compile
        run: echo Hello, world!

  DeployDev:
    name: Deploy to Dev 
    if: github.event_name == 'pull_request'
    needs: [Build]
    runs-on: ubuntu-latest
    environment: 
      name: Development
      url: 'http://dev.example.com'
    steps:
      - name: Deploy
        run: echo I am deploying! 

  DeployStaging:
    name: Deploy to Staging 
    if: github.event.ref == 'refs/heads/main'
    needs: [Build]
    runs-on: ubuntu-latest
    environment: 
      name: Staging
      url: 'http://staging.example.com/'
    steps:
      - name: Deploy
        run: echo I am deploying! 

  DeployProd:
    name: Deploy to Production 
    needs: [DeployStaging]
    runs-on: ubuntu-latest
    environment: 
      name: Production
      url: 'http://www.example.com'
    steps:
      - name: Deploy
        run: echo I am deploying!             
 ```
 
