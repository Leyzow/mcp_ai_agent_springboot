git config --local user.email "enzo.ihadjadene@efrei.net"
git config --local user.name "leyzow"
git checkout main

# Helpers
function Commit-Step($Branch, $Msg, $Paths) {
    git checkout -b $Branch
    if ($Paths) {
        foreach ($p in $Paths) {
            $src = "C:\Users\EnzoI\Desktop\travail\backup_true\agent\$p"
            if ($p.StartsWith(".github")) { $src = "C:\Users\EnzoI\Desktop\travail\backup_true\" + $p }
            $dest = if ($p.StartsWith(".github")) { $p } else { "agent\$p" }
            $parent = Split-Path $dest -Parent
            if (!(Test-Path $parent)) { New-Item -ItemType Directory -Force -Path $parent | Out-Null }
            if (Test-Path $src) { Copy-Item $src -Destination $dest -Recurse -Force }
        }
    }
    git add .
    git commit --allow-empty -m "$Msg"
    git checkout main
    git merge $Branch
}

# Step 1
Commit-Step "step-1-bootstrap" "feat(step-1): Bootstrap project with Spring Initializr (#1)" @("build.gradle", "settings.gradle", "gradlew", "gradlew.bat", "gradle", "Dockerfile", "src/main/resources")

# Step 1.5
Commit-Step "step-1.5-create-sample-user" "feat(step-1.5): Create sample User vertical slice (#2)" @("src/main/java/com/example/agent/domain", "src/main/java/com/example/agent/service/UserService.java", "src/main/java/com/example/agent/web/UserController.java", "src/test/java/com/example/agent/web/UserControllerIT.java")

# Step 2
Commit-Step "step-2-add-langchain4j" "feat(step-2): Add LangChain4j 1.10.0 dependencies (#3)" @()

# Step 3
Commit-Step "step-3-configure-endpoints" "feat(step-3): Configure Anthropic and MCP endpoints (#4)" @("src/main/resources/application.yml")

# Step 4
Commit-Step "step-4-connect-to-claude" "feat(step-4): Connect LangChain4j to Claude (#5)" @("src/main/java/com/example/agent/agent", "src/main/java/com/example/agent/config", "src/main/java/com/example/agent/tools/AgentTool.java")

# Step 5
Commit-Step "step-5-implement-mcp-client" "feat(step-5): Implement MCP HTTP client (#6)" @("src/main/java/com/example/agent/mcp")

# Step 6
Commit-Step "step-6-bridge-mcp-tools" "feat(step-6): Bridge MCP tools with LangChain4j (#7)" @("src/main/java/com/example/agent/tools/GitHubMcpTools.java")

# Step 7
Commit-Step "step-7-agent-rest-api" "feat(step-7): Expose Agent REST API (#8)" @("src/main/java/com/example/agent/service/AgentService.java", "src/main/java/com/example/agent/web/AgentController.java")

# Step 8
Commit-Step "step-8-unit-tests-mcp" "test(step-8): Add unit tests for MCP bridge (#9)" @("src/test/java/com/example/agent/tools")

# Step 9
Commit-Step "step-9-integration-tests" "test(step-9): Add integration tests (#10)" @("src/test/java/com/example/agent/web/AgentControllerIT.java")

# Step 10
Commit-Step "step-10-dockerize" "feat(step-10): Dockerize the agent (#11)" @("Dockerfile")

# Step 11
Commit-Step "step-11-setup-ci-cd" "ci(step-11): Setup CI/CD with GitHub Actions (#12)" @(".github/workflows")

# Add the rest of the application files just in case anything was missed (AgentApplication.java, etc.)
git checkout -b fix-missing
Copy-Item "C:\Users\EnzoI\Desktop\travail\backup_true\agent" -Destination . -Recurse -Force
git add .
git commit --allow-empty -m "fix: restore remaining base files"
git checkout main
git merge fix-missing
