# Docker-run AWS deploy scripts.

This project include AWS elastic beanstalk docker deploy files for [docker-run](https://github.com/studyhub-co/docker-run) service. 

The service based on [glot.io](https://github.com/glotcode/glot) code.

### Overview
```
┌────────────────────────────────────────────┐
│       Studyhub http client                 │
└────────────────────────────────────────────┘
          │                         │
          │                         │
          ▼                         ▼
┌──────────────────┐   ┌─────────────────────┐
│ save             │   │                     │
│ create-react-app │   │                     │
│ build from ->    │   │ docker-run docker   │
└──────────────────┘   └─────────────────────┘
                                    │
                                    │
                                    ▼
                       ┌─────────────────────────┐
                       │         docker          │
                       │  ┌───────────────────┐  │
                       │  │    glot-images    │  │
                       │  │  ┌─────────────┐  │  │
                       │  │  │ code-runner │  │  │
                       │  │  └─────────────┘  │  │
                       │  └───────────────────┘  │
                       └─────────────────────────┘
```


### Process steps
#### Studyhub side

1) We have a 'celery' queue with a task build 'create react app'. Building process (webpack build) takes too many system resources, so we need to use queue to limit building proccess to one at the same period of time.
2) User runs command 'publish sandbox' from VSCode editor.
3) Task created and added to the celery queue.
4) Tasks broker (rabbitmq) run 'publish sandbox' task. 
5) Task makes an HTTP request to the 'docker-run' web service with JSON data of sandbox files.

#### Docker-run side

6) docker-run service starts container with docker image ['create-react-app'](https://github.com/studyhub-co/glot-images/blob/main/images/build-only/create-react-app.nix) (glot-image).
7) glot-image run code-runner with [build commands](https://github.com/studyhub-co/code-runner/blob/main/src/code_runner/language.rs#L378)
8) run command creates archive with build files result and return with HTTP response to Studyhub 

#### Studyhub side

9) Task get result of docker-run response and save static files in the Django media folder.
10) Application serves with nginx as static files to exclude server-side application compromising.