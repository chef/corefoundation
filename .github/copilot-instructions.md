# GitHub Copilot Instructions for CoreFoundation

## Repository Overview

**CoreFoundation** is a Ruby gem that provides FFI-based wrappers for a subset of macOS Core Foundation framework. It offers Ruby-like interfaces for CF collection classes including CFString, CFData, CFArray, and CFDictionary.

### Repository Structure

```
corefoundation/
├── .expeditor/              # Expeditor build system configuration
├── .github/                 # GitHub configuration and workflows
│   ├── CODEOWNERS          # Code ownership configuration
│   ├── ISSUE_TEMPLATE/     # Issue templates
│   ├── dependabot.yml     # Dependency management
│   └── workflows/          # GitHub Actions workflows
├── lib/                     # Main library code
│   ├── corefoundation.rb   # Main entry point
│   └── corefoundation/     # Core modules
│       ├── array.rb        # CF::Array wrapper
│       ├── base.rb         # CF::Base foundation class
│       ├── boolean.rb      # CF::Boolean wrapper
│       ├── data.rb         # CF::Data wrapper
│       ├── date.rb         # CF::Date wrapper
│       ├── dictionary.rb   # CF::Dictionary wrapper
│       ├── exceptions.rb   # Custom exceptions
│       ├── memory.rb       # Memory management
│       ├── null.rb         # CF::Null wrapper
│       ├── number.rb       # CF::Number wrapper
│       ├── preferences.rb  # Preferences interface
│       ├── range.rb        # CF::Range wrapper
│       ├── refinements.rb  # Ruby refinements
│       ├── register.rb     # Type registration
│       ├── string.rb       # CF::String wrapper
│       └── version.rb      # Version management
├── spec/                    # RSpec test suite
├── coverage/                # Test coverage reports
├── vendor/                  # Vendored dependencies
├── corefoundation.gemspec  # Gem specification
├── Gemfile                 # Bundle configuration
├── Rakefile               # Rake tasks
├── README.md              # Project documentation
├── CHANGELOG.md           # Change history
├── CONTRIBUTING.md        # Contribution guidelines
├── LICENSE                # MIT license
└── VERSION                # Version file
```

## Jira Integration Workflow

When a Jira ID is provided:

1. **Fetch Jira Issue Details**: Use the MCP atlassian-mcp-server to fetch the Jira issue details
   ```
   - Use mcp_atlassian-mcp_getJiraIssue with the provided issue ID
   - Read and understand the story requirements, acceptance criteria, and any linked documentation
   - Analyze the issue type (Bug, Story, Task, etc.) to determine the appropriate approach
   ```

2. **Implementation Planning**: Based on the Jira story:
   - Break down the requirements into actionable tasks
   - Identify which files need to be modified or created
   - Plan the implementation approach following Ruby and CoreFoundation best practices

## Testing Requirements

**CRITICAL**: All implementations must maintain test coverage > 80%

### Testing Standards:
- **Unit Tests**: Create comprehensive RSpec tests for all new functionality
- **Coverage**: Use SimpleCov to ensure > 80% code coverage
- **Test Files**: Place tests in `spec/` directory following the pattern `{module_name}_spec.rb`
- **Test Structure**: Follow RSpec best practices with proper `describe`, `context`, and `it` blocks
- **Edge Cases**: Include tests for edge cases, error conditions, and boundary values
- **Memory Management**: Test memory management for CF objects (retain/release cycles)

### Running Tests:
```bash
bundle exec rspec                    # Run all tests
bundle exec rspec spec/string_spec.rb # Run specific test file
```

### Coverage Check:
```bash
bundle exec rspec --format documentation
# Check coverage/index.html for detailed coverage report
```

## Git Workflow and PR Creation

### Branch Creation and Management:
```bash
# Create branch using Jira ID as branch name
git checkout -b {jiraId}

# Make your changes and commit with DCO compliance
git commit -s -m "feat: {jiraId} - Brief description of changes

Detailed description of what was implemented.

Signed-off-by: Your Name <your.email@example.com>"

# Push changes
git push origin {jiraId}
```

### Pull Request Creation:
Use GitHub CLI to create PRs with proper formatting:

```bash
# Create PR with HTML-formatted description
gh pr create \
  --title "{jiraId}: Brief title describing the change" \
  --body "
<h2>Summary</h2>
<p>Brief summary of changes made</p>

<h2>Changes Made</h2>
<ul>
<li>Detailed change 1</li>
<li>Detailed change 2</li>
<li>Detailed change 3</li>
</ul>

<h2>Testing</h2>
<ul>
<li>Added unit tests for new functionality</li>
<li>Coverage maintained > 80%</li>
<li>All existing tests pass</li>
</ul>

<h2>Jira Issue</h2>
<p>Resolves: {jiraId}</p>
" \
  --reviewer @chef/corefoundation-maintainers
```

## DCO Compliance Requirements

**MANDATORY**: All commits must be signed-off to comply with the Developer Certificate of Origin (DCO).

### DCO Compliance Rules:
- **Every commit** must include a `Signed-off-by` line
- Use the `-s` flag with git commit: `git commit -s -m "commit message"`
- The sign-off must match the commit author's email address
- For existing commits without sign-off, use `git commit --amend -s`

### DCO Sign-off Format:
```
Signed-off-by: Your Name <your.email@example.com>
```

### Fixing DCO Issues:
```bash
# For the last commit
git commit --amend -s

# For multiple commits, use interactive rebase
git rebase -i HEAD~n  # where n is number of commits
# Edit each commit to add sign-off
```

## Expeditor Build System Integration

The repository uses Chef's Expeditor build system for automated release management.

