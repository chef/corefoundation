# CoreFoundation Ruby Gem - Copilot Instructions

This document provides comprehensive instructions for GitHub Copilot when working on the CoreFoundation Ruby gem repository. All tasks should be performed locally and follow the specified workflows.

## Repository Overview

CoreFoundation is a Ruby gem that provides FFI-based wrappers for macOS Core Foundation framework. It enables Ruby applications to interact with Core Foundation types like CFString, CFArray, CFDictionary, and preferences management.

### Repository Structure

```
corefoundation/
├── .expeditor/                    # Expeditor build system configuration
│   ├── config.yml                 # Build automation and release configuration
│   └── update_version.sh          # Version update script
├── .github/                       # GitHub configuration and templates
│   ├── workflows/
│   │   └── unit.yml              # GitHub Actions unit test workflow
│   ├── ISSUE_TEMPLATE/           # Issue templates
│   ├── CODEOWNERS               # Code ownership configuration
│   └── copilot-instructions.md  # This file
├── lib/                          # Main source code
│   ├── corefoundation.rb         # Main entry point
│   └── corefoundation/           # Core modules
│       ├── array.rb              # CF::Array wrapper
│       ├── base.rb               # Base CF class
│       ├── boolean.rb            # CF::Boolean wrapper
│       ├── data.rb               # CF::Data wrapper
│       ├── date.rb               # CF::Date wrapper
│       ├── dictionary.rb         # CF::Dictionary wrapper
│       ├── exceptions.rb         # Custom exceptions
│       ├── memory.rb             # Memory management
│       ├── null.rb               # CF::Null wrapper
│       ├── number.rb             # CF::Number wrapper
│       ├── preferences.rb        # CF::Preferences utility
│       ├── range.rb              # CF::Range wrapper
│       ├── refinements.rb        # Ruby refinements
│       ├── register.rb           # Type registration
│       ├── string.rb             # CF::String wrapper
│       └── version.rb            # Version constants
├── spec/                         # RSpec test files
│   ├── spec_helper.rb            # Test configuration
│   └── *_spec.rb                 # Individual test files
├── corefoundation.gemspec        # Gem specification
├── Gemfile                       # Bundle dependencies
├── Rakefile                      # Build tasks (default: rspec)
├── README.md                     # Project documentation
├── CHANGELOG.md                  # Release history
├── VERSION                       # Current version
└── LICENSE                       # MIT License
```

## MCP Server Integration

### Atlassian MCP Server

When a Jira ID is provided, use the `atlassian-mcp` server to:

1. **Fetch Issue Details**: Use `mcp_atlassian-mcp_getJiraIssue` to retrieve the complete issue information
2. **Read the Story**: Parse the issue description, acceptance criteria, and any linked resources
3. **Implement the Task**: Follow the story requirements and implement the requested functionality
4. **Update Progress**: Use `mcp_atlassian-mcp_addCommentToJiraIssue` to add progress updates and completion status

## Development Workflow

### Complete Task Implementation Workflow

When implementing a task (especially with a Jira ID), follow these steps:

1. **Initialization**
   - Fetch Jira issue details using MCP server
   - Read and understand the requirements
   - Create a development branch using the Jira ID as the branch name

2. **Implementation**
   - Implement the requested functionality in appropriate files
   - Follow Ruby best practices and existing code patterns
   - Ensure FFI integration follows existing patterns
   - Handle memory management properly (retain/release)

3. **Testing**
   - Create comprehensive unit tests for new functionality
   - Ensure test coverage remains above 80%
   - Run existing tests to prevent regressions
   - Test on macOS (primary platform)

4. **Quality Assurance**
   - Run ChefStyle linting (`bundle exec chefstyle`)
   - Ensure DCO compliance in all commits
   - Update documentation if needed
   - Verify Expeditor labels are correctly applied

5. **Pull Request Creation**
   - Create PR using GitHub CLI
   - Include comprehensive description with HTML formatting
   - Link to Jira issue
   - Request appropriate reviews

### Prompt-Based Workflow

All tasks must be performed in a prompt-based manner:

- After each step, provide a clear summary of what was accomplished
- Prompt with the next step and remaining tasks
- Ask for confirmation before proceeding to the next step
- Allow for user input and adjustments at each stage

