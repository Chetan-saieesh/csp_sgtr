# Git Setup Commands

## Step 1: Configure Git (Required)

Before committing, you need to set your Git identity. Run these commands:

```bash
# Set your name (replace with your actual name)
git config --global user.name "Your Name"

# Set your email (replace with your GitHub email)
git config --global user.email "your.email@example.com"
```

**Important**: Use the email address associated with your GitHub account.

## Step 2: Commit the Code

After setting up Git, run:

```bash
git commit -m "Initial commit: SMART GROCERY TRACKING & REPORTING FOR SCHOOLS with Supabase"
```

## Step 3: Create GitHub Repository

1. Go to https://github.com and sign in
2. Click the "+" icon → "New repository"
3. Name it: `smart-grocery-tracking-app` (or your preferred name)
4. Choose Public or Private
5. **DO NOT** initialize with README, .gitignore, or license
6. Click "Create repository"

## Step 4: Push to GitHub

After creating the repository, run these commands (replace YOUR_USERNAME with your GitHub username):

```bash
# Add remote repository
git remote add origin https://github.com/YOUR_USERNAME/smart-grocery-tracking-app.git

# Rename branch to main
git branch -M main

# Push to GitHub
git push -u origin main
```

## Complete Command Sequence

Here's the complete sequence of commands:

```bash
# 1. Configure Git (one time only)
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"

# 2. Commit (already staged)
git commit -m "Initial commit: SMART GROCERY TRACKING & REPORTING FOR SCHOOLS with Supabase"

# 3. Add remote (after creating GitHub repo)
git remote add origin https://github.com/YOUR_USERNAME/smart-grocery-tracking-app.git

# 4. Rename branch
git branch -M main

# 5. Push to GitHub
git push -u origin main
```

## Authentication

When you push, GitHub may ask for credentials:
- **Username**: Your GitHub username
- **Password**: Use a Personal Access Token (not your GitHub password)
  - Create one at: https://github.com/settings/tokens
  - Select `repo` scope

## Troubleshooting

If you get authentication errors, use GitHub CLI or Personal Access Token.
See GITHUB_SETUP.md for detailed instructions.

