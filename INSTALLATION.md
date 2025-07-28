# ReruRO Backend Installation Guide

## Prerequisites

### Option 1: Install Deno (Recommended)

1. **Windows (PowerShell)**
```powershell
irm https://deno.land/x/install/install.ps1 | iex
```

2. **Windows (Chocolatey)**
```powershell
choco install deno
```

3. **Windows (Scoop)**
```powershell
scoop install deno
```

4. **macOS (Homebrew)**
```bash
brew install deno
```

5. **Linux/macOS (Shell)**
```bash
curl -fsSL https://deno.land/x/install/install.sh | sh
```

### Option 2: Use Node.js (Alternative)

If you prefer to use Node.js instead of Deno, you can use the provided `package.json` file:

```bash
npm install
npm run dev
```

## Verify Installation

After installing Deno, verify it's working:

```bash
deno --version
```

You should see output similar to:
```
deno 1.x.x (release, x86_64-unknown-linux-gnu)
v8 x.x.x
typescript x.x.x
```

## Project Setup

1. **Clone the repository** (if not already done):
```bash
git clone <repository-url>
cd RetuRO
```

2. **Create environment file**:
```bash
cp env.example .env
```

3. **Cache dependencies** (Deno will download them automatically):
```bash
deno cache src/main.ts
```

4. **Run the development server**:
```bash
deno task dev
```

## Troubleshooting

### Deno not found
- Make sure Deno is installed and added to your PATH
- Restart your terminal after installation
- On Windows, you may need to restart your computer

### Permission errors
- Deno requires explicit permissions for network, file system, and environment access
- The `deno.json` file includes the necessary permissions in the scripts

### Port already in use
- Change the PORT in your `.env` file
- Or kill the process using the port: `lsof -ti:8000 | xargs kill -9`

## Next Steps

Once the server is running, you can:

1. **Test the health endpoint**:
```bash
curl http://localhost:8000/health
```

2. **Test the API endpoints**:
```bash
curl http://localhost:8000/api/users
```

3. **Run tests**:
```bash
deno task test
```

## Development

- The server will automatically reload when you make changes (in dev mode)
- Check the console for request logs
- Use the provided TypeScript types for better development experience 