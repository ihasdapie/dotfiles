require('claudecode').setup({
    env = {
        CLAUDE_CODE_SKIP_VERTEX_AUTH = os.getenv('CLAUDE_CODE_SKIP_VERTEX_AUTH') or '1',
        CLAUDE_CODE_USE_VERTEX = os.getenv('CLAUDE_CODE_USE_VERTEX') or '1',
        CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC = os.getenv('CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC') or '1',
        ANTHROPIC_AUTH_TOKEN = os.getenv('ANTHROPIC_AUTH_TOKEN') or '',
        ANTHROPIC_VERTEX_BASE_URL = os.getenv('ANTHROPIC_VERTEX_BASE_URL') or 'https://inference.bottlerocket.tesla.com/models/gcp-vertex-ap/v1',
        ANTHROPIC_VERTEX_PROJECT_ID = os.getenv('ANTHROPIC_VERTEX_PROJECT_ID') or 'bottle-rocket-ap',
        NODE_TLS_REJECT_UNAUTHORIZED = os.getenv('NODE_TLS_REJECT_UNAUTHORIZED') or '0',
    }
})