Example workflow prompts:
- "✅ Step 1 Complete: Fetched Jira issue ABC-123 and analyzed requirements. Next: Create branch and implement core functionality. Remaining: Testing, PR creation. Continue?"
- "✅ Step 2 Complete: Implemented CF::NewType wrapper class. Next: Create unit tests and ensure >80% coverage. Remaining: Documentation, PR creation. Continue?"

## Testing Requirements

### Unit Test Coverage

- **Minimum Coverage**: 80% or higher
- **Test Framework**: RSpec 3.x
- **Test Location**: `spec/` directory
- **Naming Convention**: `*_spec.rb`

### Test Development Guidelines

1. **Comprehensive Testing**
   - Test all public methods and interfaces
   - Include edge cases and error conditions
   - Test memory management (retain/release cycles)
   - Mock FFI interactions when appropriate

2. **Test Structure**
   - Follow existing test patterns in `spec/`
   - Use descriptive test names
   - Group related tests in contexts
   - Include setup and teardown as needed

3. **Running Tests**
   ```bash
   bundle exec rake spec        # Run all tests
   bundle exec rspec spec/file_spec.rb  # Run specific test
   ```

## GitHub Integration

### Branch Management and PR Creation

When prompted to create a PR:

1. **Authentication**
   - Use GitHub CLI for all operations
   - Authenticate using: `gh auth login`
   - Do NOT use `~/.profile` for authentication

2. **Branch Creation**
   ```bash
   git checkout -b JIRA-ID-description
   git add .
   git commit -s -m "feat: implement feature (JIRA-ID)"
   git push origin JIRA-ID-description
   ```

3. **PR Creation**
   ```bash
   gh pr create \
     --title "feat: Feature description (JIRA-ID)" \
     --body "$(cat pr_description.md)" \
     --assignee @me
   ```

### PR Description Format

Use HTML formatting for rich PR descriptions:

```html
<h2>Summary</h2>
<p>Brief description of changes made</p>

<h3>Changes Made</h3>
<ul>
  <li>Added new CF::Type wrapper class</li>
  <li>Implemented memory management</li>
  <li>Added comprehensive unit tests</li>
</ul>

<h3>Testing</h3>
<ul>
  <li>✅ Unit tests passing</li>
  <li>✅ Coverage >80%</li>
  <li>✅ ChefStyle linting passed</li>
</ul>

<h3>Related Issues</h3>
<p>Closes: <a href="jira-link">JIRA-ID</a></p>
```

### Repository Labels

Available GitHub labels for this repository:

**Aspect Labels:**
- `Aspect: Integration` - Works correctly with other projects or systems
- `Aspect: Packaging` - Distribution of compiled artifacts
- `Aspect: Performance` - Performance-related changes
- `Aspect: Portability` - Cross-platform compatibility
- `Aspect: Security` - Security-related improvements
- `Aspect: Stability` - Consistency and reliability
- `Aspect: Testing` - Test coverage and CI improvements
- `Aspect: UI` - User interface changes
- `Aspect: UX` - User experience improvements

**Expeditor Labels:**
- `Expeditor: Bump Version Major` - Triggers major version bump
- `Expeditor: Bump Version Minor` - Triggers minor version bump
- `Expeditor: Skip All` - Skips all merge actions
- `Expeditor: Skip Changelog` - Skips changelog update
- `Expeditor: Skip Version Bump` - Skips version bumping

**Platform Labels:**
- `Platform: macOS` - macOS-specific changes (primary platform)
- `Platform: Linux` - Linux compatibility
- `Platform: Unix-like` - General Unix compatibility

**Other Labels:**
- `documentation` - Documentation improvements
- `dependencies` - Dependency updates
- `oss-standards` - OSS repository standardization

## DCO Compliance Requirements

### Developer Certificate of Origin

All commits MUST include a DCO sign-off to certify that you have the right to submit the contribution under the project's license.

### DCO Sign-off Process

1. **Automatic Sign-off**
   ```bash
   git commit -s -m "commit message"
   ```

2. **Manual Sign-off**
   Add to commit message:
   ```
   Signed-off-by: Your Name <your.email@example.com>
   ```

3. **Retroactive Sign-off**
   ```bash
   git rebase --signoff HEAD~N  # N = number of commits to sign
   ```

### DCO Verification

- All commits in PRs must be signed off
- CI will verify DCO compliance
- PRs without proper sign-off will be blocked

## Build System Integration

### Expeditor Configuration

The repository uses Chef's Expeditor build system for automation:

**Automated Actions:**
- Version bumping on PR merge
- Changelog updates
- Gem building and publishing
- Slack notifications to `chef-found-notify`

