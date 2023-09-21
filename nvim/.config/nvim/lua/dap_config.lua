local dap = require('dap')
require("dapui").setup()

dap.adapters.delve = {
    type = 'server',
    port = 2345,
}
dap.configurations.go = {
    {
        type = 'delve',
        request = 'attach',
        name = 'Attach to Go',
        mode = 'remote',
        substitutePath = {
            {
                from = "${env:GOPATH}/src",
                to = "src"
            },
            {
                from = "${env:GOPATH}/bazel-go-code/external/",
                to = "external/"
            },
            {
                from = "${env:GOPATH}/bazel-out/",
                to = "bazel-out/"
            },
            {
                from = "${env:GOPATH}/bazel-go-code/external/go_sdk",
                to = "GOROOT/"
            },
        },
    },
}