### Available Expeditor Labels:
- **Expeditor: Bump Version Major** - Triggers major version bump (X.0.0)
- **Expeditor: Bump Version Minor** - Triggers minor version bump (0.X.0)
- **Expeditor: Skip All** - Skips all merge actions
- **Expeditor: Skip Changelog** - Skips changelog update
- **Expeditor: Skip Habitat** - Skips Habitat package build
- **Expeditor: Skip Omnibus** - Skips Omnibus release build
- **Expeditor: Skip Version Bump** - Skips automatic version bumping

### Expeditor Workflow:
1. PRs are automatically processed by Expeditor on merge
2. Version bumps are determined by commit messages and labels
3. Changelog is automatically updated unless skipped
4. Use appropriate skip labels when testing or for documentation-only changes

## Repository-Specific GitHub Labels

### Aspect Labels:
- **Aspect: Integration** - Works correctly with other projects or systems
- **Aspect: Packaging** - Distribution of the project's compiled artifacts
- **Aspect: Performance** - Works without negatively affecting the system
- **Aspect: Portability** - Platform compatibility concerns
- **Aspect: Security** - Security-related changes or concerns
- **Aspect: Stability** - Consistent results and reliability
- **Aspect: Testing** - Test coverage and CI improvements
- **Aspect: UI** - User interface interaction and visual design
- **Aspect: UX** - User experience, ease-of-use, and accessibility

### Platform Labels:
- **Platform: macOS** - macOS-specific functionality (primary platform)
- **Platform: Linux** - Linux compatibility
- **Platform: Unix-like** - Unix-like systems
- **Platform: AWS/Azure/GCP** - Cloud platform specific
- **Platform: Docker** - Container-related changes

### Special Labels:
- **dependencies** - Dependency updates (auto-applied by Dependabot)
- **documentation** - Documentation improvements
- **oss-standards** - OSS repository standardization
- **hacktoberfest-accepted** - Accepted Hacktoberfest contributions

## Prompt-Based Workflow

### Step-by-Step Task Execution:

All tasks must follow this prompt-based approach:

1. **After Each Step**: Provide a summary of what was completed
2. **Next Steps**: Clearly state what the next step will be
3. **Remaining Tasks**: List all remaining steps to complete the task
4. **Confirmation**: Ask "Do you want to continue with the next step?" before proceeding

### Example Workflow Pattern:
```
✅ **Step 1 Completed**: Fetched Jira issue details and understood requirements
📋 **Summary**: Issue XYZ-123 requires implementing a new CF::Set wrapper class

🔄 **Next Step**: Create the basic CF::Set class structure in lib/corefoundation/set.rb
📋 **Remaining Steps**: 
   - Implement core set methods (add, remove, contains)
   - Add memory management
   - Create comprehensive unit tests
   - Update documentation
   - Run tests and verify coverage > 80%

❓ **Do you want to continue with the next step?**
```

## Complete Implementation Workflow

### 1. Task Analysis Phase
- [ ] Fetch and analyze Jira issue using atlassian-mcp-server
- [ ] Understand requirements and acceptance criteria
- [ ] Identify files that need modification
- [ ] Plan implementation approach
- [ ] **Ask**: "Do you want to continue with implementation planning?"

### 2. Development Phase
- [ ] Create feature branch using Jira ID
- [ ] Implement core functionality following Ruby/CF patterns
- [ ] Ensure proper memory management for CF objects
- [ ] Follow existing code style and patterns
- [ ] **Ask**: "Do you want to continue with test creation?"

### 3. Testing Phase
- [ ] Create comprehensive unit tests in spec/ directory
- [ ] Test edge cases and error conditions
- [ ] Verify memory management (retain/release)
- [ ] Run tests: `bundle exec rspec`
- [ ] Check coverage > 80% requirement
- [ ] **Ask**: "Do you want to continue with documentation updates?"

### 4. Documentation Phase
- [ ] Update README.md if public API changes
- [ ] Add YARD documentation for new methods
- [ ] Update CHANGELOG.md with changes
- [ ] **Ask**: "Do you want to continue with final validation?"

### 5. Final Validation Phase
- [ ] Run full test suite
- [ ] Verify code style with ChefStyle: `bundle exec chefstyle`
- [ ] Check all files pass linting
- [ ] Validate DCO compliance on all commits
- [ ] **Ask**: "Do you want to create the pull request?"

### 6. Pull Request Phase
- [ ] Commit changes with proper DCO sign-off
- [ ] Push branch to origin
- [ ] Create PR using GitHub CLI with HTML description
- [ ] Apply appropriate GitHub labels
- [ ] Request review from maintainers

### Prohibited File Modifications:
- **DO NOT** modify: `.expeditor/`, workflow files, or build configuration without explicit approval
- **BE CAREFUL** with: Version files, gemspec, core FFI bindings
- **SAFE TO MODIFY**: Library code in `lib/corefoundation/`, test files in `spec/`, documentation

## Ruby and CoreFoundation Specific Guidelines

### Code Style:
- Follow ChefStyle (RuboCop) guidelines
- Use Ruby 3.1+ features when appropriate
- Maintain FFI compatibility
- Follow existing memory management patterns

### CoreFoundation Patterns:
- Inherit from `CF::Base` for new CF wrapper classes
- Implement `to_ruby` method for Ruby object conversion
- Add corresponding `to_cf` method to Ruby classes
- Use proper retain/release for memory management
- Follow existing naming conventions (CF::ClassName)

### Testing Patterns:
- Test both CF object creation and Ruby conversion
- Test memory management (no leaks)
- Test edge cases with nil, empty, and invalid inputs
- Mock FFI calls when appropriate
- Use shared examples for common CF behaviors

This instruction set ensures consistent, high-quality contributions to the CoreFoundation project while maintaining proper integration with Chef's development workflow and tools.