**Version Management:**
- Semantic versioning (v1.0.0 format)
- Version controlled in `VERSION` file
- Automatic bumping based on PR labels

**Release Process:**
- PRs trigger version bump and build
- Promotion triggers RubyGems publication
- Changelog automatically maintained

### GitHub Actions

**Unit Test Workflow** (`.github/workflows/unit.yml`):
- Runs on PR and master branch pushes
- Tests Ruby 3.1 and 3.4 on macOS
- Uses `bundle exec rake spec`

## Code Quality Standards

### ChefStyle Linting

- **Linter**: ChefStyle 2.2.2 (RuboCop-based)
- **Command**: `bundle exec chefstyle`
- **Integration**: Must pass before merging

### Ruby Standards

- **Ruby Version**: >= 3.1
- **Dependencies**: FFI >= 1.15.0
- **Style**: Follow existing code patterns
- **Memory Management**: Proper retain/release cycles

### Documentation Standards

- **README**: Keep usage examples current
- **YARD**: Document public APIs
- **Comments**: Explain FFI bindings and memory management

## File Modification Restrictions

### Protected Files

Do NOT modify these files without explicit approval:
- `.expeditor/config.yml` - Build system configuration
- `corefoundation.gemspec` - Gem specification
- `VERSION` - Managed by Expeditor
- `.github/workflows/` - CI configuration

### Modification Guidelines

- **Source Code** (`lib/`): Free to modify for features
- **Tests** (`spec/`): Always update with code changes
- **Documentation**: Update when changing public APIs
- **Dependencies**: Require team approval for changes

## Additional Guidelines

### Memory Management

- Use proper FFI pointer handling
- Implement retain/release patterns
- Add finalizers for garbage collection
- Test memory leaks in long-running operations

### Platform Considerations

- **Primary Platform**: macOS (Core Foundation is macOS-specific)
- **Testing**: Focus on macOS compatibility
- **FFI**: Ensure proper macOS framework binding

### Performance

- Minimize FFI call overhead
- Cache frequently used CF objects
- Implement lazy loading where appropriate
- Profile memory usage for large collections

**Remember**: All tasks are prompt-based. Always summarize completed work, outline next steps, and ask for confirmation before proceeding. Maintain >80% test coverage and ensure DCO compliance in all commits.


## AI-Assisted Development & Compliance

- ✅ Create PR with `ai-assisted` label (if label doesn't exist, create it with description "Work completed with AI assistance following Progress AI policies" and color "9A4DFF")
- ✅ Include "This work was completed with AI assistance following Progress AI policies" in PR description

### Jira Ticket Updates (MANDATORY)

- ✅ **IMMEDIATELY after PR creation**: Update Jira ticket custom field `customfield_11170` ("Does this Work Include AI Assisted Code?") to "Yes"
- ✅ Use atlassian-mcp tools to update the Jira field programmatically
- ✅ **CRITICAL**: Use correct field format: `{"customfield_11170": {"value": "Yes"}}`
- ✅ Verify the field update was successful

### Documentation Requirements

- ✅ Reference AI assistance in commit messages where appropriate
- ✅ Document any AI-generated code patterns or approaches in PR description
- ✅ Maintain transparency about which parts were AI-assisted vs manual implementation

### Workflow Integration

This AI compliance checklist should be integrated into the main development workflow Step 4 (Pull Request Creation):

```
Step 4: Pull Request Creation & AI Compliance
- Step 4.1: Create branch and commit changes WITH SIGNED-OFF COMMITS
- Step 4.2: Push changes to remote
- Step 4.3: Create PR with ai-assisted label
- Step 4.4: IMMEDIATELY update Jira customfield_11170 to "Yes"
- Step 4.5: Verify both PR labels and Jira field are properly set
- Step 4.6: Provide complete summary including AI compliance confirmation
```

- **Never skip Jira field updates** - This is required for Progress AI governance
- **Always verify updates succeeded** - Check response from atlassian-mcp tools
- **Treat as atomic operation** - PR creation and Jira updates should happen together
- **Double-check before final summary** - Confirm all AI compliance items are completed

### Audit Trail

All AI-assisted work must be traceable through:

1. GitHub PR labels (`ai-assisted`)
2. Jira custom field (`customfield_11170` = "Yes")
3. PR descriptions mentioning AI assistance
4. Commit messages where relevant

---

*This document should be updated as the project evolves and new requirements emerge.*
