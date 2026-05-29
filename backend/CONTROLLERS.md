# Backend Controllers Documentation

All controllers are now properly organized following MVC architecture.

## Controllers Overview

### 1. Auth Controller (`controllers/auth.controller.js`)
Handles user authentication and registration.

**Functions:**
- `register(req, res)` - Register new user with email/phone
- `login(req, res)` - Authenticate user and return JWT token
- `getCurrentUser(req, res)` - Get authenticated user's profile

### 2. Category Controller (`controllers/category.controller.js`)
Manages photo categories and their members.

**Functions:**
- `listCategories(req, res)` - List all user's categories
- `createCategory(req, res)` - Create new category
- `getCategoryById(req, res)` - Get single category details
- `updateCategory(req, res)` - Update category info
- `deleteCategory(req, res)` - Delete category
- `addMember(req, res)` - Add user to category
- `removeMember(req, res)` - Remove user from category
- `listMembers(req, res)` - List all category members

### 3. Content Controller (`controllers/content.controller.js`)
Handles photo/video uploads and viewing.

**Functions:**
- `requestUpload(req, res)` - Request presigned upload URL
- `finalizeUpload(req, res)` - Finalize upload and save metadata
- `getViewUrl(req, res)` - Get content view URL
- `listCategoryContent(req, res)` - List all content in category
- `deleteContent(req, res)` - Delete content

### 4. Connection Controller (`controllers/connection.controller.js`)
Manages user connections and friend requests.

**Functions:**
- `listConnections(req, res)` - List all user connections
- `sendRequest(req, res)` - Send connection request
- `acceptRequest(req, res)` - Accept pending request
- `removeConnection(req, res)` - Remove connection

### 5. Creator Controller (`controllers/creator.controller.js`)
Handles creator monetization features.

**Functions:**
- `getDashboard(req, res)` - Get creator dashboard stats
- `listCampaigns(req, res)` - List creator's ad campaigns
- `requestPayout(req, res)` - Request earnings payout

## Routes Mapping

All routes are properly connected to their controllers:

```
/api/v1/auth/*          → auth.controller.js
/api/v1/categories/*    → category.controller.js
/api/v1/content/*       → content.controller.js
/api/v1/connections/*   → connection.controller.js
/api/v1/creator/*       → creator.controller.js
```

## Architecture Benefits

✅ **Separation of Concerns** - Routes handle HTTP, controllers handle business logic
✅ **Reusability** - Controllers can be used by multiple routes
✅ **Testability** - Easy to unit test controller functions
✅ **Maintainability** - Clear structure for adding new features
✅ **Error Handling** - Consistent error responses across all endpoints

## Next Steps

To extend functionality:
1. Add services layer for external integrations (MinIO, Stripe)
2. Add validation middleware for request data
3. Add models layer for complex data operations
4. Implement proper error handling middleware
