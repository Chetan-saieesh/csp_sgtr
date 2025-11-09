# SMART GROCERY TRACKING & REPORTING FOR SCHOOLS - Setup Guide

## 1. MongoDB Atlas Setup

### Step 1: Create MongoDB Atlas Account
1. Go to [MongoDB Atlas](https://www.mongodb.com/cloud/atlas)
2. Sign up for a free account
3. Create a new cluster (free tier is sufficient)

### Step 2: Configure Database Access
1. Go to "Database Access" in the left sidebar
2. Click "Add New Database User"
3. Create a user with username and password
4. Grant "Atlas Admin" role or create a custom role with read/write permissions

### Step 3: Configure Network Access
1. Go to "Network Access" in the left sidebar
2. Click "Add IP Address"
3. For development, click "Allow Access from Anywhere" (0.0.0.0/0)
4. For production, add specific IP addresses

### Step 4: Get Connection String
1. Go to "Database" and click "Connect" on your cluster
2. Choose "Connect your application"
3. Copy the connection string
4. Replace `<password>` with your database user password
5. Replace `<database>` with `smartgrocery` or your preferred database name

### Step 5: Update Connection String in App
1. Open `lib/config/database_config.dart`
2. Replace the `connectionString` with your MongoDB Atlas connection string:

```dart
static const String connectionString =
    'mongodb+srv://your-username:your-password@cluster.mongodb.net/smartgrocery?retryWrites=true&w=majority';
```

## 2. Create Test Users in MongoDB

### Using MongoDB Compass (Recommended)
1. Download and install [MongoDB Compass](https://www.mongodb.com/products/compass)
2. Connect to your MongoDB Atlas cluster using the connection string
3. Create a database named `smartgrocery`
4. Create collections: `users`, `grocery_usage`, `reports`

### Insert Test Users

#### Create Authority User
```javascript
db.users.insertOne({
  _id: "auth001",
  username: "authority1",
  password: "password123",
  role: "authority",
  name: "Authority User",
  email: "authority@example.com"
});
```

#### Create Teacher User
```javascript
db.users.insertOne({
  _id: "teacher001",
  username: "teacher1",
  password: "password123",
  role: "teacher",
  authorityId: "auth001",
  name: "Teacher User",
  email: "teacher@example.com"
});
```

**Note:** Replace `"auth001"` in the teacher's `authorityId` field with the actual `_id` of the authority user you created.

### Using MongoDB Shell (mongosh)
1. Install MongoDB Shell or use MongoDB Atlas web shell
2. Connect to your cluster
3. Run the same insert commands as above

## 3. Flutter Setup

### Prerequisites
- Flutter SDK 3.0.0 or higher
- Dart SDK
- Chrome browser (for web development)

### Installation Steps

1. **Install Dependencies**
   ```bash
   flutter pub get
   ```

2. **Enable Web Support** (if not already enabled)
   ```bash
   flutter config --enable-web
   ```

3. **Run the App**
   ```bash
   flutter run -d chrome
   ```

## 4. Testing the Application

### Login as Teacher
- Username: `teacher1`
- Password: `password123`

**Teacher Features:**
- Add daily grocery usage
- Generate reports for date ranges
- View report history
- Submit reports to authority

### Login as Authority
- Username: `authority1`
- Password: `password123`

**Authority Features:**
- View all teachers under their supervision
- View submitted reports
- Filter reports by teacher
- Update report status

## 5. Important Notes

### Security Considerations
1. **Passwords**: Currently stored in plain text. For production:
   - Use password hashing (bcrypt, argon2)
   - Implement secure authentication (JWT tokens)
   - Use HTTPS for all connections

2. **Connection String**: Never commit real credentials to version control
   - Use environment variables
   - Use secure configuration files
   - Consider using a secrets management service

3. **Database Security**:
   - Use database user with minimal required permissions
   - Enable MongoDB Atlas security features
   - Regularly update database passwords

### Flutter Web Limitations
- The `mongo_dart` package may have limitations with Flutter web
- For production, consider using a REST API backend:
  - Create a Node.js/Express backend
  - Use MongoDB Node.js driver
  - Expose REST endpoints
  - Use HTTP package in Flutter to call the API

### Alternative Architecture (Recommended for Production)
```
Flutter Web App
    ↓ (HTTP requests)
REST API Backend (Node.js/Express)
    ↓ (MongoDB Driver)
MongoDB Atlas
```

This architecture provides:
- Better security
- Easier deployment
- Better error handling
- Scalability

## 6. Troubleshooting

### MongoDB Connection Issues
- Check if your IP is whitelisted in MongoDB Atlas
- Verify connection string format
- Check database user permissions
- Verify network connectivity

### Flutter Web Issues
- Clear browser cache
- Run `flutter clean` and `flutter pub get`
- Check browser console for errors
- Verify all dependencies are compatible with web

### Authentication Issues
- Verify users exist in MongoDB
- Check username and password are correct
- Verify role field is set correctly
- Check authorityId for teachers matches authority _id

## 7. Next Steps

1. Implement password hashing
2. Add input validation
3. Add error handling and user feedback
4. Implement report export (PDF/Excel)
5. Add data visualization (charts)
6. Implement notifications
7. Add mobile app support (if needed)
8. Deploy to production server

