```sh
# Verbose mode - displays detailed steps
./bootstrap.sh --verbose
./bootstrap.sh -v

# Debug mode - displays everything + executed bash commands
./bootstrap.sh --debug
./bootstrap.sh -d

# Help
./bootstrap.sh --help
./bootstrap.sh -h
```

**What is logged**:
- `log_verbose()`: Detailed steps, file paths, versions
- `log_debug()`: Internal variables, executed commands
- `log_error()`: Critical errors

**Example output in verbose mode**:
```
[VERBOSE] Checking prerequisites...
[VERBOSE] Checking for git...
✓ git is installed (version: 2.42.0)
[VERBOSE]   Path: /usr/bin/git
[VERBOSE] All prerequisites satisfied
[VERBOSE] Starting project configuration...
[DEBUG] Project name selected: my-app
[DEBUG] Monorepo selected: true
[DEBUG] Stack selected: vue fastapi
```

### 2. **Prerequisites validation** ✅

**New module**: `lib/validator.sh`

**Tools checked**:
- ✅ **git** - Version control
- ✅ **make** - Build tool
- ✅ **curl** - HTTP client

**Features**:
- Detects if the tool is installed
- Displays the installed version
- Provides installation instructions by OS (macOS, Debian, RedHat)
- Checks available disk space (warning if < 100MB)
- Tests network connectivity to GitHub

**Example output**:
```
🔍 Validating Prerequisites
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Checking for git...
✓ git is installed (version: 2.42.0)

Checking for make...
✓ make is installed (version: 4.3)

Checking for curl...
✓ curl is installed (version: 8.1.2)

✓ All prerequisites are satisfied!
```

**If a tool is missing**:
```
✗ make is not installed
  Description: GNU Make build tool
  Install: sudo apt-get install build-essential

✗ Some prerequisites are missing. Please install them and try again.
```