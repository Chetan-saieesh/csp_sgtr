# GitHub Setup Instructions

## Step 1: Create GitHub Repository

1. Go to [GitHub](https://github.com) and sign in
2. Click the "+" icon in the top right corner
3. Select "New repository"
4. Fill in the repository details:
   - **Repository name**: `mid-day-meal-app` (or your preferred name)
   - **Description**: "Flutter web application for managing mid-day meal grocery usage updates"
   - **Visibility**: Choose Public or Private
   - **DO NOT** initialize with README, .gitignore, or license (we already have these)
5. Click "Create repository"

## Step 2: Add Remote and Push

After creating the repository, GitHub will show you commands. Use these commands:

```bash
# Add your GitHub repository as remote (replace YOUR_USERNAME with your GitHub username)
git remote add origin https://github.com/YOUR_USERNAME/mid-day-meal-app.git

# Rename branch to main (if needed)
git branch -M main

# Push to GitHub
git push -u origin main
```

## Alternative: Using SSH

If you have SSH keys set up with GitHub:

```bash
# Add remote using SSH
git remote add origin git@github.com:YOUR_USERNAME/mid-day-meal-app.git

# Push to GitHub
git push -u origin main
```

## Step 3: Verify

1. Go to your GitHub repository page
2. Verify all files are uploaded
3. Check that the README.md is displayed

## Important Security Notes

⚠️ **Warning**: The current `database_config.dart` file contains your Supabase credentials:
- Supabase URL: `https://eezbbodfhlnrgrlzeapy.supabase.co`
- Anon Key: (your anon key)

### For Production/Public Repositories:

1. **Option 1: Use Environment Variables**
   - Remove credentials from `database_config.dart`
   - Use environment variables or build-time configuration
   - Add `database_config.dart` to `.gitignore`

2. **Option 2: Use Example File**
   - Keep `database_config.example.dart` in the repository
   - Add `database_config.dart` to `.gitignore`
   - Document that users need to create their own config file

3. **Option 3: Keep as-is (Acceptable for Anon Key)**
   - The anon key is meant to be public (client-side)
   - It's safe to commit to public repositories
   - Just make sure you never commit service role keys

## Next Steps After Pushing

1. Update repository description and topics on GitHub
2. Add a license file (MIT, Apache, etc.)
3. Set up GitHub Actions for CI/CD (optional)
4. Enable GitHub Pages if you want to host the web app (optional)
5. Add collaborators if working in a team

## Troubleshooting

### Authentication Issues

If you get authentication errors:

1. **Use Personal Access Token**:
   - Go to GitHub Settings → Developer settings → Personal access tokens
   - Generate a new token with `repo` permissions
   - Use the token as password when pushing

2. **Use GitHub CLI**:
   ```bash
   gh auth login
   git push -u origin main
   ```

### Branch Name Issues

If your default branch is `master` instead of `main`:

```bash
git branch -M main
git push -u origin main
```

### Large Files

If you have large files, consider using Git LFS:

```bash
git lfs install
git lfs track "*.pdf"
git lfs track "*.zip"
git add .gitattributes
git commit -m "Add Git LFS tracking"
```

