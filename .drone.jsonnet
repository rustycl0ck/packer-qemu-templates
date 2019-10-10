local config = {
  name: 'ubuntu',
};

local build(name) = {
  local step(is_pr) = {
    name: name + if is_pr then '_PR' else '',
    //image: 'appleboy/drone-packer',
    image: 'rustycl0ck/drone-packer',
    pull: 'always',
    settings: {
      template: 'ubuntu.json',
      actions: 'build',
      var_files: [
        'ubuntu1804.json',
        ],
      color: 'true',
      debug: 'true',
      context: 'ubuntu',
    },
    when: {
      ref: [
        'refs/heads/master',
        'refs/tags/*',
      ],
      event:
        if is_pr then [
          'pull_request',
        ] else [
          'tag',
          'push',
        ],
    },
  },
  steps: [
    step(is_pr=true),
    step(is_pr=false),
  ],
};

[
  {
    kind: 'pipeline',
    name: 'default',
    steps:
      build(config.name).steps
  },
]

// Tip: run `drone jsonnet --stream [--stdout]` to generate `.drone.yml` file for verification

